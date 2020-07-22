import QtQuick 2.0

QtObject {
	readonly property color defaultBackgroundColor: theme.backgroundColor
	readonly property color backgroundColor: plasmoid.configuration.backgroundColor || defaultBackgroundColor

	readonly property color defaultNormalColor: theme.textColor
	readonly property color normalColor: plasmoid.configuration.normalColor || defaultNormalColor

	readonly property color defaultChargingColor: '#1e1'
	readonly property color chargingColor: plasmoid.configuration.chargingColor || defaultChargingColor

	readonly property color defaultLowBatteryColor: '#e33'
	readonly property color lowBatteryColor: plasmoid.configuration.lowBatteryColor || defaultLowBatteryColor

	readonly property int defaultFontSize: 16
	readonly property int fontSize: plasmoid.configuration.fontSize || defaultFontSize

	readonly property color defaultTextColor: theme.textColor
	readonly property color textColor: plasmoid.configuration.textColor || defaultTextColor

	readonly property int defaultPadding: 8
	readonly property int padding: plasmoid.configuration.padding || defaultPadding

	readonly property int defaultMargin: 10
	readonly property int margin: plasmoid.configuration.margin || defaultMargin

	readonly property int batteryBars: plasmoid.configuration.batteryBars
}
