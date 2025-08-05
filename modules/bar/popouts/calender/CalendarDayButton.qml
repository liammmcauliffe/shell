// This is the updated CalendarDayButton.qml file.
// It now uses the Material 3 color palette to match the dashboard calendar.

import qs.modules.common
import qs.modules.common.widgets
import qs.config
import qs.services
import QtQuick
import QtQuick.Layouts

// A button for a single day in the calendar grid.
RippleButton {
    id: button
    property string day
    // Determines the styling: 1 for today, 0 for a day in the current month, -1 for other months.
    property int isToday
    property bool bold

    // This property now uses the Material 3 color palette to match the dashboard widget.
    property color textColor: {
        if (isToday === 1) return Colours.palette.m3onPrimary;      // Today's text color
        if (isToday === 0) return Colours.palette.m3onSurfaceVariant; // Current month's text color
        return Colours.palette.m3outline;                           // Other month's text color
    }

    Layout.fillWidth: false
    Layout.fillHeight: false
    implicitWidth: 38
    implicitHeight: 38

    toggled: (isToday == 1)
    buttonRadius: Appearance.rounding.full

    // Override RippleButton's default colors to use the live Caelestia theme.
    // The toggled colors are updated to use the M3 palette.
    colBackground: "transparent"
    colBackgroundHover: Qt.rgba(Colours.palette.onSurface.r, Colours.palette.onSurface.g, Colours.palette.onSurface.b, 0.08)
    colBackgroundToggled: Colours.palette.m3primary
    colBackgroundToggledHover: Colours.palette.m3primary
    colRipple: Qt.rgba(Colours.palette.onSurface.r, Colours.palette.onSurface.g, Colours.palette.onSurface.b, 0.12)
    colRippleToggled: Qt.rgba(Colours.palette.onPrimary.r, Colours.palette.onPrimary.g, Colours.palette.onPrimary.b, 0.12)

    contentItem: StyledText {
        anchors.fill: parent
        text: day
        horizontalAlignment: Text.AlignHCenter
        font.weight: bold ? Font.DemiBold : Font.Normal
        // Use the new textColor property to set the color.
        color: button.textColor

        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }
    }
}
