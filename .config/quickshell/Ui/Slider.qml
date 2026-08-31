import QtQuick
import qs

Item {
  id: root

  property real from: 0
  property real to: 1
  property real value: 0
  override property bool enabled: true

  readonly property bool pressed: drag.pressed
  readonly property real normalized: {
    var span = to - from
    if (span === 0)
      return 0
    var n = (value - from) / span
    return Math.max(0, Math.min(1, n))
  }

  signal moved()

  implicitWidth: 180
  implicitHeight: 10

  function setFromX(x) {
    var span = root.to - root.from
    var n = root.width > 0 ? x / root.width : 0
    n = Math.max(0, Math.min(1, n))
    root.value = root.from + n * span
    root.moved()
  }

  Rectangle {
    anchors.fill: parent
    radius: height / 2
    color: Styles.border

    Rectangle {
      anchors {
        left: parent.left
        top: parent.top
        bottom: parent.bottom
      }
      width: parent.width * root.normalized
      radius: parent.radius
      color: Styles.foreground
    }
  }

  MouseArea {
    id: drag
    anchors.fill: parent
    enabled: root.enabled
    hoverEnabled: true
    onPressed: root.setFromX(mouse.x)
    onPositionChanged: {
      if (pressed)
        root.setFromX(mouse.x)
    }
  }
}
