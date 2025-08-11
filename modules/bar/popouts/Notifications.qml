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
    implicitWidth: width
    Layout.preferredWidth: width
    Layout.minimumWidth: width
    Layout.maximumWidth: width

    readonly property int maxListHeight: Math.min(480, (QsWindow.window?.screen?.height ?? 800) * 0.6)

    readonly property int notifCount: {
        return (Notifs.list && Notifs.list.length !== undefined)
        ? Notifs.list.length
        : ((Notifs.list && Notifs.list.count !== undefined) ? Notifs.list.count : 0)
    }
    function notifAt(i) {
        if (!Notifs.list) return undefined
        if (typeof Notifs.list.get === 'function') return Notifs.list.get(i)
        return Notifs.list[i]
    }

    function scrollToTop(): void {
        if (notifScroll && notifScroll.contentItem && notifScroll.contentItem.contentY !== undefined) {
            notifScroll.contentItem.contentY = 0;
        }
    }

    RowLayout {
        Layout.topMargin: Appearance.padding.large
        Layout.leftMargin: Appearance.padding.normal
        Layout.rightMargin: Appearance.padding.normal
        Layout.bottomMargin: Appearance.padding.small
        Layout.fillWidth: true
        spacing: Appearance.spacing.normal

        StyledText {
            Layout.fillWidth: true
            text: qsTr("Notifications %1").arg(Notifs.dnd ? qsTr("silenced") : qsTr("enabled"))
            font.weight: 500
        }

        StyledRect {
            radius: Appearance.rounding.full
            implicitHeight: Appearance.font.size.normal * 1.6
            implicitWidth: Math.max(implicitHeight, badgeText.implicitWidth + Appearance.padding.small * 2)
            color: Colours.palette.m3primaryContainer

            StyledText {
                id: badgeText
                anchors.centerIn: parent
                text: notifCount
                color: Colours.palette.m3onPrimaryContainer
            }
        }
    }

    // Top toggle removed; moved to bottom as a button

    Item {
        visible: notifCount === 0
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
                font.pixelSize: 120
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
        Layout.fillWidth: true
        visible: notifCount > 0
        Layout.leftMargin: Appearance.padding.normal
        Layout.rightMargin: Appearance.padding.normal
        Layout.maximumHeight: maxListHeight
        Layout.preferredHeight: Math.min(maxListHeight, (notifList?.implicitHeight ?? 0) + Appearance.padding.normal * 2)
        Layout.minimumHeight: Math.min(260, maxListHeight)

        ScrollView {
            id: notifScroll
            anchors.fill: parent
            anchors.margins: Appearance.padding.normal
            clip: true

            ListView {
                id: notifList
                width: parent.width
                spacing: Appearance.spacing.normal
                interactive: true

                model: ScriptModel {
                    values: [...Notifs.list].reverse()
                }

                delegate: Item {
                    id: wrapper
                    required property int index
                    required property var modelData
                    readonly property alias nonAnimHeight: notif.nonAnimHeight

                    width: notifList.width
                    height: notif.implicitHeight

                    NotificationComponents.Notification {
                        id: notif
                        width: parent.width
                        modelData: wrapper.modelData
                        color: Colours.palette.m3surfaceContainerHigh
                        opacity: 0.6
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

                remove: null // No fade-out animation

                displaced: Transition {
                    NumberAnimation {
                        property: "y"
                        duration: Appearance.anim.durations.normal
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }

    // Bottom action buttons: Silence notifications (toggle) and Clear all
    RowLayout {
        Layout.topMargin: Appearance.spacing.normal
        Layout.leftMargin: Appearance.padding.normal
        Layout.rightMargin: Appearance.padding.normal
        Layout.bottomMargin: Appearance.padding.normal
        Layout.fillWidth: true
        spacing: Appearance.spacing.small

        // Silence notifications toggleable button
        StyledRect {
            Layout.fillWidth: true
            implicitHeight: silenceBtn.implicitHeight + Appearance.padding.normal * 2
            radius: Appearance.rounding.large
            color: Notifs.dnd ? Colours.palette.m3primaryContainer : Qt.darker(Colours.palette.m3surfaceContainer, 1.2)

            StateLayer {
                color: Notifs.dnd ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                function onClicked(): void {
                    Notifs.toggleDnd()
                }
            }

            RowLayout {
                id: silenceBtn
                anchors.centerIn: parent
                spacing: Appearance.spacing.small

                MaterialIcon {
                    text: Notifs.dnd ? "notifications_off" : "notifications"
                    color: Notifs.dnd ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                }

                StyledText {
                    text: qsTr("Silence notifications")
                    color: Notifs.dnd ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                }
            }
        }

        // Clear all button
        StyledRect {
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
                        const n = root.notifAt(i)
                        if (n && n.notification && typeof n.notification.dismiss === 'function') {
                            n.notification.dismiss()
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
}


