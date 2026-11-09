import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0

Item {
    id: levelUpWindow
    width: 640
    height: 480
    Image {
        id: image
        x: 0
        y: 0
        width: parent.width
        height: parent.height*0.2
        source: "images/buttons/buyLevelUp2.png"
    }
    Component.onCompleted: {
        companiesModel.clear();
        var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
        db.transaction(function(tx) {
            var results = tx.executeSql("SELECT * FROM player WHERE id = " + pId);
            nameField.text = results.rows.item(0)["name"];
            if (results.rows.item(0)["companies"].length > 0) {
                results.rows.item(0)["companies"].split(',').slice(0,-1).forEach(function(item) {
                    companiesModel.append({name: item.split('_')[0], level: item.split('_')[2]});

                });

            }
        });
    }

    Image {
        id: image1
        y: parent.height*0.8
        height: parent.height*0.2
        anchors.rightMargin: parent.width*0.1
        anchors.leftMargin: parent.width*0.1
        anchors.right: parent.right
        anchors.left: parent.left
    }

    Text {
        id: nameField
        fontSizeMode: Text.VerticalFit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        anchors.bottomMargin: parent.height*0.75
        anchors.topMargin: parent.height*0.21
        anchors.fill: parent
        font.pixelSize: 12
    }
    ListModel {
        id: companiesModel
    }

    ListView {
        id: listView
        clip: true
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        anchors.bottomMargin: parent.height*0.4
        anchors.topMargin: parent.height*0.28
        anchors.fill: parent
        delegate: Item {
            width: listView.width
            height: listView.height*0.2
            Row {
                spacing: listView.width*0.1
                Text {
                    text: name
                    width: listView.width*0.7
                }
                Text {
                    width: listView.width*0.2
                    text: level
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listView1.visible = true;
                    listView.currentIndex = index;
                }
            }
        }
        model: companiesModel
    }
    ListModel {
        id: levelsModel
        ListElement {
            name: "1"
        }

        ListElement {
            name: "2"
        }

        ListElement {
            name: "3"
        }

        ListElement {
            name: "0"
        }
    }

    ListView {
        id: listView1
        orientation: ListView.Horizontal
        clip: true
        visible: false
        spacing: width*0.05
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        anchors.bottomMargin: parent.height*0.21
        anchors.topMargin: parent.height*0.61
        anchors.fill: parent

        delegate: Item {
            width: listView1.width*.2
            height: listView1.height;
            Text {
                text: name
                fontSizeMode: Text.VerticalFit
                width: listView1.width*0.2
                height: listView1.height
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listView1.currentIndex = index;
                    var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
                    db.transaction(function(tx) {
                        var results = tx.executeSql("SELECT * FROM player WHERE id = " + pId);
                        tx.executeSql('UPDATE player SET total = 0 WHERE id = ' + pId)
                        if (results.rows.item(0)["companies"].length > 0) {
                            var companies = results.rows.item(0)["companies"].split(',').slice(0,-1);
                            companies[listView.currentIndex] = companies[listView.currentIndex].slice(0,-1) + levelsModel.get(listView1.currentIndex).name;
                            tx.executeSql('UPDATE player SET companies = "' + companies.join(',') + ',"' + " WHERE id = " + pId);
                            companiesModel.setProperty(listView.currentIndex, "level", levelsModel.get(listView1.currentIndex).name);
                            var total = [];
                            total.push(results.rows.item(0)["total"]);
                            if (results.rows.item(0)["conj_id"] !== -1) {
                                var xhr = new XMLHttpRequest();
                                xhr.onreadystatechange = function() {
                                    if (xhr.readyState === 4) {
                                        if (xhr.status === 200) {
                                            var json = JSON.parse(xhr.responseText);
                                            companies.slice(0,-1).forEach(function(item) {
                                                json["companies"][item.split('_')[1]].find(function(item2) {
                                                    if (item2.name === item.split('_')[0]) {
                                                        total.push(item2.profit[item.split('_')[2]]*json["conjectures"][results.rows.item(0)['conj_id']][item.split('_')[1]]);
                                                    }
                                                });
                                            });
                                        }
                                    }
                                }
                                xhr.open("GET", "data.json", false);
                                xhr.send();
                                tx.executeSql("UPDATE player SET total = " + total.reduce(function(a,b) {return a+b}) + " WHERE id = " + pId);

                        }
                    }

                    });
                }
            }
        }
        model: levelsModel
    }
}
