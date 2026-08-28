pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking

Singleton {
  id: root

  readonly property var connectedDevice: {
    var devices = Networking.devices.values
    for (var i = 0; i < devices.length; i++) {
      if (devices[i].connected && devices[i].type === DeviceType.Wired)
        return devices[i]
    }
    for (var i = 0; i < devices.length; i++) {
      if (devices[i].connected && devices[i].type === DeviceType.Wifi)
        return devices[i]
    }
    return null
  }

  readonly property string iface: connectedDevice ? connectedDevice.name : ""
  property string ip: ""
  property string gateway: ""

  property real pingMs: -1
  property real packetLoss: 0
  property real rxRate: 0
  property real txRate: 0
  property real rxBytes: 0
  property real txBytes: 0

  property real lastRx: -1
  property real lastTx: -1
  property real lastRxMs: 0
  property real lastTxMs: 0
  property var pingWindow: []

  readonly property string pingText: pingMs >= 0 ? Math.round(pingMs) + " ms" : "—"
  readonly property string packetLossText: pingWindow.length > 0 ? Math.round(packetLoss) + " %" : "—"
  readonly property string rxRateText: formatMBps(rxRate)
  readonly property string txRateText: formatMBps(txRate)
  readonly property string rxTotalText: formatData(rxBytes)
  readonly property string txTotalText: formatData(txBytes)
  readonly property string ipText: ip !== "" ? ip : "—"
  readonly property string gatewayText: gateway !== "" ? gateway : "—"

  function formatMBps(bytesPerSec) {
    return (bytesPerSec / (1024 * 1024)).toFixed(2) + " MB/s"
  }

  function formatData(bytes) {
    var units = ["kB", "MB", "GB", "TB"]
    var value = bytes / 1024
    var unit = 0
    while (value >= 1024 && unit < units.length - 1) {
      value /= 1024
      unit++
    }
    var digits = value >= 100 ? 0 : (value >= 10 ? 1 : 2)
    return value.toFixed(digits) + " " + units[unit]
  }

  function resetStats() {
    ip = ""
    gateway = ""
    pingMs = -1
    packetLoss = 0
    rxRate = 0
    txRate = 0
    rxBytes = 0
    txBytes = 0
    pingWindow = []
    lastRx = -1
    lastTx = -1
    lastRxMs = 0
    lastTxMs = 0
  }

  function recordPing(ok, ms) {
    var window = pingWindow.slice()
    window.push(ok)
    if (window.length > 20)
      window.shift()
    pingWindow = window
    var lost = 0
    for (var i = 0; i < window.length; i++) {
      if (!window[i])
        lost++
    }
    packetLoss = window.length > 0 ? (lost / window.length) * 100 : 0
    if (ok)
      pingMs = ms
  }

  function applyBytes(kind, raw) {
    var value = Number(String(raw).trim())
    if (!isFinite(value))
      return
    var now = Date.now()
    if (kind === "rx") {
      if (lastRx >= 0 && lastRxMs > 0) {
        var dt = Math.max(0.001, (now - lastRxMs) / 1000)
        var d = value - lastRx
        rxRate = d >= 0 ? d / dt : 0
      }
      rxBytes = value
      lastRx = value
      lastRxMs = now
    } else {
      if (lastTx >= 0 && lastTxMs > 0) {
        var dtTx = Math.max(0.001, (now - lastTxMs) / 1000)
        var dTx = value - lastTx
        txRate = dTx >= 0 ? dTx / dtTx : 0
      }
      txBytes = value
      lastTx = value
      lastTxMs = now
    }
  }

  function parsePing(raw) {
    var match = String(raw).match(/time[=<]([0-9.]+)/)
    if (match)
      recordPing(true, Number(match[1]))
    else
      recordPing(false, -1)
  }

  function parseGateway(raw) {
    try {
      var routes = JSON.parse(String(raw))
      if (routes && routes.length > 0 && routes[0].gateway)
        gateway = routes[0].gateway
      else
        gateway = ""
    } catch (e) {
      gateway = ""
    }
  }

  function parseAddress(raw) {
    try {
      var ifaces = JSON.parse(String(raw))
      for (var i = 0; i < ifaces.length; i++) {
        var infos = ifaces[i].addr_info || []
        for (var j = 0; j < infos.length; j++) {
          if (infos[j].family === "inet" && infos[j].local) {
            ip = String(infos[j].local).split("/")[0]
            return
          }
        }
      }
    } catch (e) {
    }
    ip = ""
  }

  onIfaceChanged: resetStats()

  FileView {
    id: rxFile
    path: root.iface !== "" ? "/sys/class/net/" + root.iface + "/statistics/rx_bytes" : ""
    printErrors: false
    onLoaded: root.applyBytes("rx", text())
  }

  FileView {
    id: txFile
    path: root.iface !== "" ? "/sys/class/net/" + root.iface + "/statistics/tx_bytes" : ""
    printErrors: false
    onLoaded: root.applyBytes("tx", text())
  }

  Process {
    id: pingProc
    command: ["ping", "-n", "-c", "1", "-W", "1", "1.1.1.1"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.parsePing(text)
    }
  }

  Process {
    id: gatewayProc
    command: ["ip", "-j", "-4", "route", "show", "default"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.parseGateway(text)
    }
  }

  Process {
    id: ipProc
    command: ["ip", "-j", "-4", "addr", "show", "dev", root.iface]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.parseAddress(text)
    }
  }

  Timer {
    interval: 1500
    running: true
    repeat: true
    onTriggered: {
      if (root.iface === "") {
        root.resetStats()
        return
      }
      if (!pingProc.running)
        pingProc.running = true
      if (!gatewayProc.running)
        gatewayProc.running = true
      if (!ipProc.running)
        ipProc.running = true
      rxFile.reload()
      txFile.reload()
    }
  }
}
