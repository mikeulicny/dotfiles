pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs

WrapperRectangle {
  id: root

  required property Notification notification
  property real enterProgress: 0

  readonly property string imageSource: {
    if (!notification)
      return ""
    if (notification.image)
      return notification.image
    return notification.appIcon ? Quickshell.iconPath(notification.appIcon, true) : ""
  }

  margin: Styles.panelPadding
  contentInsideBorder: false
  radius: Styles.radiusPanel
  color: Styles.background
  border.width: 1
  border.color: Styles.border
  opacity: enterProgress
  transform: Translate {
    y: (1 - root.enterProgress) * -20
  }

  Behavior on enterProgress {
    NumberAnimation {
      duration: 220
      easing.type: Easing.OutCubic
    }
  }

  Component.onCompleted: enterProgress = 1

  RowLayout {
    spacing: Styles.panelPadding

    IconImage {
      visible: root.imageSource !== ""
      source: root.imageSource
      implicitSize: 56
      Layout.alignment: Qt.AlignVCenter
    }

    ColumnLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignVCenter
      spacing: Styles.panelPadding / 2

      Text {
        Layout.fillWidth: true
        text: root.notification?.summary ?? ""
        color: Styles.foreground
        font.pointSize: Styles.font.lg
        elide: Text.ElideRight
        textFormat: Text.PlainText
      }

      Text {
        Layout.fillWidth: true
        visible: text !== ""
        text: root.notification?.body ?? ""
        color: Styles.secondary
        font.pointSize: Styles.font.sm
        wrapMode: Text.Wrap
        maximumLineCount: 2
        elide: Text.ElideRight
        textFormat: Text.PlainText
      }
    }

    PanelButton {
      Layout.alignment: Qt.AlignTop
      onClicked: root.notification?.dismiss()
      Icon {
        size: 16
        name: "x.svg"
      }
    }
  }
}
