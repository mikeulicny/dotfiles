pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.Services
import qs.Ui

Scope {
  id: root
  property int barHeight: 36

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      screen: modelData
      visible: stack.toastCount > 0
      color: "transparent"
      exclusionMode: ExclusionMode.Ignore

      WlrLayershell.layer: WlrLayer.Overlay

      // Full-screen, fixed-size surface. Adding, removing, or expanding
      // toasts only moves items inside; the Wayland surface never resizes,
      // so the compositor cannot scale a stale buffer (Omarchy's overlay).
      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }

      mask: Region {
        item: stack
      }

      Item {
        id: stack
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: root.barHeight + 8
        anchors.rightMargin: 10

        readonly property int peek: 12
        readonly property int inset: 12
        readonly property int gap: 8
        readonly property int pileSize: 4
        readonly property int toastCount: repeater.count
        readonly property bool expanded: hover.hovered
        property real expandProgress: expanded ? 1 : 0

        readonly property real collapsedHeight: {
          if (toastCount === 0)
            return 0
          var newest = repeater.itemAt(toastCount - 1)
          var h = newest ? newest.height : 0
          return h + Math.min(pileSize - 1, toastCount - 1) * peek
        }

        implicitWidth: 480
        implicitHeight: collapsedHeight + (column.implicitHeight - collapsedHeight) * expandProgress
        clip: true

        Behavior on expandProgress {
          NumberAnimation {
            duration: 220
            easing.type: Easing.OutCubic
          }
        }

        HoverHandler {
          id: hover
        }

        // 1-column grid so the newest tracked item (last in the model) sits
        // at the top, matching the pile. Expanded y comes from the positioner.
        Grid {
          id: column
          columns: 1
          spacing: stack.gap
          width: parent.width

          Repeater {
            id: repeater
            model: NotificationService.tracked

            Item {
              id: slot

              required property var modelData
              required property int index

              readonly property int stackIndex: repeater.count - 1 - index
              readonly property real t: stack.expandProgress

              width: column.width
              height: toast.implicitHeight
              z: index

              Toast {
                id: toast
                notification: slot.modelData
                visible: slot.stackIndex < stack.pileSize || slot.t > 0
                width: slot.width - slot.stackIndex * stack.inset * 2 * (1 - slot.t)
                x: slot.stackIndex * stack.inset * (1 - slot.t)
                y: (slot.stackIndex * stack.peek - slot.y) * (1 - slot.t)
              }
            }
          }
        }
      }
    }
  }
}
