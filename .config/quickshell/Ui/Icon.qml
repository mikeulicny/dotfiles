pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import qs

Item {
  id: root

  property string name
  property color color: Styles.foreground
  property real size: 24

  implicitWidth: size
  implicitHeight: size

  IconImage {
    id: image
    anchors.fill: parent
    implicitSize: root.size

    source: {
      if (!root.name) return ""
      let name = root.name
      if (!name.endsWith(".svg")) name += ".svg"
      return Qt.resolvedUrl("../assets/" + name)
    }

    layer.enabled: true
    layer.effect: MultiEffect {
      colorization: 1.0
      colorizationColor: root.color
      brightness: 1.0
    }
  }
}
