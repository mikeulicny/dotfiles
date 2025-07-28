import QtQuick
import qs.Services

Rectangle {
  id: root
  height: 30
  width: 300

  Row {
    // Network/Wifi

    // Bluetooth
    Rectangle {
      //name: "bluetooth"
      width: 30
      height: 30
      color: "blue"
      anchors.verticalCenter: parent.verticalCenter
      visible: BluetoothService.available && BluetoothService.enabled
    }

    // Volume/Audio
    Rectangle {
      //width: audioIcon.implicitWidth + 4
      width: 100
      //height: audioIcon.implicitHeight + 4
      height: 30
      color: "black"
      anchors.verticalCenter: parent.verticalCenter

      Text {
        text: "󰓃"
        color: "white"
        font.pointSize: 22 
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
      }

      MouseArea {
        id: audioWheelArea

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton

        onWheel: function(wheelEvent) {
          let delta = wheelEvent.angleDelta.y;
          let currentVolume = (AudioService.sink && AudioService.sink.audio && AudioService.sink.audio.volume * 100) || 0;
          let newVolume
          if (delta > 0)
            newVolume = Math.min(100, currentVolume + 1);
          else
            newVolume = Math.max(0, currentVolume - 1);

          if (AudioService.sink && AudioService.sink.audio) {
            AudioService.sink.audio.muted = false;
            AudioService.sink.audio.volume = newVolume / 100;
          }
          wheelEvent.accepted = true;
        }
      }
    }

    // Battery
  }
}
