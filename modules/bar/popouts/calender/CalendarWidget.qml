// This is the updated CalendarWidget.qml file.
// Contains a fix for the date layout logic in the nested Repeater.

import qs.config
import qs.services
import qs.utils
import "./calendar_layout.js" as CalendarLayout
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../../components"

// The main container for the calendar view, including header and day grid.
Item {
    id: calendarRoot
    anchors.topMargin: 10

    // --- State Properties ---
    property int monthShift: 0
    readonly property var viewingDate: CalendarLayout.getDateInXMonthsTime(monthShift)
    readonly property var calendarLayout: CalendarLayout.getCalendarLayout(viewingDate, monthShift === 0)

    // --- Sizing ---
    width: calendarColumn.width
    implicitHeight: calendarColumn.height + 10 * 2

    // --- Interactions ---
    focus: true // Allow this item to receive key events.
    Keys.onPressed: (event) => {
        if ((event.key === Qt.Key_PageDown || event.key === Qt.Key_Right) && event.modifiers === Qt.NoModifier) {
            monthShift++;
            event.accepted = true;
        } else if ((event.key === Qt.Key_PageUp || event.key === Qt.Key_Left) && event.modifiers === Qt.NoModifier) {
            monthShift--;
            event.accepted = true;
        }
    }
    MouseArea {
        anchors.fill: parent
        onWheel: (event) => {
            if (event.angleDelta.y > 0) monthShift--;
            else if (event.angleDelta.y < 0) monthShift++;
        }
    }

    // --- Main Layout ---
    ColumnLayout {
        id: calendarColumn
        anchors.centerIn: parent
        spacing: 5

        // Calendar header (Month/Year title and navigation arrows)
        RowLayout {
            Layout.fillWidth: true
            spacing: 5

            CalendarHeaderButton {
                clip: true
                buttonText: `${monthShift !== 0 ? "• " : ""}${viewingDate.toLocaleDateString(Qt.locale(), "MMMM yyyy")}`
                tooltipText: (monthShift === 0) ? "" : qsTr("Jump to current month")
                onClicked: monthShift = 0
            }
            Item { Layout.fillWidth: true } // Spacer
            CalendarHeaderButton {
                forceCircle: true
                onClicked: monthShift--
                contentItem: MaterialIcon {
                    text: "chevron_left"
                    font.pixelSize: Appearance.font.pixelSize.larger
                    color: Colours.palette.m3onSurface
                }
            }
            CalendarHeaderButton {
                forceCircle: true
                onClicked: monthShift++
                contentItem: MaterialIcon {
                    text: "chevron_right"
                    font.pixelSize: Appearance.font.pixelSize.larger
                    color: Colours.palette.m3onSurface
                }
            }
        }

        // Weekday headers (Mo, Tu, We, etc.)
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 5
            Repeater {
                model: CalendarLayout.weekDays
                delegate: CalendarDayButton {
                    day: qsTr(modelData.day)
                    isToday: modelData.today
                    bold: true
                    enabled: false
                    textColor: Colours.palette.m3onSurfaceVariant
                }
            }
        }

        // Grid of calendar days
        Repeater {
            model: 6 // 6 rows for the calendar
            delegate: RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 5

                // CORRECTED: The inner repeater's model is now the specific array for the current row.
                // The outer repeater's `modelData` is the row index (0-5).
                Repeater {
                    model: calendarLayout[modelData]

                    // CORRECTED: The delegate now gets the day object directly in its own `modelData`.
                    delegate: CalendarDayButton {
                        day: modelData.day
                        isToday: modelData.today
                    }
                }
            }
        }
    }
}
