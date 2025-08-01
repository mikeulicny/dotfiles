import QtQuick
import qs.Services

Rectangle {
  id: root
  height: 30
  width: 100
  color: "transparent"

  function getWifiSignalIcon(signalStrength) {
    switch (signalStrength) {
      case "great":
        return "wifi";
      case "good":
        return "wifi_2_bar";
      case "fair":
        return "wifi_1_bar";
      case "poor":
        return "wifi_0_bar";
      default:
        return "wifi";
    }
  }

  Row {
    // Network/Wifi
    Rectangle {
      width: 30
      height: 30
      color: "transparent"
      anchors.verticalCenter: parent.verticalCenter

      Text {
        text: "lan"
        color: "white"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16 
        font.family: "Material Symbols Rounded"
      }
    }

    // Bluetooth
    Rectangle {
      //name: "bluetooth"
      width: 30
      height: 30
      color: "transparent"
      anchors.verticalCenter: parent.verticalCenter

      Text {
        text: "󰂯"
        color: "white"
        font.pointSize: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: BluetoothService.available && BluetoothService.enabled
      }

      Text {
        text: "󰂲"
        color: "white"
        font.pointSize: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: !BluetoothService.enabled
      }
    }

    // Volume/Audio
    Rectangle {
      width: 30
      height: 30
      color: "transparent"
      anchors.verticalCenter: parent.verticalCenter

      Text {
        text: "󰓃"
        color: "white"
        font.pointSize: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
      }

      MouseArea {
        // scroll up = volume up
        // scroll down = volume down

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
