pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs
import qs.Services

PopupWindow {
  id: root

  required property Item anchorItem
  property QtObject bar: null
  property int margin: -8
  property int padding: Styles.panelPadding

  function open() { Popups.show(root) }
  function close() { Popups.hide(root) }
  function toggle() { Popups.toggle(root) }

  visible: false
  grabFocus: true

  onVisibleChanged: {
    if (!root.visible && Popups.current === root)
      Popups.current = null
  }

  anchor {
    item: anchorItem
    edges: Edges.Bottom | Edges.Left
    margins.bottom: root.margin
  }

  implicitWidth: 380
  implicitHeight: Math.ceil(body.implicitHeight) + padding * 2
  // Window stays square; rounding lives on the fill rect.
  color: "transparent"

  default property alias content: body.data

  function fillChildWidth(item) {
    if (item && item.width !== undefined)
      item.width = Qt.binding(function() { return body.width })
  }

  Rectangle {
    anchors.fill: parent
    radius: Styles.radiusPanel
    color: Styles.background
    border.width: 1
    border.color: Styles.border

    Column {
      id: body
      x: root.padding
      y: root.padding
      width: parent.width - root.padding * 2

      onChildrenChanged: {
        for (var i = 0; i < children.length; i++)
          root.fillChildWidth(children[i])
      }
    }
  }
}
