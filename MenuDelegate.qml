import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root
    property alias text: menuBtn.source
    property alias imagePath: menuImage.source
    width: parent.width
    height: parent.height*0.193
    signal clicked
    Image {
        id: menuImage
        width: parent.width*0.2
        x: parent.width*0.7
        height: parent.height
        source: imagePath
        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked();
        }
    }
    Image {
        id: menuBtn
        width: parent.width*0.65
        height: parent.height
        source: text
        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }



}

