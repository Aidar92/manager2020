import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0


ApplicationWindow {
    id: mainWindow
    width: 640
    height: 480
    visible: false
    title: qsTr("Главное окно")
    style: ApplicationWindowStyle {
        background: BorderImage {
            source: "images/background.png"
        }
    }

    property alias pId: comboBox.currentIndex
    onFocusObjectChanged: {
        playersModel.clear();
        playersModel.append({text: "Выберите игрока"});
        if (pId === 0) totalCash.text = "Общее состояние = "
        var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
        db.transaction(function(tx) {
            var results = tx.executeSql("SELECT * FROM player");
            for (var i = 0; i < results.rows.length;i++) {
                playersModel.append({text: results.rows.item(i).name})
            }

        });

    }

    Component.onCompleted: {
        playersModel.append({text: "Выберите игрока"})
        helloWindow.show();
    }

    HelloWindow {
        id: helloWindow
    }

    ListModel {
        id: playersModel
    }

    ListModel {
        id: pageModel
        ListElement {
            title: "images/buttons/buyCompany2.png"
            page: "CompanyWindow.qml"
            imageSourse: "images/buttons/buyCompany.png"

        }
        ListElement {
            title: "images/buttons/buyLevelUp2.png"
            page: "LevelUpWindow.qml"
            imageSourse: "images/buttons/buyLevelUp.png"
        }
        ListElement {
            title: "images/buttons/conj2.png"
            page: "ConjectureWindow.qml"
            imageSourse: "images/buttons/conj.png"
        }
        ListElement {
            title: "images/buttons/profit2.png"
            page: "CashWindow.qml"
            imageSourse: "images/buttons/profit.png"
        }
        ListElement {
            title: "images/buttons/editPlayers2.png"
            page: "EditWindow.qml"
            imageSourse: "images/buttons/editPlayers.png"
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        focus: true
        Keys.onReleased: {
            if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace) {

                if (stackView.depth > 1) {
                    totalCash.text = "Общее состояние = ";
                    if (comboBox.currentIndex > 0) {
                        totalCash.text = "Общее состояние = ";
                    }
                    playersModel.clear();
                    playersModel.append({text: "Выберите игрока"});
                    var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
                    db.transaction(function(tx) {
                        var results = tx.executeSql('SELECT * FROM player');
                        totalCash.text += results.rows.item(comboBox.currentIndex-1)["total"]
                        for (var i = 0; i < results.rows.length; i++) {
                            playersModel.append({text: results.rows.item(i).name});

                        }
                        var conj_id = results.rows.item(0).conj_id;
                        if (conj_id !== -1) {
                            var xhr = new XMLHttpRequest();
                            xhr.onreadystatechange = function() {
                                if (xhr.readyState === 4) {
                                    if (xhr.status === 200) {
                                        var source = JSON.parse(xhr.responseText)["conjectures"][conj_id].image;
                                        image6.source = source;
                                    }
                                    else {
                                        console.log(xhr.status);
                                    }
                                }
                            }
                            xhr.open("GET", "data.json", false);
                            xhr.setRequestHeader("Content-Type", "application/json");
                            xhr.send();
                        }

                    });
                    stackView.pop();
                    event.accepted = true
                }
                else {
                    Qt.quit();
                }
            }
        }
        initialItem: Item {
            width: parent.width
            height: parent.height
            Image {
                id: image
                width: parent.width*0.9
                height: parent.height*0.2
                anchors.left: parent.left
                anchors.leftMargin: parent.width*0.05
                anchors.top: parent.top
                anchors.topMargin: 0
                source: "images/manager2020.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://manager2020.ru")
                }
            }


            ComboBox {
                id: comboBox
                x: parent.width*0.05
                y: parent.height*0.21

                width: parent.width*0.8
                height: parent.height*0.05
                model: playersModel
                Component.onCompleted: {
                    totalCash.text = "Общее состояние = ";
                    if (currentIndex > 0) {
                        totalCash.text = "Общее состояние = ";
                        var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
                        db.transaction(function(tx) {
                            var results = tx.executeSql('SELECT * FROM player');
                                totalCash.text += JSON.parse(results.rows.item(currentIndex-1).data)["total"]
                        });
                    }
                }

                onCurrentIndexChanged: {
                    totalCash.text = "Общее состояние = ";
                    if (currentIndex > 0) {
                        var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
                        db.transaction(function(tx) {
                            var results = tx.executeSql('SELECT * FROM player');
                                totalCash.text += results.rows.item(currentIndex-1).total
                        });
                    }

                }
            }
            GridView {
                id: grid
                cellHeight: grid.height / 5
                cellWidth: grid.width / 2
                anchors.fill: parent
                anchors.topMargin: parent.height*0.3
                anchors.leftMargin: parent.width*0.05
                anchors.rightMargin: parent.width*0.05
                anchors.bottomMargin: parent.height*0.3
                interactive: false
                ListView {
                    model: pageModel
                    spacing: parent.height*0.01
                    interactive: false
                    anchors.fill: parent
                    delegate: MenuDelegate {
                        text: title
                        imagePath: imageSourse
                        onClicked: stackView.push(Qt.resolvedUrl(page))
                    }
                }

            }


            Text {
                id: totalCash
                text: qsTr("Общее состояние = ")
                fontSizeMode: Text.HorizontalFit
                anchors.rightMargin: parent.width*0.05
                anchors.leftMargin: parent.width*0.05
                anchors.topMargin: parent.height*0.765
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: parent.top
            }

            Image {
                id: image6
                height: parent.height*0.2
                anchors.rightMargin: parent.width*0.2
                anchors.leftMargin: parent.width*0.2
                anchors.right: parent.right
                anchors.topMargin: parent.height*0.8
                anchors.top: parent.top
                anchors.left: parent.left
            }
        }
    }











}
