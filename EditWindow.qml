import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0
import QtQuick.Dialogs 1.2

Item {
    id: editWindow
    width: 640
    height: 480
    Image {
        id: image
        x: 0
        y: 0
        width: parent.width
        height: parent.height*0.2
        source: "images/buttons/editPlayers2.png"
    }

    Component.onCompleted: {
        var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
        db.transaction(function(tx)  {
            var results = tx.executeSql("SELECT * FROM player");
            for (var i = 0; i < results.rows.length; i++) {
                playersModel.append({name: results.rows.item(i)["name"], figure: results.rows.item(i)["figure"]});
            }
        });
    }
    
    Button {
        id: deletePlayer
        text: qsTr("Удалить игрока")
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        anchors.bottomMargin: parent.height*0.03
        anchors.topMargin: parent.height*0.9
        enabled: false
        anchors.fill: parent
        onClicked: {
            delPlayer.open();
        }
    }
    
    Button {
        id: changeName
        text: qsTr("Изменить имя")
        enabled: false
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        anchors.bottomMargin: parent.height*0.11
        anchors.topMargin: parent.height*0.82
        anchors.fill: parent
        onClicked: {
            editDialog.open();
        }
    }
    ListModel {
        id: playersModel
    }

    ListView {
        id: listView
        spacing: parent.height*0.05
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        clip: true
        anchors.bottomMargin: parent.height*0.2
        anchors.topMargin: parent.height*0.25
        anchors.fill: parent
        delegate: Item {
            width: listView.width
            height: listView.height*0.1
            Row {
                Image {
                    width: listView.width*0.1
                    height: listView.height*0.1
                    source: figure
                }

                Text {
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                }
                spacing: 10
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listView.currentIndex = index;
                    changeName.enabled = true;
                    deletePlayer.enabled = true;
                }
            }
        }
        model: playersModel
    }
    Dialog {
        id: editDialog
        width: parent.width*0.5
        height: parent.height*0.2
        visible: false
        title: "Изменить имя"
        standardButtons: StandardButton.Yes | StandardButton.No
        TextField {
            id: editNameText
            width: parent.width
            height: parent.height
            placeholderText: "Введите новое имя игрока"
        }
        onYes: {
            var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
            db.transaction(function(tx)  {
                tx.executeSql("UPDATE player SET name = '" + editNameText.text + "' WHERE id = " + listView.currentIndex+1);
            });
            playersModel.setProperty(listView.currentIndex, "name", editNameText.text);
        }
    }
    MessageDialog {
        id: delPlayer
        standardButtons: StandardButton.Yes | StandardButton.No
        text: "Вы уверены, что хотите удалить игрока?"
        onYes: {
            var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
            db.transaction(function(tx)  {
                console.log("DELETE FROM player WHERE name = " + playersModel.get(listView.currentIndex).name);
                tx.executeSql("DELETE FROM player WHERE name = '" + playersModel.get(listView.currentIndex).name + "'");
            });
            playersModel.remove(listView.currentIndex)
        }
    }
}
