import QtQuick
import QtQuick.Layouts
import "Ui"

BarWidget {
  id: root
  moduleName: "controls"

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  RowLayout {
    id: row
    spacing: -5

    Computer {
      bar: root.bar
    }

    Capture {
      bar: root.bar
    }

    Audio {
      bar: root.bar
    }

    Bluetooth {
      bar: root.bar
    }

    Network {
      bar: root.bar
    }

    Battery {
      bar: root.bar
    }
  }
}
