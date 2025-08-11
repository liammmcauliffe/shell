pragma ComponentBehavior: Bound

import qs.components
import qs.components.images
import qs.services
import qs.config
import qs.utils
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property var lock
    readonly property list<string> timeComponents: Time.format(Config.services.useTwelveHourClock ? "hh:mm:A" : "hh:mm").split(":")

    Layout.preferredWidth: Config.lock.sizes.centerWidth
    Layout.fillHeight: true

    spacing: Appearance.spacing.large * 2

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: Appearance.spacing.small

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            text: root.timeComponents[0]
            color: Colours.palette.m3secondary
            font.pointSize: Appearance.font.size.extraLarge * 3
            font.bold: true
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            text: ":"
            color: Colours.palette.m3primary
            font.pointSize: Appearance.font.size.extraLarge * 3
            font.bold: true
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            text: root.timeComponents[1]
            color: Colours.palette.m3secondary
            font.pointSize: Appearance.font.size.extraLarge * 3
            font.bold: true
        }

        Loader {
            Layout.leftMargin: Appearance.spacing.small
            Layout.alignment: Qt.AlignVCenter

            asynchronous: true
            active: Config.services.useTwelveHourClock
            visible: active

            sourceComponent: StyledText {
                text: root.timeComponents[2] ?? ""
                color: Colours.palette.m3primary
                font.pointSize: Appearance.font.size.extraLarge * 2
                font.bold: true
            }
        }
    }

    StyledText {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: -Appearance.padding.large * 2

        text: Time.format("dddd, d MMMM yyyy")
        color: Colours.palette.m3tertiary
        font.pointSize: Appearance.font.size.extraLarge
        font.family: Appearance.font.family.mono
        font.bold: true
    }

    StyledClippingRect {
        Layout.topMargin: Appearance.spacing.large * 2
        Layout.alignment: Qt.AlignHCenter

        implicitWidth: Config.lock.sizes.centerWidth / 2
        implicitHeight: Config.lock.sizes.centerWidth / 2

        color: Colours.tPalette.m3surfaceContainer
        radius: Appearance.rounding.full

        MaterialIcon {
            anchors.centerIn: parent

            text: "person"
            fill: 1
            grade: 200
            font.pointSize: Math.floor(Config.lock.sizes.centerWidth / 4)
        }

        CachingImage {
            id: pfp

            anchors.fill: parent
            path: `${Paths.stringify(Paths.home)}/.face`
        }
    }

    StyledRect {
        Layout.alignment: Qt.AlignHCenter

        implicitWidth: Config.lock.sizes.centerWidth * 0.8
        implicitHeight: input.implicitHeight + Appearance.padding.small * 2

        color: Colours.tPalette.m3surfaceContainer
        radius: Appearance.rounding.full

        focus: true
        onActiveFocusChanged: {
            if (!activeFocus)
                forceActiveFocus();
        }

        Keys.onPressed: event => {
            if (!root.lock.locked)
                return;

            if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                inputField.placeholder.animate = false;

            root.lock.pam.handleKey(event);
        }

        StateLayer {
            hoverEnabled: false
            cursorShape: Qt.IBeamCursor

            function onClicked(): void {
                parent.forceActiveFocus();
            }
        }

        RowLayout {
            id: input

            anchors.fill: parent
            anchors.margins: Appearance.padding.small
            spacing: Appearance.spacing.normal

            MaterialIcon {
                Layout.leftMargin: Appearance.padding.smaller
                text: "lock"
            }

            InputField {
                id: inputField

                pam: root.lock.pam
            }

            StyledRect {
                implicitWidth: implicitHeight
                implicitHeight: enterIcon.implicitHeight + Appearance.padding.small * 2

                color: root.lock.pam.buffer ? Colours.palette.m3primary : Colours.layer(Colours.palette.m3surfaceContainerHigh, 2)
                radius: Appearance.rounding.full

                StateLayer {
                    color: root.lock.pam.buffer ? Colours.palette.m3onPrimary : Colours.palette.m3onSurface

                    function onClicked(): void {
                        root.lock.pam.passwd.start();
                    }
                }

                MaterialIcon {
                    id: enterIcon

                    anchors.centerIn: parent
                    text: "arrow_forward"
                    color: root.lock.pam.buffer ? Colours.palette.m3onPrimary : Colours.palette.m3onSurface
                    font.weight: 500
                }
            }
        }
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.standard
    }
}
