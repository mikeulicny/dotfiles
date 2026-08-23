import QtQuick
import Quickshell.Networking
import "Ui"

WidgetButton {
  id: root

  readonly property bool onWifi: connectedDevice !== null && connectedDevice.type === DeviceType.Wifi
  readonly property real signalStrength: wifiNetwork !== null ? wifiNetwork.signalStrength : 0

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

  Icon {
    size: 16
    name: {
      if (root.connectedDevice && root.connectedDevice.type === DeviceType.Wired)
        return "network.svg"
      return root.wifiIcon(root.signalStrength)
    }
  }
}
