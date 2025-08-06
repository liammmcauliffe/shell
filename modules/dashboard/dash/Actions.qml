import QtQuick 2.15
import qs.components
import qs.config
import qs.services

Item {
    id: root

    anchors.left: parent.left
    anchors.right: parent.right
    implicitHeight: childrenRect.height
    height: 250

    Backlight {
        id: backlight
        
        onToggledChanged: {
            // Find the backlight button in the Repeater and update its state
            for (var i = 0; i < buttonGrid.children.length; i++) {
                if (buttonGrid.children[i].objectName === "backlightButton") {
                    buttonGrid.children[i].isUpdating = true
                    buttonGrid.children[i].isToggled = toggled;
                    Qt.callLater(function() {
                        buttonGrid.children[i].isUpdating = false
                    })
                    break;
                }
            }
        }
        
        Component.onCompleted: {
            // Ensure initial state is synchronized
            Qt.callLater(function() {
                for (var i = 0; i < buttonGrid.children.length; i++) {
                    if (buttonGrid.children[i].objectName === "backlightButton") {
                        buttonGrid.children[i].isToggled = toggled;
                        break;
                    }
                }
            });
        }
    }

    NightLight {
        id: nightLight
        
        onToggledChanged: {
            // Find the night light button in the Repeater and update its state
            for (var i = 0; i < buttonGrid.children.length; i++) {
                if (buttonGrid.children[i].objectName === "nightLightButton") {
                    buttonGrid.children[i].isUpdating = true
                    buttonGrid.children[i].isToggled = toggled;
                    Qt.callLater(function() {
                        buttonGrid.children[i].isUpdating = false
                    })
                    break;
                }
            }
        }
        
        Component.onCompleted: {
            // Ensure initial state is synchronized
            Qt.callLater(function() {
                for (var i = 0; i < buttonGrid.children.length; i++) {
                    if (buttonGrid.children[i].objectName === "nightLightButton") {
                        buttonGrid.children[i].isToggled = toggled;
                        break;
                    }
                }
            });
        }
    }

    GameMode {
        id: gameMode
        
        onToggledChanged: {
            // Find the game mode button in the Repeater and update its state
            for (var i = 0; i < buttonGrid.children.length; i++) {
                if (buttonGrid.children[i].objectName === "gameModeButton") {
                    buttonGrid.children[i].isUpdating = true
                    buttonGrid.children[i].isToggled = toggled;
                    Qt.callLater(function() {
                        buttonGrid.children[i].isUpdating = false
                    })
                    break;
                }
            }
        }
        
        Component.onCompleted: {
            // Ensure initial state is synchronized
            Qt.callLater(function() {
                for (var i = 0; i < buttonGrid.children.length; i++) {
                    if (buttonGrid.children[i].objectName === "gameModeButton") {
                        buttonGrid.children[i].isToggled = toggled;
                        break;
                    }
                }
            });
        }
    }

    KeepAwake {
        id: keepAwake
        
        onToggledChanged: {
            // Find the keep awake button in the Repeater and update its state
            for (var i = 0; i < buttonGrid.children.length; i++) {
                if (buttonGrid.children[i].objectName === "keepAwakeButton") {
                    buttonGrid.children[i].isUpdating = true
                    buttonGrid.children[i].isToggled = toggled;
                    Qt.callLater(function() {
                        buttonGrid.children[i].isUpdating = false
                    })
                    break;
                }
            }
        }
        
        Component.onCompleted: {
            // Ensure initial state is synchronized
            Qt.callLater(function() {
                for (var i = 0; i < buttonGrid.children.length; i++) {
                    if (buttonGrid.children[i].objectName === "keepAwakeButton") {
                        buttonGrid.children[i].isToggled = toggled;
                        break;
                    }
                }
            });
        }
    }

    Cloudflare {
        id: cloudflare
        
        onToggledChanged: {
            // Find the cloudflare button in the Repeater and update its state
            for (var i = 0; i < buttonGrid.children.length; i++) {
                if (buttonGrid.children[i].objectName === "cloudflareButton") {
                    buttonGrid.children[i].isUpdating = true
                    buttonGrid.children[i].isToggled = toggled;
                    Qt.callLater(function() {
                        buttonGrid.children[i].isUpdating = false
                    })
                    break;
                }
            }
        }
        
        Component.onCompleted: {
            // Ensure initial state is synchronized
            Qt.callLater(function() {
                for (var i = 0; i < buttonGrid.children.length; i++) {
                    if (buttonGrid.children[i].objectName === "cloudflareButton") {
                        buttonGrid.children[i].isToggled = toggled;
                        break;
                    }
                }
            });
        }
    }

    SilenceNotifications {
        id: silenceNotifications
        
        onToggledChanged: {
            // Find the silence notifications button in the Repeater and update its state
            for (var i = 0; i < buttonGrid.children.length; i++) {
                if (buttonGrid.children[i].objectName === "silenceNotificationsButton") {
                    buttonGrid.children[i].isUpdating = true
                    buttonGrid.children[i].isToggled = toggled;
                    Qt.callLater(function() {
                        buttonGrid.children[i].isUpdating = false
                    })
                    break;
                }
            }
        }
        
        Component.onCompleted: {
            // Ensure initial state is synchronized
            Qt.callLater(function() {
                for (var i = 0; i < buttonGrid.children.length; i++) {
                    if (buttonGrid.children[i].objectName === "silenceNotificationsButton") {
                        buttonGrid.children[i].isToggled = toggled;
                        break;
                    }
                }
            });
        }
    }

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
                    { id: "cloudflare", icon: "dns", label: "Cloudflare WARP", color: Colours.palette.m3primary },
                    { id: "backlight", icon: "brightness_6", label: "Backlight", color: Colours.palette.m3secondary },
                    { id: "keepAwake", icon: "bedtime_off", label: "Keep Awake", color: Colours.palette.m3tertiary },
                    { id: "gameMode", icon: "sports_esports", label: "Game Mode", color: Colours.palette.m3primary },
                    { id: "nightLight", icon: "nightlight", label: "Night Light", color: Colours.palette.m3error },
                    { id: "silenceNotifications", icon: "notifications_off", label: "Silence Notifications", color: Colours.palette.m3secondary }
                ]

                ActionButton {
                    // Use objectName to identify specific buttons
                    objectName: modelData.id === "backlight" ? "backlightButton" : 
                               modelData.id === "nightLight" ? "nightLightButton" : 
                               modelData.id === "gameMode" ? "gameModeButton" : 
                               modelData.id === "keepAwake" ? "keepAwakeButton" : 
                               modelData.id === "cloudflare" ? "cloudflareButton" : 
                               modelData.id === "silenceNotifications" ? "silenceNotificationsButton" : ""
                    width: buttonGrid.buttonSize
                    height: buttonGrid.buttonSize
                    iconName: modelData.icon
                    tooltipText: modelData.label
                    toggledColor: modelData.color

                    onIsToggledChanged: {
                        if (!isUpdating) {
                            isUpdating = true
                            if (modelData.id === "backlight") {
                                backlight.toggle(isToggled);
                            } else if (modelData.id === "nightLight") {
                                nightLight.toggle(isToggled);
                            } else if (modelData.id === "gameMode") {
                                gameMode.toggle(isToggled);
                            } else if (modelData.id === "keepAwake") {
                                keepAwake.toggle();
                            } else if (modelData.id === "cloudflare") {
                                cloudflare.toggle(isToggled);
                            } else if (modelData.id === "silenceNotifications") {
                                silenceNotifications.toggle(isToggled);
                            }
                            Qt.callLater(function() {
                                isUpdating = false
                            })
                        }
                    }
                }
            }
        }
    }
}
