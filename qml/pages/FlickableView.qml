import QtQuick 2.0
import Sailfish.Silica 1.0

SlideshowView {
    id: view
    width: parent.width
    height: width*0.725+Theme.itemSizeMedium
    itemWidth: width
    property bool playing: false

    Timer {
        interval: 500; running: playing; repeat: true
        onTriggered: incrementSmooth()
    }

    Connections {
        target: root
        onAutoIncrement: view.incrementCurrentIndex()
        onAutoDecrement: view.decrementCurrentIndex()
    }
    model: picModel
    onCurrentIndexChanged: {
        forecastIndex = currentIndex
    }
    delegate: BackgroundItem {
        width: view.itemWidth
        height: view.height
        property date targetDate: new Date(targetdate*1000)
        property date initDate: new Date(initdate*1000)
        Column {
            anchors.fill: parent
            spacing: Theme.paddingMedium
            Image {
                id: image
                width: parent.width
                height: width*0.725
                source: "http://www2.medard-online.cz/GETIMAGE?size=800x580&domain="+domainslist[domainIndex].id+"&fcst="+forecastId+"&initdate="+initdate+"&t="+targetdate
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: targetDate.getDate()+"."+(targetDate.getMonth()+1)+"."+targetDate.getFullYear()+" "+targetDate.getHours()+":"+('0' + targetDate.getMinutes()).slice(-2)
                color: Theme.secondaryColor
            } // Label time
        } // Column


        onClicked: playing ? toggle() : view.incrementSmooth()
        onPressAndHold: view.currentIndex = 0
    } // BackgroundItem
    Component.onCompleted: {
        refresh()
    } // onCompleted

    signal toggle
    onToggle: playing = !playing
    signal incrementSmooth
    onIncrementSmooth: {
        var tmpDuration = highlightMoveDuration
        highlightMoveDuration = 0
        incrementCurrentIndex()
        highlightMoveDuration = tmpDuration
    }
    signal decrementSmooth
    onDecrementSmooth: {
        var tmpDuration = highlightMoveDuration
        highlightMoveDuration = 0
        decrementCurrentIndex()
        highlightMoveDuration = tmpDuration
    }
    signal refresh
    onRefresh: {
        loading = true
        var xhr = new XMLHttpRequest;
        var xhr2 = new XMLHttpRequest;
        xhr.open("GET", "http://www2.medard-online.cz/js/settingsClasses.js");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var response = xhr.responseText;
                eval(response)
                xhr2.open("GET", "http://www2.medard-online.cz/SETTINGS");
                xhr2.onreadystatechange = function() {
                    if (xhr2.readyState === XMLHttpRequest.DONE) {
                        var response = xhr2.responseText;
                        eval(response)
                        console.log(CLIENT)
                        initdates = INITDATES
                        domainslist = DOMAINSLIST
                        console.log(Math.floor(Date.now() / 1000))
                        loadModel()
                        loading = false
                    }
                }
                xhr2.send();
            }
            // 40 h in advance
        }
        xhr.send();
    }
}
