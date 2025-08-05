pragma ComponentBehavior: Bound

import QtQuick
import qs.config
// Import the directory containing the widget. This makes the CalendarWidget
// component available directly, resolving the namespace issue.
import "./calender"

/*
 * This is the main Calendar component that acts as a popout.
 * It serves as a wrapper for the more complex CalendarWidget,
 * ensuring it fits correctly within the application's existing UI structure.
 */
Column {
    id: root

    // Using the same properties as the original Calendar.qml for drop-in compatibility.
    width: 300
    height: 318
    padding: Appearance.padding.large
    spacing: Appearance.spacing.small

    // Instantiate the new calendar widget from the 'calender' folder.
    // We can now use "CalendarWidget" as a type directly.
    CalendarWidget {
        id: calendarWidget

        // Center the actual calendar widget within this container.
        // The Column layout handles vertical positioning, and this handles horizontal.
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
