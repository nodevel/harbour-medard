import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.Landscape | Orientation.Portrait

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height



        Column {
            id: column
            PageHeader {
                title: "About Medard"
            }

            width: parent.width
            spacing: Theme.paddingLarge
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Author"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Jakub Kožíšek"
                font.pixelSize: Theme.fontSizeMedium
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "2013-2015"
                font.pixelSize: Theme.fontSizeMedium
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Data"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Text {
                x: Theme.paddingLarge
                width: parent.width - 2*Theme.paddingLarge
                wrapMode: Text.Wrap
                text: "The MEDARD Project, Work group for non-linear modeling, Institute of Computer Science, Academy of Sciences of the Czech Republic, Prague"
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                horizontalAlignment: Text.AlignCenter
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Website"
                onClicked: {Qt.openUrlExternally('http://www.medard-online.cz/') }
            }
            Text {
                x: Theme.paddingLarge
                width: parent.width - 2*Theme.paddingLarge
                wrapMode: Text.Wrap
                text: "Copyright (c) Institute of Computer Science AS CR 2003-2015."
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                horizontalAlignment: Text.AlignCenter
            }
        }
    }
}


