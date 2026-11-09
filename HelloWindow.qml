import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0


Window {
    id: helloWindow
    width: 640
    height: 480
    title: qsTr("Приветственный экран")
    Component.onCompleted: {
        var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
        db.transaction(function(tx) {
            tx.executeSql('DROP TABLE IF EXISTS player');
            tx.executeSql('CREATE TABLE IF NOT EXISTS player(id INTEGER, name TEXT, figure TEXT, companies TEXT,total INTEGER, conj_id INTEGER )');
            tx.executeSql('DELETE FROM player');
        });
    }
    Image {
        id: backgroundImage
        source: "images/background.png"
        width: parent.width
        height: parent.height
        fillMode: Image.Stretch
    }

    Image {
        id: image
        width: parent.width*0.9
        height: parent.height*0.2
        anchors.left: parent.left
        anchors.leftMargin: parent.width*0.05
        anchors.top: parent.top
        anchors.topMargin: 0
        source: "images/manager2020.png"
    }

    ColumnLayout {
        y: parent.height*0.21
        width: parent.width*0.9
        height: parent.height*0.05
        anchors.rightMargin: parent.width*0.1
        anchors.right: parent.right
        anchors.leftMargin: parent.width*0.05
        anchors.left: parent.left

        TextField {
            id: nameField
            anchors.fill: parent
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillWidth: true
            placeholderText: qsTr("Введите имя игрока")
            maximumLength: 20
        }
    }

    ColumnLayout {
        id: columnLayout
        y: parent.height*0.27
        width: parent.width*0.5
        height: parent.height*0.4
        spacing: parent.height*0.05
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        anchors.right: parent.right
        anchors.left: parent.left

        GroupBox {
            id: groupBox
            width: parent.width
            height: parent.height
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillHeight: true
            Layout.fillWidth: true

            title: qsTr("Выберите фигурку")

            ExclusiveGroup { id: exclGroup }

            GridLayout {
                id: gridLayout1
                width: parent.width
                height: parent.height
                columnSpacing: parent.width*0.05
                rowSpacing: parent.height*0.2
                rows: 2
                columns: 3
                anchors.fill: parent

                RadioButton {
                    id: figure1
                    objectName: "images/figures/players/chizik2.png"
                    implicitWidth: parent.width*0.3
                    implicitHeight: parent.height*0.4
                    activeFocusOnPress: false
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    exclusiveGroup: exclGroup
                    style: RadioButtonStyle {
                        indicator: Image {
                            width: control.width
                            height: control.height
                            source: "images/figures/players/chizik2.png"
                            opacity: figure1.checked ? 1 : 0.4
                        }
                    }
                }
                RadioButton {
                    id: figure2
                    objectName: "images/figures/players/angel2.png"
                    implicitWidth: parent.width*0.3
                    implicitHeight: parent.height*0.4
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    exclusiveGroup: exclGroup
                    style: RadioButtonStyle {
                        indicator: Image {
                            width: control.width
                            height: control.height
                            source: "images/figures/players/angel2.png"
                            opacity: figure2.checked ? 1 : 0.4
                        }
                    }
                }

                RadioButton {
                    id: figure3
                    objectName: "images/figures/players/grifon2.png"
                    implicitWidth: parent.width*0.3
                    implicitHeight: parent.height*0.4
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    exclusiveGroup: exclGroup
                    style: RadioButtonStyle {
                        indicator: Image {
                            width: control.width
                            height: control.height
                            source: "images/figures/players/grifon2.png"
                            opacity: figure3.checked ? 1 : 0.4
                        }
                    }

                }

                RadioButton {
                    id: figure4
                    objectName: "images/figures/players/lion2.png"
                    implicitWidth: parent.width*0.3
                    implicitHeight: parent.height*0.4
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    exclusiveGroup: exclGroup
                    style: RadioButtonStyle {
                        indicator: Image {
                            width: control.width
                            height: control.height
                            source: "images/figures/players/lion2.png"
                            opacity: figure4.checked ? 1 : 0.4
                        }
                    }
                }

                RadioButton {
                    id: figure5
                    objectName: "images/figures/players/sphinx2.png"
                    implicitWidth: parent.width*0.3
                    implicitHeight: parent.height*0.4
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    exclusiveGroup: exclGroup
                    style: RadioButtonStyle {
                        indicator: Image {
                            width: control.width
                            height: control.height
                            source: "images/figures/players/sphinx2.png"
                            opacity: figure5.checked ? 1 : 0.4
                        }
                    }

                }

            }

        }
}
        Button {
            id: addButton
            x: parent.width*0.05
            y: parent.height*0.7
            height: parent.height*0.05
            text: qsTr("Добавить игрока")
            enabled: exclGroup.current && nameField.length > 3
            onClicked: {
                playerModel.append({name: nameField.text, image: exclGroup.current.objectName});
                exclGroup.current.opacity = 0;
                exclGroup.current.enabled = false


                var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
                db.transaction(function(tx) {
                    tx.executeSql('INSERT INTO player VALUES(?,?,?,?,?,?)', [playerModel.count, nameField.text, exclGroup.current.objectName, "", 0, -1]);
                    tx.executeSql("UPDATE player SET companies=IfNull(companies, '')");

                });
                nameField.text = "";
                exclGroup.current = null;


            }

        }

    ListModel {
        id: playerModel
    }

    GridLayout {
        id: gridLayout
        y: parent.height*0.76
        width: parent.width*0.9
        height: parent.height*0.15
        rows: 3
        columns: 5
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        anchors.right: parent.right
        anchors.left: parent.left
        ListView {
            anchors.fill: parent
            orientation: Qt.Horizontal
            model: playerModel
            delegate: Column {
                width:  gridLayout.width*0.2
                height: gridLayout.height
                Image {
                    width: gridLayout.width*0.19
                    height: gridLayout.height*0.8
                    source: image
                }

                Text {
                    width: gridLayout.width*0.19
                    height: gridLayout.height*0.2
                    text: name
                    fontSizeMode: Text.HorizontalFit
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

    }

    RowLayout {
        id: rowLayout
        y: parent.height*0.92
        width: parent.width*0.9
        height: parent.height*0.05
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        anchors.right: parent.right
        anchors.left: parent.left

        Button {
            id: helpBtn
            text: qsTr("Вкл./ Выкл. подсказки")
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Button {
            id: startBtn
            text: qsTr("Начать игру")
            enabled: playerModel.count >= 3
            Layout.fillHeight: true
            isDefault: true
            Layout.fillWidth: true
            onClicked: {
                mainWindow.show();
                helloWindow.close();
            }
        }
    }
}
