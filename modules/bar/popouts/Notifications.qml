pragma ComponentBehavior: Bound

import qs.components
import qs.components.controls
import qs.components.widgets
import qs.services
import qs.config
import qs.utils
import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../notifications" as NotificationComponents

ColumnLayout {
    id: root

    required property Item wrapper

    spacing: Appearance.spacing.normal
    width: 420

    readonly property int maxListHeight: Math.min(480, (QsWindow.window?.screen?.height ?? 800) * 0.6)

    readonly property int notifCount: {
        return (Notifs.list && Notifs.list.length !== undefined) ? Notifs.list.length : ((Notifs.list && Notifs.list.count !== undefined) ? Notifs.list.count : 0);
    }
    
    readonly property int pendingCount: DoNotDisturb.pending.length
    
    function notifAt(i) {
        if (!Notifs.list)
            return undefined;
        if (typeof Notifs.list.get === 'function')
            return Notifs.list.get(i);
        return Notifs.list[i];
    }

    function scrollToTop(): void {
        if (notifScroll && notifScroll.contentItem && notifScroll.contentItem.contentY !== undefined) {
            notifScroll.contentItem.contentY = 0;
        }
    }

    RowLayout {
        Layout.margins: Appearance.padding.normal
        Layout.topMargin: Appearance.padding.large
        Layout.bottomMargin: Appearance.padding.small
        Layout.fillWidth: true
        spacing: Appearance.spacing.normal

        MaterialIcon {
            text: {
                if (DoNotDisturb.enabled)
                    return "notifications_off";
                if (notifCount > 0)
                    return "notifications";
                return "notifications_none";
            }
            color: DoNotDisturb.enabled ? Colours.palette.m3error : Colours.palette.m3primary
        }

        StyledText {
            Layout.fillWidth: true
            text: qsTr("Notifications")
            font.weight: 600
        }

        StyledRect {
            radius: Appearance.rounding.full
            implicitHeight: Appearance.font.size.normal * 1.6
            implicitWidth: Math.max(implicitHeight, badgeText.implicitWidth + Appearance.padding.small * 2)
            color: DoNotDisturb.enabled ? Colours.palette.m3errorContainer : Colours.palette.m3primaryContainer

            StyledText {
                id: badgeText
                anchors.centerIn: parent
                text: DoNotDisturb.enabled ? pendingCount : notifCount
                color: DoNotDisturb.enabled ? Colours.palette.m3onErrorContainer : Colours.palette.m3onPrimaryContainer
            }
        }
    }

    Toggle {
        Layout.leftMargin: Appearance.padding.normal
        Layout.rightMargin: Appearance.padding.normal
        Layout.bottomMargin: Appearance.padding.small
        label: qsTr("Do Not Disturb")
        checked: DoNotDisturb.enabled
        toggle.onToggled: DoNotDisturb.toggle()
    }

    Item {
        visible: notifCount === 0 && !DoNotDisturb.enabled
        Layout.fillWidth: true
        Layout.leftMargin: Appearance.padding.normal
        Layout.rightMargin: Appearance.padding.normal
        Layout.maximumHeight: maxListHeight
        Layout.preferredHeight: Math.min(maxListHeight, 260 + Appearance.padding.normal * 2)
        Layout.minimumHeight: Math.min(260, maxListHeight)

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Appearance.spacing.large

            MaterialIcon {
                Layout.alignment: Qt.AlignHCenter
                text: "notifications_none"
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: 120
                opacity: 0.6
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("No notifications")
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.large
                font.weight: 400
                opacity: 0.8
            }
        }
    }

    Item {
        visible: DoNotDisturb.enabled && pendingCount > 0
        Layout.fillWidth: true
        Layout.leftMargin: Appearance.padding.normal
        Layout.rightMargin: Appearance.padding.normal
        Layout.maximumHeight: maxListHeight
        Layout.preferredHeight: Math.min(maxListHeight, 260 + Appearance.padding.normal * 2)
        Layout.minimumHeight: Math.min(260, maxListHeight)

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Appearance.spacing.large

            MaterialIcon {
                Layout.alignment: Qt.AlignHCenter
                text: "notifications_off"
                color: Colours.palette.m3error
                font.pointSize: 120
                opacity: 0.6
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Do Not Disturb is on")
                color: Colours.palette.m3error
                font.pointSize: Appearance.font.size.large
                font.weight: 600
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("%1 notifications pending").arg(pendingCount)
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.normal
                opacity: 0.8
            }
        }
    }

    Item {
        Layout.fillWidth: true
        visible: notifCount > 0 && !DoNotDisturb.enabled
        Layout.leftMargin: Appearance.padding.normal
        Layout.rightMargin: Appearance.padding.normal
        Layout.maximumHeight: maxListHeight
        Layout.preferredHeight: Math.min(maxListHeight, (notifList?.implicitHeight ?? 0) + Appearance.padding.normal * 2)
        Layout.minimumHeight: Math.min(260, maxListHeight)

        ListView {
            id: notifScroll
            anchors.fill: parent
            anchors.margins: Appearance.padding.normal
            spacing: Appearance.spacing.normal
            clip: true

            model: ScriptModel {
                values: [...Notifs.list].reverse()
            }

            delegate: Item {
                id: wrapper
                required property int index
                required property var modelData
                readonly property alias nonAnimHeight: notif.nonAnimHeight

                width: ListView.view ? ListView.view.width : 0
                height: notif.implicitHeight

                NotificationComponents.Notification {
                    id: notif
                    width: parent.width
                    modelData: wrapper.modelData
                    color: Colours.palette.m3surfaceContainerHigh
                    opacity: 0.8
                }
            }

            add: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: Appearance.anim.durations.normal
                    easing.type: Easing.OutCubic
                }
            }

            remove: null

            displaced: Transition {
                NumberAnimation {
                    property: "y"
                    duration: Appearance.anim.durations.normal
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    component Toggle: RowLayout {
        required property string label
        property alias checked: toggle.checked
        property alias toggle: toggle

        Layout.fillWidth: true
        Layout.rightMargin: Appearance.padding.small
        spacing: Appearance.spacing.normal

        StyledText {
            Layout.fillWidth: true
            text: parent.label
        }

        StyledSwitch {
            id: toggle
        }
    }

    StyledRect {
        Layout.margins: Appearance.spacing.normal
        Layout.fillWidth: true
        implicitHeight: clearBtn.implicitHeight + Appearance.padding.normal * 2

        radius: Appearance.rounding.large
        color: notifCount === 0 ? Qt.darker(Colours.palette.m3surfaceContainer, 1.2) : Colours.palette.m3primaryContainer

        StateLayer {
            color: notifCount === 0 ? Colours.palette.m3onSurface : Colours.palette.m3onPrimaryContainer
            disabled: notifCount === 0
            opacity: notifCount === 0 ? 0.4 : 1.0

            function onClicked(): void {
                for (let i = root.notifCount - 1; i >= 0; i--) {
                    const n = root.notifAt(i);
                    if (n && n.notification && typeof n.notification.dismiss === 'function') {
                        n.notification.dismiss();
                    }
                }
            }
        }

        RowLayout {
            id: clearBtn

            anchors.centerIn: parent
            spacing: Appearance.spacing.small
            opacity: notifCount === 0 ? 0.4 : 1.0

            MaterialIcon {
                id: clearIcon
                text: "clear_all"
                color: notifCount === 0 ? Colours.palette.m3onSurface : Colours.palette.m3onPrimaryContainer
            }

            StyledText {
                text: notifCount === 0 ? qsTr("Nothing to clear") : qsTr("Clear all")
                color: notifCount === 0 ? Colours.palette.m3onSurface : Colours.palette.m3onPrimaryContainer
            }
        }
    }
}
