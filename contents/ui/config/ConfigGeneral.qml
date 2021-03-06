import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kcoreaddons 1.0 as KCoreAddons

import ".."
import "../lib"

ConfigPage {
	id: page
	showAppletVersion: true

	AppletConfig { id: config }

	ConfigSection {
		label: i18n("Vertical Battery")

		ConfigSpinBox {
			before: i18n('Battery bars')
			configKey: 'batteryBars'
			value: config.batteryBars
			minimumValue: 3
			maximumValue: 20
		}

		ConfigSpinBox {
			before: i18n("Margin")
			suffix: "px"
			configKey: "margin"
			value: config.margin
			minimumValue: 0
			maximumValue: 100
		}

		ConfigColor {
			label: i18n("Background")
			configKey: 'backgroundColor'
			defaultColor: config.defaultBackgroundColor
		}

		ConfigColor {
			label: i18n("Normal")
			configKey: 'normalColor'
			defaultColor: config.defaultNormalColor
		}

		ConfigColor {
			label: i18n("Charging")
			configKey: 'chargingColor'
			defaultColor: config.defaultChargingColor
		}
		RowLayout {
			ConfigSpinBox {
				before: i18n("Low Battery")
				suffix: '%'
				configKey: 'lowBatteryPercent'
				minimumValue: 0
				maximumValue: 100
			}
			ConfigColor {
				label: ''
				configKey: 'lowBatteryColor'
				defaultColor: config.defaultLowBatteryColor
			}
		}
	}
	ExclusiveGroup { id: percentageAlign }
	ConfigSection {
		label: i18n("Percentage")

		ConfigCheckBox {
			id: percentageCheckbox
			text: i18n("Enabled")
			configKey: 'showPercentage'
		}

		ConfigSpinBox {
			before: i18n("Padding")
			suffix: 'px'
			enabled: plasmoid.configuration.showPercentage
			configKey: 'padding'
			value: config.padding
			minimumValue: 0
			maximumValue: 100
		}
	}

	ConfigSection {
		label: i18n("Font")

		ConfigSpinBox {
			before: i18n("Font Size")
			suffix: 'px'
			configKey: 'fontSize'
			value: config.fontSize
			minimumValue: 0
			maximumValue: 100
		}

		ConfigColor {
			label: i18n("Text Color")
			configKey: 'textColor'
			defaultColor: config.defaultTextColor
		}
	}
}
