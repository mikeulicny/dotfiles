import QtQuick

// Base item every bar widget extends. Codifies the three properties the
// bar host injects into each widget slot
Item {
  id: root

  property QtObject bar: null
  property string moduleName: ""

  implicitHeight: bar.barHeight
  anchors.verticalCenter: parent.verticalCenter

  // Run `method` on every live instance of this widget. An IPC target only
  // ever routes to one handler, but a bar surface exists per monitor, so the
  // instance that owns the target relays the call to its peers - otherwise a
  // refresh would land on a single screen and leave the others stale.
  function broadcast(method) {
    var items = bar && typeof bar.moduleWidgets === "function"
      ? bar.moduleWidgets(moduleName) : [root]
    for (var i = 0; i < items.length; i++) {
      if (items[i] && typeof items[i][method] === "function") items[i][method]()
    }
  }
}
