import QtQuick
import Quickshell.Bluetooth
import "Ui"

WidgetButton {
  id: root

  readonly property bool deviceConnected: {
    var devices = Bluetooth.devices.values
    for (var i = 0; i < devices.length; i++) {
      if (devices[i].connected)
        return true
    }
    return false
  }

  Icon {
    size: 16
    name: root.deviceConnected ? "bluetooth-connected.svg" : "bluetooth.svg"
  }
}
