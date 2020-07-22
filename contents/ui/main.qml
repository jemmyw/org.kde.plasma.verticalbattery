import QtQuick 2.1
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponent
import org.kde.kcoreaddons 1.0 as KCoreAddons

import org.kde.kquickcontrolsaddons 2.0
import "logic.js" as Logic

Item {
    id: vbatterywidget
	AppletConfig { id: config }

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    property var inhibitions: []

    readonly property var kcms: ["powerdevilprofilesconfig.desktop",
                                 "powerdevilactivitiesconfig.desktop",
                                 "powerdevilglobalconfig.desktop"]

    readonly property bool kcmsAuthorized: KCMShell.authorize(vbatterywidget.kcms).length > 0

    function action_powerdevilkcm() {
        KCMShell.open(vbatterywidget.kcms);
    }

    Component.onCompleted: {
        Logic.updateInhibitions(vbatterywidget, pmSource)

        if (vbatterywidget.kcmsAuthorized) {
            plasmoid.setAction("powerdevilkcm", i18n("&Configure Power Saving..."), "preferences-system-power-management");
        }
    }

    property QtObject batteries: PlasmaCore.SortFilterModel {
        id: batteries
        filterRole: "Is Power Supply"
        sortOrder: Qt.DescendingOrder
        sourceModel: PlasmaCore.SortFilterModel {
            sortRole: "Pretty Name"
            sortOrder: Qt.AscendingOrder
            sortCaseSensitivity: Qt.CaseInsensitive
            sourceModel: PlasmaCore.DataModel {
                dataSource: pmSource
                sourceFilter: "Battery[0-9]+"
            }
        }
    }

	  // PlasmaCore.DataSource {
    property QtObject pmSource: PlasmaCore.DataSource {
		    id: pmSource
		    engine: "powermanagement"
		    connectedSources: sources
		    onSourceAdded: {
			      // console.log('onSourceAdded', source)
			      disconnectSource(source)
			      connectSource(source)
		    }
		    onSourceRemoved: {
			      disconnectSource(source)
		    }

        onDataChanged: {
            Logic.updateInhibitions(vbatterywidget, pmSource)
        }

	  }


	function getData(sourceName, key, def) {
		var source = pmSource.data[sourceName]
		if (typeof source === 'undefined') {
			return def;
		} else {
			var value = source[key]
			if (typeof value === 'undefined') {
				return def;
			} else {
				return value;
			}
		}
	}

    property string currentBatteryName: 'Battery'
    property string currentBatteryState: getData(currentBatteryName, 'State', false)
    property int currentBatteryPercent: getData(currentBatteryName, 'Percent', 100)
    property bool currentBatteryLowPower: currentBatteryPercent <= config.lowBatteryPercent
    property color currentTextColor: {
        if (currentBatteryLowPower) {
                return config.lowBatteryColor
        } else {
                return config.normalColor
        }
    }


	property color normalColor: theme.textColor
    property int batteryRadius: 4

    Plasmoid.compactRepresentation: Item {
        Layout.preferredWidth: 10 * units.devicePixelRatio
        Layout.preferredHeight: 256 * units.devicePixelRatio
        Layout.minimumWidth: 1 * units.devicePixelRatio
        Layout.maximumWidth: 20 * units.devicePixelRatio
        Layout.minimumHeight: 50 * units.devicePixelRatio

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: config.margin
            anchors.rightMargin: config.margin
            id: layout

            Rectangle {
                id: border
                color: config.backgroundColor
                radius: batteryRadius
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    id: container
                    color: "transparent"
                    border.color: config.normalColor
                    radius: batteryRadius
                    anchors.fill: parent

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        Repeater {
                            model: config.batteryBars
                            Rectangle {
                                color: (currentBatteryPercent/100)*config.batteryBars > (config.batteryBars - 1 - index) ? config.normalColor : 'transparent'
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }
                    }
                }
            }

            PlasmaComponent.Label {
                id: percentText
                text: {
                        if (currentBatteryPercent > 0) {
                            return '' + currentBatteryPercent + '%'
                        } else {
                            return '100%';
                        }
                }
                font.pixelSize: config.fontSize
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                color: config.textColor
            }

            DropShadow {
                anchors.fill: percentText
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 17
                color: "#80000000"
                source: percentText
            }
        }
    }
}