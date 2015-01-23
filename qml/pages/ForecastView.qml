import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    allowedOrientations: Orientation.Landscape | Orientation.Portrait
    property alias currentIndex: picRoll.currentIndex

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height


        Column {
            id: column

            width: page.width
            spacing: Theme.paddingSmall
            PageHeader {
                id: header
                title: "Medard"
            }
            FlickableView {
                id: picRoll
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingLarge
                IconButton {
                    id: previousIcon
                    icon.source: "image://theme/icon-m-previous"
                    onClicked: picRoll.decrementSmooth()
                } // previous icon
                IconButton {
                    id: playIcon
                    icon.source: picRoll.playing ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
                    onClicked: picRoll.toggle()
                    focus: true
                    Keys.onRightPressed: picRoll.incrementSmooth()
                    Keys.onLeftPressed: picRoll.decrementSmooth()
                    Keys.onSpacePressed: picRoll.toggle()
                    Keys.onPressed: {
                        if (event.key === Qt.Key_S) typeCombo.currentIndex = 0
                        else if (event.key === Qt.Key_W) typeCombo.currentIndex = 1
                        else if (event.key === Qt.Key_T) typeCombo.currentIndex = 2
                        else if (event.key === Qt.Key_P) typeCombo.currentIndex = 3
                        else if (event.key === Qt.Key_C) typeCombo.currentIndex = 4
                        else if (event.key === Qt.Key_R) picRoll.currentIndex = 0
                    }
                    Keys.onTabPressed: {
                        if (regionCombo.currentIndex === 2) regionCombo.currentIndex = 0
                        else regionCombo.currentIndex = regionCombo.currentIndex+1
                    }
                    onPressAndHold: {
                        if (slider.scale == 0.0) {
                            fadeIn.start()
                        } else {
                            fadeOut.start()
                        }
                    }

                } //  Play Button
                IconButton {
                    id: nextIcon
                    icon.source: "image://theme/icon-m-next"
                    onClicked: picRoll.incrementSmooth()
                }
            } // Row
            Slider {
                id: slider
                height: 0.0
                visible: (height != 0)
                scale: height/Theme.itemSizeExtraSmall
                value: picRoll.currentIndex
                width: parent.width
                maximumValue: picRoll.count-1
                minimumValue: 0
                onPressedChanged: picRoll.currentIndex = value
                Connections {
                    target: picRoll
                    onCurrentIndexChanged: slider.value = picRoll.currentIndex
                }
            } // Slider
            ComboBox {
                id: regionCombo
                label: "Region"
                currentItem: getSetting('region')
                menu: ContextMenu {
                      Repeater {
                           model: domainslist.length
                           MenuItem { property var item: domainslist[index]; text: language ? String(item.titleEN) : item.titleCS ? String(item.titleCS) : String(item.titleEN) }
                           Component.onCompleted: delay.start()
                      }
                 }
                Timer { id: delay; interval: 500; running: false; repeat: false; onTriggered: { regionCombo.currentIndex = getSetting('region'); typeCombo.currentIndex = getSetting('forecastIndex') } }

                onCurrentIndexChanged: {
                    fillTypes(currentIndex)
                    domainIndex = currentIndex
                    console.log(getSetting("region"))
                    saveSetting("region", currentIndex);
                    console.log(getSetting("region"))
                }
                Component.onCompleted: {
                    fillTypes(0)
                }
            } // region ComboBox
            ComboBox {
                id: typeCombo
                label: "Type"
                currentItem: getSetting('forecastIndex')
                menu: ContextMenu {
                      Repeater {
                           model: 5
                           MenuItem {
                               property var item: domainslist[regionCombo.currentIndex].forecasts[index]
                               text: item.titleCS ? (language ? item.titleEN : item.titleCS) : item.id
                           }
                      }
                 }
                onCurrentIndexChanged: {
                    var forecast_type = forecastsModel.get(currentIndex).id
                    forecastId = forecast_type
                    saveSetting("forecast", forecast_type);
                    saveSetting("forecastIndex", currentIndex);
                }
            } // ComboBox type

        } // Column

        PushUpMenu {
            MenuItem {
                text: qsTr("Refresh")
                onClicked: picRoll.refresh()
            }
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutView.qml"))
            }
        }
    }
    BusyIndicator {
        anchors.centerIn: parent
        running: loading
    }
    PropertyAnimation {
        id: fadeIn
        target: slider;
        property: "height";
        from: 0.0;
        to: Theme.itemSizeExtraSmall;
        duration: 450;
        loops: 1;
    }
    PropertyAnimation {
        id: fadeOut
        target: slider;
        property: "height";
        from: Theme.itemSizeExtraSmall;
        to: 0.0;
        duration: 450;
        loops: 1;
    }

}


