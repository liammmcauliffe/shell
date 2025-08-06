import QtQuick 2.15
import QtQuick.Controls 2.15
import qs.components
import qs.config
import qs.services

StyledRect {
    id: button

    signal clicked()

    property bool isToggled: false
    property bool isUpdating: false
    property string tooltipText: ""
    property color defaultColor: Colours.palette.m3surfaceContainerHigh
    property color toggledColor: Colours.palette.m3primary
    property string iconName: ""

    property real targetRadius: isToggled ? Appearance.rounding.small : height / 2
    radius: targetRadius

    Behavior on radius {
        NumberAnimation {
            duration: Appearance.anim.durations.expressiveFastSpatial
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
        }
    }

    width: 60
    height: 60

    color: isToggled ? toggledColor : defaultColor

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
            text: iconName

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

    StyledRect {
        anchors.fill: parent
        anchors.topMargin: 2
        anchors.leftMargin: 1
        radius: button.radius
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
            isToggled = !isToggled
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

    Timer {
        id: tooltipDelay
        interval: 500
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
        radius: button.radius

        Behavior on radius {
            NumberAnimation {
                duration: Appearance.anim.durations.expressiveFastSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
            }
        }
    }
}

