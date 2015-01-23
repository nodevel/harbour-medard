import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    SlideshowView {
        id: view
        currentIndex: root.currentIndex
        width: parent.width
        height: (width*(218/331)) + Theme.itemSizeSmall
        itemWidth: width

        highlightMoveDuration: 0

        model: picModel
        delegate: Item {
            width: view.itemWidth
            height: view.height
            Rectangle {
                id: coverimage_crop
                anchors { fill: parent; bottomMargin: Theme.itemSizeSmall }
                color: 'transparent'
                clip: true
                Image {
                    id: coverimage
                    anchors.top: parent.top
                    source: "http://www2.medard-online.cz/GETIMAGE?size=400x280&domain="+domainslist[domainIndex].id+"&fcst="+forecastId+"&initdate="+initdate+"&t="+targetdate
                    cache: true
                    width: parent.width*(400/331)
                    height: width*(280/400)
                    x: -width*(25/400)
                    sourceSize { width: parent.width; height: parent.width}
                    smooth: true
                }
            }
            Label {
                property date targetDate: new Date(targetdate*1000)
                property date initDate: new Date(initdate*1000)
                anchors { horizontalCenter: parent.horizontalCenter; top: coverimage_crop.bottom; bottom: parent.bottom }
                text: targetDate.getDate()+"."+(targetDate.getMonth()+1)+"."+targetDate.getFullYear()+" "+targetDate.getHours()+":"+('0' + targetDate.getMinutes()).slice(-2)
            } // Label
        } // BackgroundItem
    }

    Label {
        id: label_app
        y: 0
        anchors {horizontalCenter: parent.horizontalCenter; margins: Theme.paddingSmall; top: view.bottom}
        color: Theme.highlightColor
        text: "Medard"
    }


    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-previous"
            onTriggered: {
                root.autoDecrement()
            }

        }
        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: {
                root.autoIncrement()
            }
        }
    }
}


