pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    
    // Configuration shortcuts
    readonly property var config: Config.background.desktopClock
    
    // Dynamic sizing based on content
    implicitWidth: clockColumn.implicitWidth + Appearance.padding.large * 2
    implicitHeight: clockColumn.implicitHeight + Appearance.padding.large * 2
    
    // No background - clean look for all positions

    ColumnLayout {
        id: clockColumn
        anchors.centerIn: parent
        spacing: 6

        // Time Display
        StyledText {
            id: timeText
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            
            font {
                family: Appearance.font.family.clock
                pointSize: {
                    switch (config.size) {
                        case "small": return Appearance.font.size.extraLarge * 1.5
                        case "large": return Appearance.font.size.extraLarge * 3
                        default: return Appearance.font.size.extraLarge * 2.5
                    }
                }
                weight: Font.Bold
            }
            
            color: Colours.palette.m3onSurface
            style: Text.Raised
            styleColor: Colours.palette.m3shadow
            
            text: Time.format(Config.services.useTwelveHourClock ?
                (config.showSeconds ? "hh:mm:ss A" : "hh:mm A") :
                (config.showSeconds ? "HH:mm:ss" : "HH:mm"))
        }
        
        // Date Display
        StyledText {
            id: dateText
            Layout.fillWidth: true
            Layout.topMargin: -5
            horizontalAlignment: Text.AlignHCenter
            
            font {
                family: Appearance.font.family.clock
                pointSize: {
                    switch (config.size) {
                        case "small": return Appearance.font.size.larger
                        case "large": return Appearance.font.size.extraLarge
                        default: return Appearance.font.size.large * 1.3
                    }
                }
                weight: Font.DemiBold
            }
            
            color: Colours.palette.m3onSurface
            style: Text.Raised
            styleColor: Colours.palette.m3shadow
            
            visible: config.showDate
            text: Time.format(config.dateFormat)
        }
        
    }
}