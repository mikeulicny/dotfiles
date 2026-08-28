import QtQuick
import qs

Rectangle {
  id: root

  property var bar: null
  property var popup: null
  property color background: Styles.transparent
  property bool active: false
  property bool checkable: popup !== null

  default property alias content: content.data

  signal pressed(int button)

  implicitHeight: bar.barHeight - 10
  implicitWidth: content.implicitWidth + 30
  radius: Styles.radius
  color: root.active || mouseArea.containsMouse ? Styles.fill : root.background

  function toggleActive() {
    if (root.popup && typeof root.popup.toggle === "function")
      root.popup.toggle()
    else if (root.checkable)
      root.active = !root.active
  }

  Connections {
    target: root.popup
    function onVisibleChanged() {
      root.active = !!root.popup.visible
    }
  }

  Row {
    id: content
    anchors.centerIn: parent
    spacing: 6

    onChildrenChanged: {
      for (var i = 0; i < children.length; i++) {
        children[i].anchors.verticalCenter = content.verticalCenter
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    hoverEnabled: true
    onClicked: function(mouse) {
      if (mouse.button === Qt.LeftButton && root.checkable)
        root.toggleActive()
      root.pressed(mouse.button)
    }
  }
}
