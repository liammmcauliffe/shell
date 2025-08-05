import QtQuick 2.15
import QtQuick.Controls 2.15
import qs.components
import qs.config
import qs.services

Item {
    id: root

    anchors.left: parent.left
    anchors.right: parent.right
    implicitHeight: childrenRect.height
    height: 250

    // Removed the import for KeyboardService and the property
    // property var keyboardService: KeyboardService

    // Individual toggle states for reactivity
    property bool cloudflareToggled: false
    property bool backlightToggled: false // Reverted to a simple boolean, not linked to KeyboardService
    property bool keepAwakeToggled: false
    property bool gameModeToggled: false
    property bool gammaStepToggled: false
    property bool silenceNotificationsToggled: false

    // Removed the Connections block to KeyboardService
    // Connections {
    //     target: keyboardService
    //     function onBacklightEnabledChanged() {
    //         backlightToggled = keyboardService.backlightEnabled
    //     }
    // }

    StyledRect {
        anchors.fill: parent
        color: "transparent"

        Grid {
            id: buttonGrid
            anchors.centerIn: parent
            anchors.margins: Appearance.padding.normal
            rows: 2
            columns: 3
            spacing: Appearance.spacing.normal

            property real buttonSize: Math.max(60, Math.min(
                (parent.width - anchors.margins * 2 - spacing * (columns - 1)) / columns,
                (parent.height - anchors.margins * 2 - spacing * (rows - 1)) / rows
            ))

            Repeater {
                model: [
                    { id: "cloudflare", icon: "dns", label: "Cloudflare DNS", color: Colours.palette.m3primary },
                    { id: "backlight", icon: "brightness_6", label: "Backlight", color: Colours.palette.m3secondary },
                    { id: "keepAwake", icon: "bedtime_off", label: "Keep Awake", color: Colours.palette.m3tertiary },
                    { id: "gameMode", icon: "sports_esports", label: "Game Mode", color: Colours.palette.m3error },
                    { id: "gammaStep", icon: "visibility", label: "Gamma Step", color: Colours.palette.m3primary },
                    { id: "silenceNotifications", icon: "notifications_off", label: "Silence Notifications", color: Colours.palette.m3secondary }
                ]

                StyledRect {
                    id: button

                    property bool isToggled: root[modelData.id + "Toggled"]
                    property string tooltipText: modelData.label

                    // M3 Expressive: Round when not toggled, square when toggled
                    property real targetRadius: isToggled ? Appearance.rounding.small : height / 2
                    radius: targetRadius

                    // M3 Expressive: Shape morphing animation
                    Behavior on radius {
                        NumberAnimation {
                            duration: Appearance.anim.durations.expressiveFastSpatial
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
                        }
                    }

                    width: buttonGrid.buttonSize
                    height: buttonGrid.buttonSize

                    // M3 Expressive: Tonal when not toggled, Filled when toggled
                    color: isToggled ? modelData.color : Colours.palette.m3surfaceContainerHigh

                    Behavior on color {
                        ColorAnimation {
                            duration: Appearance.anim.durations.expressiveFastSpatial
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
                        }
                    }

                    Item {
                        id: iconContainer
                        anchors.centerIn: parent
                        width: button.width * 0.8
                        height: button.height * 0.8

                        MaterialIcon {
                            id: icon
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height

                            animate: true
                            text: modelData.icon

                            color: button.isToggled ? Colours.palette.m3onPrimary : Colours.palette.m3onSurfaceVariant

                            font.pixelSize: Math.max(16, Math.min(parent.height * 1.2, 45))

                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter

                            fill: button.isToggled ? 1 : 0
                            grade: button.isToggled ? 200 : 0

                            Behavior on color {
                                ColorAnimation {
                                    duration: Appearance.anim.durations.expressiveFastSpatial
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
                                }
                            }

                            Behavior on fill {
                                NumberAnimation {
                                    duration: Appearance.anim.durations.expressiveFastSpatial
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
                                }
                            }
                        }
                    }

                    // Elevation shadow for toggled state
                    StyledRect {
                        anchors.fill: parent
                        anchors.topMargin: 2
                        anchors.leftMargin: 1
                        radius: button.radius // Match parent button shape
                        color: "black"
                        opacity: button.isToggled ? 0.15 : 0.05
                        z: -1

                        Behavior on opacity {
                            NumberAnimation {
                                duration: Appearance.anim.durations.expressiveFastSpatial
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
                            }
                        }

                        Behavior on radius {
                            NumberAnimation {
                                duration: Appearance.anim.durations.expressiveFastSpatial
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
                            }
                        }
                    }

                    MouseArea {
                        id: buttonMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        z: 1

                        onClicked: {
                            // Now all toggles are handled uniformly, including backlight
                            root[modelData.id + "Toggled"] = !root[modelData.id + "Toggled"];
                            console.log("Quick action toggled:", modelData.label, "->", root[modelData.id + "Toggled"])
                        }

                        onPressed: stateLayer.pressed = true
                        onReleased: stateLayer.pressed = false
                        onCanceled: stateLayer.pressed = false
                        onEntered: tooltipDelay.start()
                        onExited: {
                            tooltipDelay.stop()
                            tooltip.visible = false
                        }
                    }

                    // Tooltip implementation
                    Timer {
                        id: tooltipDelay
                        interval: 500 // Show tooltip after 500ms hover
                        onTriggered: tooltip.visible = true
                    }

                    Rectangle {
                        id: tooltip
                        visible: false
                        width: tooltipText.implicitWidth + 20
                        height: tooltipText.implicitHeight + 12
                        color: Colours.palette.m3inverseOnSurface
                        radius: Appearance.rounding.small
                        anchors {
                            bottom: parent.top
                            bottomMargin: 10
                            horizontalCenter: parent.horizontalCenter
                        }
                        z: 100

                        StyledText {
                            id: tooltipText
                            anchors.centerIn: parent
                            text: button.tooltipText
                            color: Colours.palette.m3inverseSurface
                            font.pointSize: 10
                        }

                        // Tooltip pointer
                        Canvas {
                            anchors {
                                top: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }
                            width: 12
                            height: 8
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.reset()
                                ctx.beginPath()
                                ctx.moveTo(width/2, 0)
                                ctx.lineTo(0, height)
                                ctx.lineTo(width, height)
                                ctx.closePath()
                                ctx.fillStyle = Colours.palette.m3inverseOnSurface
                                ctx.fill()
                            }
                        }

                        Behavior on opacity {
                            NumberAnimation { duration: 150 }
                        }
                    }

                    // Scale animation on press (subtle press effect only)
                    scale: stateLayer.pressed ? 0.95 : 1.0

                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                    }

                    StateLayer {
                        id: stateLayer
                        property bool pressed: false

                        anchors.fill: parent
                        radius: button.radius // Match parent button shape

                        Behavior on radius {
                            NumberAnimation {
                                duration: Appearance.anim.durations.expressiveFastSpatial
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
                            }
                        }
                    }
                }
            }
        }
    }
}
