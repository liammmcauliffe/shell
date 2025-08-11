pragma ComponentBehavior: Bound

import ".."
import qs.components
import qs.components.controls
import qs.components.containers
import qs.services
import qs.config
import qs.modules.common.widgets
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: rootcl
    required property Session session
    readonly property bool smallSync: width <= 480

    spacing: Appearance.spacing.small

    RowLayout {
        spacing: Appearance.spacing.smaller

        StyledText {
            text: qsTr("Settings")
            font.pointSize: Appearance.font.size.extraLarge
            font.weight: 500
            color: Colours.palette.m3onSurface
        }

        Item {
            Layout.fillWidth: true
        }

        ToggleButton {
            toggled: Calendar.khalAvailable
            icon: "power"
            accent: "Tertiary"

            function onClicked(): void {
                // Toggle khal availability (this would need to be implemented in the service)
                console.log("Toggle khal availability")
            }
        }

        ToggleButton {
            toggled: !root.session.calendar.active
            icon: "settings"
            accent: "Primary"

            function onClicked(): void {
                if (root.session.calendar.active)
                    root.session.calendar.active = null;
                else {
                    root.session.calendar.active = calendarModel.values[0] ?? null;
                }
            }
        }
    }

    RowLayout {
        Layout.topMargin: Appearance.spacing.large
        Layout.fillWidth: true
        spacing: Appearance.spacing.normal

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Appearance.spacing.small

            StyledText {
                Layout.fillWidth: true
                text: qsTr("Calendar Sources (%1)").arg(calendarModel.values.length)
                font.pointSize: Appearance.font.size.extraLarge
                font.weight: 500
                color: Colours.palette.m3onSurface
            }

            StyledText {
                Layout.fillWidth: true
                text: qsTr("Available calendar sources")
                color: Colours.palette.m3outline
            }
        }

        StyledRect {
            implicitWidth: implicitHeight
            implicitHeight: syncIcon.implicitHeight + Appearance.padding.normal * 2

            radius: Calendar.khalAvailable ? Appearance.rounding.normal : implicitHeight / 2
            color: Calendar.khalAvailable ? Colours.palette.m3secondary : Colours.palette.m3secondaryContainer

            StateLayer {
                color: Calendar.khalAvailable ? Colours.palette.m3onSecondary : Colours.palette.m3onSecondaryContainer

                function onClicked(): void {
                    // Trigger vdirsyncer sync
                    Calendar.syncCalendars()
                }
            }

            StyledToolTip {
                text: qsTr("Sync all calendars with vdirsyncer")
                visible: parent.containsMouse
            }

            MaterialIcon {
                id: syncIcon

                anchors.centerIn: parent
                animate: true
                text: "sync"
                color: Calendar.khalAvailable ? Colours.palette.m3onSecondary : Colours.palette.m3onSecondaryContainer
                fill: Calendar.khalAvailable ? 1 : 0
            }

            Behavior on radius {
                Anim {}
            }
        }
    }

    StyledListView {
        model: ScriptModel {
            id: calendarModel
            values: Calendar.calendarSources
        }

        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: Appearance.spacing.small / 2

        ScrollBar.vertical: StyledScrollBar {}

        delegate: StyledRect {
            id: calendar

            required property var modelData
            readonly property bool active: root.session.calendar.active === modelData

            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: calendarInner.implicitHeight + Appearance.padding.normal * 2

            color: Qt.alpha(Colours.tPalette.m3surfaceContainer, calendar.active ? Colours.tPalette.m3surfaceContainer.a : 0)
            radius: Appearance.rounding.normal

            StateLayer {
                id: stateLayer

                function onClicked(): void {
                    root.session.calendar.active = calendar.modelData;
                }
            }

            RowLayout {
                id: calendarInner

                anchors.fill: parent
                anchors.margins: Appearance.padding.normal

                spacing: Appearance.spacing.normal

                StyledRect {
                    implicitWidth: implicitHeight
                    implicitHeight: icon.implicitHeight + Appearance.padding.normal * 2

                    radius: Appearance.rounding.normal
                    color: calendar.modelData.enabled ? Colours.palette.m3primaryContainer : Colours.tPalette.m3surfaceContainerHigh

                    StyledRect {
                        anchors.fill: parent
                        radius: parent.radius
                        color: Qt.alpha(calendar.modelData.enabled ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface, stateLayer.pressed ? 0.1 : stateLayer.containsMouse ? 0.08 : 0)
                    }

                    MaterialIcon {
                        id: icon

                        anchors.centerIn: parent
                        text: calendar.modelData.type === "google" ? "cloud" : "folder"
                        color: calendar.modelData.enabled ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                        font.pointSize: Appearance.font.size.large
                        fill: calendar.modelData.enabled ? 1 : 0

                        Behavior on fill {
                            Anim {}
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    spacing: 0

                    StyledText {
                        Layout.fillWidth: true
                        text: calendar.modelData.name
                        elide: Text.ElideRight
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: calendar.modelData.type === "google" ? calendar.modelData.url : calendar.modelData.path
                        color: Colours.palette.m3outline
                        font.pointSize: Appearance.font.size.small
                        elide: Text.ElideRight
                    }
                }

                StyledRect {
                    id: enableBtn

                    implicitWidth: implicitHeight
                    implicitHeight: enableIcon.implicitHeight + Appearance.padding.small * 2

                    radius: Appearance.rounding.full
                    color: Qt.alpha(Colours.palette.m3primaryContainer, calendar.modelData.enabled ? 1 : 0)

                    StateLayer {
                        color: calendar.modelData.enabled ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface

                        function onClicked(): void {
                            Calendar.updateCalendarSource(calendar.modelData.name, {
                                enabled: !calendar.modelData.enabled
                            })
                        }
                    }

                    StyledToolTip {
                        text: calendar.modelData.enabled ? qsTr("Disable calendar") : qsTr("Enable calendar")
                        visible: parent.containsMouse
                    }

                    MaterialIcon {
                        id: enableIcon

                        anchors.centerIn: parent
                        animate: true
                        text: calendar.modelData.enabled ? "check_circle" : "radio_button_unchecked"
                        color: calendar.modelData.enabled ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                    }
                }
            }
        }
    }

    component ToggleButton: StyledRect {
        id: toggleBtn

        required property bool toggled
        property string icon
        property string label
        property string accent: "Secondary"

        function onClicked(): void {
        }

        Layout.preferredWidth: implicitWidth + (toggleStateLayer.pressed ? Appearance.padding.normal * 2 : toggled ? Appearance.padding.small * 2 : 0)
        implicitWidth: toggleBtnInner.implicitWidth + Appearance.padding.large * 2
        implicitHeight: toggleBtnIcon.implicitHeight + Appearance.padding.normal * 2

        radius: toggled || toggleStateLayer.pressed ? Appearance.rounding.small : Math.min(width, height) / 2
        color: toggled ? Colours.palette[`m3${accent.toLowerCase()}`] : Colours.palette[`m3${accent.toLowerCase()}Container`]

        StateLayer {
            id: toggleStateLayer

            color: toggleBtn.toggled ? Colours.palette[`m3on${toggleBtn.accent}`] : Colours.palette[`m3on${toggleBtn.accent}Container`]

            function onClicked(): void {
                toggleBtn.onClicked();
            }
        }

        RowLayout {
            id: toggleBtnInner

            anchors.centerIn: parent
            spacing: Appearance.spacing.normal

            MaterialIcon {
                id: toggleBtnIcon

                visible: !!text
                fill: toggleBtn.toggled ? 1 : 0
                text: toggleBtn.icon
                color: toggleBtn.toggled ? Colours.palette[`m3on${toggleBtn.accent}`] : Colours.palette[`m3on${toggleBtn.accent}Container`]
                font.pointSize: Appearance.font.size.large

                Behavior on fill {
                    Anim {}
                }
            }

            Loader {
                asynchronous: true
                active: !!toggleBtn.label
                visible: active

                sourceComponent: StyledText {
                    text: toggleBtn.label
                    color: toggleBtn.toggled ? Colours.palette[`m3on${toggleBtn.accent}`] : Colours.palette[`m3on${toggleBtn.accent}Container`]
                }
            }
        }

        Behavior on radius {
            Anim {
                duration: Appearance.anim.durations.expressiveFastSpatial
                easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
            }
        }

        Behavior on Layout.preferredWidth {
            Anim {
                duration: Appearance.anim.durations.expressiveFastSpatial
                easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
            }
        }
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.standard
    }
}
