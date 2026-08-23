import QtQuick

Rectangle {
  id: root

  property var bar: null
  property color background: "transparent"
  property bool active: false

  default property alias content: content.data

  signal pressed(int button)

  implicitHeight: bar.barHeight - 10
  implicitWidth: content.implicitWidth + 30
  radius: 6
  color: mouseArea.containsMouse ? "#20FFFFFF" : background

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
    onClicked: function(mouse) { root.pressed(mouse.button) }
  }
}
