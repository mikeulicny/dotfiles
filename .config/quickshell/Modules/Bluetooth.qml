import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs
import qs.Services
import qs.Ui

Item {
  id: root

  property var bar: null

  readonly property bool deviceConnected: {
    var devices = Bluetooth.devices.values
    for (var i = 0; i < devices.length; i++) {
      if (devices[i].connected)
        return true
    }
    return false
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    bar: root.bar
    popup: panel

    Icon {
      size: 16
      name: root.deviceConnected ? "bluetooth-connected.svg" : "bluetooth.svg"
    }
  }

  WidgetPanel {
    id: panel
    bar: root.bar
    anchorItem: button

    onVisibleChanged: {
      if (visible)
        BluetoothService.refresh()
      else
        BluetoothService.setDiscovering(false)
    }

    ColumnLayout {
      spacing: 10

      RowLayout {
        Layout.fillWidth: true
        spacing: 8

        Text {
          text: "Bluetooth"
          color: Styles.foreground
          font.pointSize: Styles.font.md
          Layout.fillWidth: true
        }

        AbstractButton {
          enabled: BluetoothService.enabled
          hoverEnabled: true
          padding: 4
          implicitWidth: 28
          implicitHeight: 28
          onClicked: BluetoothService.refresh()

          background: Rectangle {
            radius: Styles.radius
            color: parent.hovered && parent.enabled ? Styles.fill : Styles.transparent
          }

          contentItem: Icon {
            size: 16
            name: "rotate-cw.svg"
          }
        }
      }

      Divider {}

      Text {
        visible: !BluetoothService.available
        text: "No Bluetooth adapter"
        color: Styles.muted
        font.pointSize: Styles.font.sm
      }

      Text {
        visible: BluetoothService.available && !BluetoothService.enabled
        text: "Bluetooth is off"
        color: Styles.muted
        font.pointSize: Styles.font.sm
      }


      ColumnLayout {
        visible: BluetoothService.enabled
        Layout.fillWidth: true
        spacing: 4

        Text {
          text: "Known devices"
          color: Styles.secondary
          font.pointSize: Styles.font.sm
        }

        Text {
          visible: !rememberedRepeater.hasVisible
          text: "No known devices"
          color: Styles.muted
          font.pointSize: Styles.font.sm
        }


        Repeater {
          id: rememberedRepeater
          model: Bluetooth.devices

          readonly property bool hasVisible: {
            var devices = Bluetooth.devices.values
            for (var i = 0; i < devices.length; i++) {
              if (BluetoothService.isRemembered(devices[i]))
                return true
            }
            return false
          }

          PanelButton {
            required property var modelData

            visible: BluetoothService.isRemembered(modelData)
            Layout.fillWidth: true
            current: modelData && modelData.connected
            onClicked: BluetoothService.activateDevice(modelData)

            Text {
              Layout.fillWidth: true
              text: {
                if (modelData)
                  void (modelData.deviceName + modelData.name + modelData.address)
                return BluetoothService.deviceLabel(modelData)
              }
              color: Styles.foreground
              font.pointSize: Styles.font.sm
              verticalAlignment: Text.AlignVCenter
            }

            Text {
              text: {
                if (!modelData)
                  return ""
                if (modelData.pairing)
                  return "Pairing…"
                if (modelData.state === BluetoothDeviceState.Connecting)
                  return "Connecting…"
                if (modelData.state === BluetoothDeviceState.Disconnecting)
                  return "Disconnecting…"
                if (modelData.connected)
                  return "Connected"
                return "Remembered"
              }
              color: modelData.connected ? Styles.success : Styles.secondary
              font.pointSize: Styles.font.sm
            }
          }
        }

        Divider {}

        Text {
          text: "Available"
          color: Styles.secondary
          font.pointSize: Styles.font.sm
          Layout.topMargin: 4
        }

        Text {
          visible: !availableRepeater.hasVisible
          text: BluetoothService.discovering ? "Scanning…" : "No devices found"
          color: Styles.muted
          font.pointSize: Styles.font.sm
        }

        Repeater {
          id: availableRepeater
          model: Bluetooth.devices

          readonly property bool hasVisible: {
            var devices = Bluetooth.devices.values
            for (var i = 0; i < devices.length; i++) {
              if (!BluetoothService.isRemembered(devices[i]))
                return true
            }
            return false
          }

          PanelButton {
            required property var modelData

            visible: modelData && !BluetoothService.isRemembered(modelData)
            Layout.fillWidth: true
            onClicked: BluetoothService.activateDevice(modelData)

            Text {
              Layout.fillWidth: true
              text: {
                if (modelData)
                  void (modelData.deviceName + modelData.name + modelData.address)
                return BluetoothService.deviceLabel(modelData)
              }
              color: Styles.foreground
              font.pointSize: Styles.font.sm
              verticalAlignment: Text.AlignVCenter
            }

            Text {
              visible: text !== ""
              text: {
                if (modelData && (modelData.pairing || modelData.state === BluetoothDeviceState.Connecting))
                  return "Pairing…"
                return ""
              }
              color: Styles.secondary
              font.pointSize: Styles.font.sm
            }
          }
        }
      }
    }
  }
}
