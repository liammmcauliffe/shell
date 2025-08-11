pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

WlSessionLockSurface {
    id: root

    required property WlSessionLock lock
    required property Pam pam

    readonly property bool animating: initAnim.running || unlockAnim.running
    property bool locked

    Component.onCompleted: locked = true

    color: "transparent"

    Connections {
        target: root.lock

        function onUnlock(): void {
            root.locked = false;
            unlockAnim.start();
        }
    }

    SequentialAnimation {
        id: unlockAnim

        ParallelAnimation {
            Anim {
                target: lockContent
                properties: "implicitWidth,implicitHeight"
                to: lockContent.size
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
            }
            Anim {
                target: lockBg
                property: "radius"
                to: lockContent.size / 4
            }
            Anim {
                target: content
                property: "centerScale"
                to: 0
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
            }
            Anim {
                target: content
                property: "opacity"
                to: 0
                duration: Appearance.anim.durations.small
            }
            Anim {
                target: lockIcon
                property: "opacity"
                to: 1
                duration: Appearance.anim.durations.large
            }
            Anim {
                target: background
                property: "opacity"
                to: 0
                duration: Appearance.anim.durations.large
            }
            SequentialAnimation {
                PauseAnimation {
                    duration: Appearance.anim.durations.small
                }
                Anim {
                    target: lockContent
                    property: "opacity"
                    to: 0
                }
            }
        }
        PropertyAction {
            target: root.lock
            property: "locked"
            value: false
        }
    }

    ParallelAnimation {
        id: initAnim

        running: true

        Anim {
            target: background
            property: "opacity"
            to: 1
            duration: Appearance.anim.durations.large
        }
        SequentialAnimation {
            ParallelAnimation {
                Anim {
                    target: lockContent
                    property: "scale"
                    to: 1
                    duration: Appearance.anim.durations.expressiveFastSpatial
                    easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
                }
                Anim {
                    target: lockContent
                    property: "rotation"
                    to: 360
                    duration: Appearance.anim.durations.expressiveFastSpatial
                    easing.bezierCurve: Appearance.anim.curves.standardAccel
                }
            }
            ParallelAnimation {
                Anim {
                    target: lockIcon
                    property: "rotation"
                    to: 360
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                }
                Anim {
                    target: lockIcon
                    property: "opacity"
                    to: 0
                }
                Anim {
                    target: content
                    property: "opacity"
                    to: 1
                }
                Anim {
                    target: content
                    property: "centerScale"
                    to: 1
                    duration: Appearance.anim.durations.expressiveDefaultSpatial
                    easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
                }
                Anim {
                    target: lockBg
                    property: "radius"
                    to: Appearance.rounding.large * 1.5
                }
                Anim {
                    target: lockContent
                    property: "implicitWidth"
                    to: root.screen.height * Config.lock.sizes.heightMult * Config.lock.sizes.ratio
                    duration: Appearance.anim.durations.expressiveDefaultSpatial
                    easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
                }
                Anim {
                    target: lockContent
                    property: "implicitHeight"
                    to: root.screen.height * Config.lock.sizes.heightMult
                    duration: Appearance.anim.durations.expressiveDefaultSpatial
                    easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
                }
            }
        }
    }

    ScreencopyView {
        id: background

        anchors.fill: parent
        captureSource: root.screen
        opacity: 0

        layer.enabled: true
        layer.effect: MultiEffect {
            id: backgroundBlur

            autoPaddingEnabled: false
            blurEnabled: true
            blur: 1
            blurMax: 64
            blurMultiplier: 1
        }
    }

    Item {
        id: lockContent

        readonly property int size: lockIcon.implicitHeight + Appearance.padding.large * 4

        anchors.centerIn: parent
        implicitWidth: size
        implicitHeight: size

        rotation: 180
        scale: 0

        StyledRect {
            id: lockBg

            anchors.fill: parent
            color: Colours.palette.m3surface
            radius: parent.size / 4
            opacity: Colours.transparency.enabled ? Colours.transparency.base : 1

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                blurMax: 15
                shadowColor: Qt.alpha(Colours.palette.m3shadow, 0.7)
            }
        }

        MaterialIcon {
            id: lockIcon

            anchors.centerIn: parent
            text: "lock"
            font.pointSize: Appearance.font.size.extraLarge * 4
            font.bold: true
            rotation: 180
        }

        Content {
            id: content

            lock: root
            opacity: 0
        }
    }

    // Keep your custom layout components
    Clock {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: -backgrounds.clockBottom
    }

    Input {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: -backgrounds.inputTop

        lock: root
    }

    WeatherInfo {
        id: weather

        anchors.top: parent.bottom
        anchors.right: parent.left
        anchors.topMargin: -backgrounds.weatherTop
        anchors.rightMargin: -backgrounds.weatherRight
    }

    Loader {
        id: media

        // Only show if screen is large enough AND there's active media
        active: root.screen.width > Config.lock.sizes.smallScreenWidth && (Players.active !== null && Players.active !== undefined)
        asynchronous: true

        state: root.screen.width > Config.lock.sizes.largeScreenWidth ? "tl" : "br"
        states: [
            State {
                name: "tl"

                AnchorChanges {
                    target: media
                    anchors.bottom: media.parent.top
                    anchors.right: media.parent.left
                }

                PropertyChanges {
                    media.anchors.bottomMargin: -backgrounds.mediaY
                    media.anchors.rightMargin: -backgrounds.mediaX
                }
            },
            State {
                name: "br"

                AnchorChanges {
                    target: media
                    anchors.top: media.parent.bottom
                    anchors.left: media.parent.right
                }

                PropertyChanges {
                    media.anchors.topMargin: -backgrounds.mediaY
                    media.anchors.leftMargin: -backgrounds.mediaX
                }
            }
        ]

        sourceComponent: MediaPlaying {
            isLarge: root.screen.width > Config.lock.sizes.largeScreenWidth
        }
    }

    Loader {
        id: buttons

        active: root.screen.width > Config.lock.sizes.largeScreenWidth
        asynchronous: true

        anchors.top: parent.bottom
        anchors.left: parent.right
        anchors.topMargin: -backgrounds.buttonsTop
        anchors.leftMargin: -backgrounds.buttonsLeft

        sourceComponent: Buttons {}
    }

    Status {
        id: status

        anchors.bottom: parent.top
        anchors.left: parent.right
        anchors.bottomMargin: -backgrounds.statusBottom
        anchors.leftMargin: -backgrounds.statusLeft

        showNotifs: root.screen.width > Config.lock.sizes.largeScreenWidth
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.standard
    }
}
