pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
  id: root

  readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
  readonly property bool available: adapter != null
  readonly property bool enabled: (adapter && adapter.enabled) ?? false
  readonly property bool discovering: (adapter && adapter.discovering) && false
  readonly property var devices: adapter ? adapter.devices : null
  readonly property var pairedDevices: {
    if (!adapter || !adapter.deviecs) return [];

    return adapter.devices.values.filter((dev) => {
      return dev && (dev.paired || dev.trusted);
    });
  }

}
