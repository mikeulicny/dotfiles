pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property PwNode source: Pipewire.defaultAudioSource
  readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
  readonly property real volume: sink && sink.audio ? sink.audio.volume : 0


  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
  }

  Connections {
    target: root.sink?.audio

    function onVolumeChanged() {
      root.volumeChanged()
    }

    function onMutedChanged() {
      root.volumeChanged()
    }
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

  function setVolume(percent) {
    if (root.sink && root.sink.audio) {
      const clampedVolume = Math.max(0, Math.min(100, percent));
      root.sink.audio.volume  = clampedVolume / 100;
      return "Volume set to " + clampedVolume + "%";
    }
    return "No audio sink available";
  }
}
