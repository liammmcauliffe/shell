import QtQuick 2.15
import qs.components
import qs.config

Item {
    id: root

    anchors.left: parent.left
    anchors.right: parent.right
    implicitHeight: childrenRect.height
    height: 250

    Backlight {
        id: backlight
        onToggledChanged: {
            backlightButton.isToggled = toggled;
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
                    { id: "cloudflare", icon: "dns", label: "Cloudflare DNS", color: Colours.palette.m3primary },
                    { id: "backlight", icon: "brightness_6", label: "Backlight", color: Colours.palette.m3secondary },
                    { id: "keepAwake", icon: "bedtime_off", label: "Keep Awake", color: Colours.palette.m3tertiary },
                    { id: "gameMode", icon: "sports_esports", label: "Game Mode", color: Colours.palette.m3error },
                    { id: "gammaStep", icon: "visibility", label: "Gamma Step", color: Colours.palette.m3primary },
                    { id: "silenceNotifications", icon: "notifications_off", label: "Silence Notifications", color: Colours.palette.m3secondary }
                ]

                ActionButton {
                    id: button
                    width: buttonGrid.buttonSize
                    height: buttonGrid.buttonSize
                    iconName: modelData.icon
                    tooltipText: modelData.label
                    toggledColor: modelData.color

                    onIsToggledChanged: {
                        if (modelData.id === "backlight") {
                            backlight.toggle(isToggled);
                        }
                    }
                }
            }
        }
    }
}
