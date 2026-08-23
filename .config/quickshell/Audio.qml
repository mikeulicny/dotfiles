import QtQuick
import Quickshell.Services.Pipewire
import "Ui"

WidgetButton {
  id: root

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
  readonly property real volume: sink && sink.audio ? sink.audio.volume : 0

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  function volumeIcon() {
    if (root.muted)
      return "volume-x.svg"
    if (root.volume < 0.25)
      return "volume.svg"
    if (root.volume < 0.5)
      return "volume-1.svg"
    return "volume-2.svg"
  }

  Icon {
    size: 20
    name: root.volumeIcon()
  }
}
