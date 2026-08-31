import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs

AbstractButton {
  id: root

  property bool current: false
  default property alias content: body.data

  hoverEnabled: true
  verticalPadding: 8
  horizontalPadding: 16
  opacity: enabled ? 1 : 0.35
  implicitWidth: Math.max(30, Math.ceil(body.implicitWidth) + leftPadding + rightPadding)
  implicitHeight: Math.max(30, Math.ceil(body.implicitHeight) + topPadding + bottomPadding)

  background: Rectangle {
    radius: Styles.radius
    color: {
      if (!root.enabled)
        return Styles.transparent
      if (root.current || root.hovered)
        return Styles.fill
      return Styles.transparent
    }
  }

  contentItem: RowLayout {
    id: body
    spacing: 8
  }
}
