// caelestia-dots/shell/shell-6ae451413ddab08fce7326f141ee4e2508237b45/modules/bar/components/Clock.qml
pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import QtQuick

// The problematic import has been removed.

Item {
    id: clockRoot

    // This is your original Column layout, completely preserved.
    Column {
        id: clockColumn
        property color colour: Colours.palette.m3tertiary
        spacing: Appearance.spacing.small

        MaterialIcon {
            id: icon
            text: "calendar_month"
            color: clockColumn.colour
            anchors.horizontalCenter: parent.horizontalCenter
        }

        StyledText {
            id: text
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: StyledText.AlignHCenter
            text: Time.format(Config.services.useTwelveHourClock ? "hh\nmm\nA" : "hh\nmm")
            font.pointSize: Appearance.font.size.smaller
            font.family: Appearance.font.family.mono
            color: clockColumn.colour
        }
    }

    // Make sure the root Item has the same size as the visible clock content
    width: clockColumn.width
    height: clockColumn.height

    // This handler will detect when the mouse enters or leaves the clock area
    HoverHandler {
        id: hoverHandler
        anchors.fill: parent
    }

    // CORRECTED: We now refer to 'Calendar' directly, since it's in the same folder.
    // The "popouts." namespace has been removed.
    Calendar {
        id: calendarPopout

        // Parent the popout to the main bar window to ensure it's drawn on top
        parent: Shell.get("Bar")

        // Position the popout just below the clock component
        x: clockRoot.mapToItem(parent, 0, 0).x + (clockRoot.width / 2) - (width / 2) // Center the popout under the clock
        y: clockRoot.mapToItem(parent, 0, 0).y + clockRoot.height + Appearance.padding.small

        // The 'active' property connects the popout's visibility to the hover handler.
        active: hoverHandler.hovered
    }
}
