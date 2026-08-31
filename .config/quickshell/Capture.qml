import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire
import qs.Ui

Item {
  id: root

  property bool v4lInUse: false

  readonly property var camera: {
    var nodes = Pipewire.nodes.values
    for (var i = 0; i < nodes.length; i++) {
      var node = nodes[i]
      if (!node || !node.properties)
        continue
      if (node.properties["media.class"] === "Video/Source")
        return node
    }
    return null
  }

  readonly property var source: Pipewire.defaultAudioSource
  readonly property bool pwCameraActive: cameraLinks.linkGroups.length > 0 || pwVideoStream
  readonly property bool pwVideoStream: {
    var nodes = Pipewire.nodes.values
    for (var i = 0; i < nodes.length; i++) {
      var node = nodes[i]
      if (!node || !node.properties)
        continue
      var mediaClass = node.properties["media.class"]
      if (mediaClass === "Stream/Input/Video")
        return true
    }
    return false
  }
  readonly property bool cameraActive: pwCameraActive || v4lInUse
  readonly property bool micActive: sourceLinks.linkGroups.length > 0
  readonly property bool cameraMuted: {
    if (root.v4lInUse || root.pwVideoStream)
      return false
    if (camera && camera.audio)
      return camera.audio.muted
    var groups = cameraLinks.linkGroups
    if (!groups || groups.length === 0)
      return false
    for (var i = 0; i < groups.length; i++) {
      if (groups[i].state === PwLinkState.Active)
        return false
    }
    return true
  }
  readonly property bool micMuted: source && source.audio ? source.audio.muted : false

  visible: cameraActive || micActive
  implicitWidth: icons.implicitWidth
  implicitHeight: icons.implicitHeight

  PwObjectTracker {
    objects: [root.camera, Pipewire.defaultAudioSource]
  }

  PwNodeLinkTracker {
    id: cameraLinks
    node: root.camera
  }

  PwNodeLinkTracker {
    id: sourceLinks
    node: Pipewire.defaultAudioSource
  }

  Process {
    id: cameraCheck
    running: true
    command: ["sh", "-c", "for d in /dev/video*; do [ -c \"$d\" ] || continue; fuser \"$d\" >/dev/null 2>&1 && exit 0; done; exit 1"]
    onExited: function(code) {
      root.v4lInUse = code === 0
      cameraPoll.restart()
    }
  }

  Timer {
    id: cameraPoll
    interval: 1000
    onTriggered: cameraCheck.running = true
  }

  Row {
    id: icons
    spacing: 6

    Icon {
      visible: root.cameraActive
      size: 16
      color: root.cameraMuted ? Styles.muted : Styles.urgent
      name: root.cameraMuted ? "video-off.svg" : "video.svg"
    }

    Icon {
      visible: root.micActive
      size: 16
      color: root.micMuted ? Styles.muted : Styles.urgent
      name: root.micMuted ? "mic-off.svg" : "mic.svg"
    }
  }
}
