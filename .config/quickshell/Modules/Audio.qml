import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import qs
import qs.Ui

Item {
  id: root

  property var bar: null

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
  readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
  readonly property bool hasSink: sink && sink.audio
  readonly property var sinks: {
    var nodes = Pipewire.nodes.values
    var result = []
    for (var i = 0; i < nodes.length; i++) {
      var node = nodes[i]
      if (node && node.audio && node.isSink && !node.isStream)
        result.push(node)
    }
    return result
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  PwObjectTracker {
    objects: root.sinks
  }

  function nodeLabel(node) {
    if (!node)
      return "No device"
    return node.nickname || node.description || node.name || "Audio device"
  }

  function volumeIcon() {
    if (root.muted)
      return "volume-off.svg"
    if (root.volume > 0.5)
      return "volume-2.svg"
    if (root.volume > 0.25)
      return "volume-1.svg"
    if (root.volume > 0.01)
      return "volume.svg"
    return "volume-x.svg"
  }

  function toggleMute() {
    if (root.hasSink)
      root.sink.audio.muted = !root.sink.audio.muted
  }

  function setVolume(value) {
    if (!root.hasSink)
      return
    root.sink.audio.volume = value
    if (value > 0 && root.sink.audio.muted)
      root.sink.audio.muted = false
  }

  WidgetButton {
    id: button
    bar: root.bar
    popup: panel

    Icon {
      size: 16
      name: root.volumeIcon()
    }
  }

  WidgetPanel {
    id: panel
    bar: root.bar
    anchorItem: button

    ColumnLayout {

      RowLayout {
        id: volumeRow
        Layout.fillWidth: true
        spacing: 10

        PanelButton {
          enabled: root.hasSink
          onClicked: root.toggleMute()
          Icon { size: 16; name: root.volumeIcon() }
        }

        Slider {
          id: volumeSlider
          Layout.fillWidth: true
          Layout.alignment: Qt.AlignVCenter
          from: 0
          to: 1
          enabled: root.hasSink
          onMoved: root.setVolume(value)

          Binding on value {
            value: root.volume
            when: !volumeSlider.pressed
          }
        }

        Text {
          text: Math.round(root.volume * 100) + "%"
          color: Styles.secondary
          font.pointSize: Styles.font.sm
          Layout.preferredWidth: 36
          horizontalAlignment: Text.AlignRight
        }
      }

      Divider{}

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 6

        Text {
          visible: root.sinks.length === 0
          text: "No audio devices"
          color: Styles.muted
          font.pointSize: Styles.font.sm
        }

        Repeater {
          model: root.sinks

          PanelButton {
            required property var modelData

            Layout.fillWidth: true
            current: root.sink && (modelData === root.sink || modelData.id === root.sink.id)
            onClicked: Pipewire.preferredDefaultAudioSink = modelData

            Text {
              Layout.fillWidth: true
              text: root.nodeLabel(modelData)
              color: Styles.foreground
              font.pointSize: Styles.font.sm
              elide: Text.ElideRight
              verticalAlignment: Text.AlignVCenter
            }
          }
        }
      }
    }
  }
}
