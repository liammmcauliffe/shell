pragma ComponentBehavior: Bound

import qs.components
import qs.components.containers
import qs.services
import qs.config
import Quickshell
import Quickshell.Wayland
import QtQuick

Loader {
    asynchronous: true
    active: Config.background.enabled

    sourceComponent: Variants {
        model: Quickshell.screens

        StyledWindow {
            id: win

            required property ShellScreen modelData

            screen: modelData
            name: "background"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Background
            color: "black"

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            Wallpaper {
                id: wallpaper
            }

            Loader {
                readonly property bool shouldBeActive: Config.background.visualiser.enabled && (!Config.background.visualiser.autoHide || Hypr.monitorFor(win.modelData).activeWorkspace.toplevels.values.every(t => t.lastIpcObject.floating)) ? 1 : 0
                property real offset: shouldBeActive ? 0 : win.modelData.height * 0.2

                anchors.fill: parent
                anchors.topMargin: offset
                anchors.bottomMargin: -offset
                opacity: shouldBeActive ? 1 : 0
                active: opacity > 0
                asynchronous: true

                sourceComponent: Visualiser {
                    screen: win.modelData
                    wallpaper: wallpaper
                }

                Behavior on offset {
                    Anim {}
                }

                Behavior on opacity {
                    Anim {}
                }
            }

            mask: Region {}


            Loader {
                id: clockLoader
                active: Config.background.desktopClock.enabled
                asynchronous: true
                source: "DesktopClock.qml"
                
                // Simple positioning based on configuration
                x: {
                    const pos = Config.background.desktopClock.position
                    const barWidth = Config.bar.sizes.innerWidth
                    const padding = Appearance.padding.large
                    switch (pos) {
                        case "top-left": return barWidth + padding
                        case "top-right": return parent.width - width - barWidth
                        case "bottom-left": return barWidth + padding
                        case "bottom-right": return parent.width - width - barWidth
                        case "center": return (parent.width - width) / 2
                        case "random": return Math.random() * (parent.width - width - barWidth - padding) + barWidth + padding
                        case "custom": return Config.background.desktopClock.customX
                        default: return (parent.width - width) / 2
                    }
                }
                
                y: {
                    const pos = Config.background.desktopClock.position
                    const padding = Appearance.padding.large
                    switch (pos) {
                        case "top-left": return padding
                        case "top-right": return padding
                        case "bottom-left": return parent.height - height - padding
                        case "bottom-right": return parent.height - height - padding
                        case "center": return (parent.height - height) / 2
                        case "random": return Math.random() * (parent.height - height - padding * 2) + padding
                        case "custom": return Config.background.desktopClock.customY
                        default: return (parent.height - height) / 2
                    }
                }
            }
        }
    }
}
