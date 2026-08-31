import QtQuick
import Quickshell.Services.UPower
import qs.Ui

Item {
  id: root

  property var bar: null

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
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

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

  WidgetButton {
    id: button
    bar: root.bar
    popup: panel

    Icon {
      size: 16
      name: root.batteryIcon()
    }
  }

  WidgetPanel {
    id: panel
    bar: root.bar
    anchorItem: button
  }
}
