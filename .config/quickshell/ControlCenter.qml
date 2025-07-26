import QtQuick
import qs.Services

Rectangle {
  id: root
  height: 30
  width: 100

  Row {
    // Network/Wifi
    // Bluetooth

    // Volume/Audio
    Rectangle {
      //width: audioIcon.implicitWidth + 4
      width: 30
      //height: audioIcon.implicitHeight + 4
      height: 30
      color: "white"
      anchors.verticalCenter: parent.verticalCenter

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
            newVolume = Math.min(100, currentVolume + 2);
          else
            newVolume = Math.max(0, currentVolume - 2);

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
