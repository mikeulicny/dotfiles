import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import qs
import qs.Services
import qs.Ui

Item {
  id: root

  property var bar: null

  readonly property bool onWifi: connectedDevice !== null && connectedDevice.type === DeviceType.Wifi
  readonly property real signalStrength: wifiNetwork !== null ? wifiNetwork.signalStrength : 0

  readonly property var connectedDevice: NetworkService.connectedDevice

  readonly property var wifiNetwork: {
    if (!onWifi || !connectedDevice)
      return null
    var networks = connectedDevice.networks.values
    for (var i = 0; i < networks.length; i++) {
      if (networks[i].connected)
        return networks[i]
    }
    return null
  }

  function wifiIcon(strength) {
    if (strength > 0.75)
      return "wifi.svg"
    if (strength > 0.5)
      return "wifi-high.svg"
    if (strength > 0.25)
      return "wifi-low.svg"
    return "wifi-zero.svg"
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    bar: root.bar
    popup: panel

    Icon {
      size: 16
      name: {
        if (root.connectedDevice && root.connectedDevice.type === DeviceType.Wired)
          return "network.svg"
        return root.wifiIcon(root.signalStrength)
      }
    }
  }

  WidgetPanel {
    id: panel
    bar: root.bar
    anchorItem: button

    GridLayout {
      columns: 4
      columnSpacing: 20
      rowSpacing: 6

      Repeater {
        model: [
          ["Ping", NetworkService.pingText],
          ["Packet loss", NetworkService.packetLossText],
          ["Receiving", NetworkService.rxRateText],
          ["Sending", NetworkService.txRateText],
          ["Downloaded", NetworkService.rxTotalText],
          ["Uploaded", NetworkService.txTotalText],
          ["IP address", NetworkService.ipText],
          ["Gateway", NetworkService.gatewayText]
        ]

        RowLayout {
          required property var modelData
          Layout.fillWidth: true
          Layout.columnSpan: 2
          spacing: 10

          Text {
            text: modelData[0]
            color: Styles.secondary
            font.pointSize: Styles.font.sm
          }

          Text {
            Layout.fillWidth: true
            text: modelData[1]
            color: Styles.foreground
            font.pointSize: Styles.font.sm
            horizontalAlignment: Text.AlignRight
          }
        }
      }
    }
  }
}
