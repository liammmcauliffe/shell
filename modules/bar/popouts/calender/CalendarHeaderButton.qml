// This is the updated CalendarHeaderButton.qml file.
// It is updated to use the Material 3 color palette for a consistent look.

import qs.modules.common
import qs.modules.common.widgets
import qs.config
import qs.services
import QtQuick

// A button used in the header of the calendar (e.g., month title, next/prev arrows).
RippleButton {
    id: button
    property string buttonText: ""
    property string tooltipText: ""
    property bool forceCircle: false

    implicitHeight: 30
    implicitWidth: forceCircle ? implicitHeight : (contentItem.implicitWidth + 10 * 2)
    Behavior on implicitWidth {
        SmoothedAnimation {
            velocity: Appearance.animation.elementMove.velocity
        }
    }

    buttonRadius: Appearance.rounding.full

    // Override RippleButton's colors to use the M3 theme.
    colBackground: Colours.palette.m3surfaceContainer
    colBackgroundHover: Qt.rgba(Colours.palette.m3onSurface.r, Colours.palette.m3onSurface.g, Colours.palette.m3onSurface.b, 0.08)
    colRipple: Qt.rgba(Colours.palette.m3onSurface.r, Colours.palette.m3onSurface.g, Colours.palette.m3onSurface.b, 0.12)

    contentItem: StyledText {
        text: buttonText
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Appearance.font.pixelSize.larger
        color: Colours.palette.m3onSurface
    }

    StyledToolTip {
        content: tooltipText
        extraVisibleCondition: tooltipText.length > 0
    }
}
