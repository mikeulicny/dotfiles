pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property PwNode source: Pipewire.defaultAudioSource

  signal volumeChanged()

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
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
