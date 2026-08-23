import QtQuick
import Quickshell.Services.UPower
import "Ui"

WidgetButton {
  id: root

  readonly property var battery: UPower.displayDevice
  readonly property bool hasBattery: battery && battery.ready && battery.isLaptopBattery
  readonly property bool pluggedIn: !UPower.onBattery
  readonly property real percent: {
    if (!hasBattery)
      return 0
    var value = battery.percentage
    return value <= 1 ? value * 100 : value
  }

  visible: hasBattery

  function batteryIcon() {
    if (root.pluggedIn)
      return "battery-charging.svg"
    if (root.percent >= 75)
      return "battery-full.svg"
    if (root.percent >= 50)
      return "battery-medium.svg"
    if (root.percent >= 25)
      return "battery-low.svg"
    return "battery-warning.svg"
  }

  Icon {
    size: 16
    name: root.batteryIcon()
  }
}
