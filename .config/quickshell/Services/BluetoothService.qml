pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
  id: root

  readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
  readonly property bool available: adapter !== null
  readonly property bool enabled: adapter ? adapter.enabled : false
  readonly property bool discovering: adapter ? adapter.discovering : false
  readonly property var devices: Bluetooth.devices ? Bluetooth.devices.values : []

  function isAddressLike(value) {
    return /^([0-9a-f]{2}[:-]){5}[0-9a-f]{2}$/i.test(String(value || "").trim())
  }

  function deviceName(device) {
    if (!device)
      return ""
    var candidates = [device.deviceName, device.name]
    for (var i = 0; i < candidates.length; i++) {
      var name = String(candidates[i] || "").trim()
      if (name !== "" && name !== device.address && !isAddressLike(name))
        return name
    }
    return ""
  }

  function deviceAddress(device) {
    return device && device.address ? device.address : ""
  }

  function deviceLabel(device) {
    var name = deviceName(device)
    if (name !== "")
      return name
    return deviceAddress(device) || "Device"
  }

  function isRemembered(device) {
    if (!device)
      return false
    return device.connected || device.paired || device.bonded || device.trusted
  }

  function refresh() {
    if (!adapter || !adapter.enabled)
      return
    adapter.discovering = false
    Qt.callLater(function() {
      if (root.adapter && root.adapter.enabled)
        root.adapter.discovering = true
    })
  }

  function setDiscovering(on) {
    if (!adapter || !adapter.enabled)
      return
    adapter.discovering = on
  }

  function activateDevice(device) {
    if (!device)
      return
    if (device.connected)
      device.disconnect()
    else if (device.paired || device.bonded || device.trusted)
      device.connect()
    else
      device.pair()
  }
}
