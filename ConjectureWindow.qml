import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0

Item {
    id: conjWindow
    width: 640
    height: 480
    Image {
        id: logo
        x: 0
        y: 0
        width: parent.width
        height: parent.height*0.2
        source: "images/buttons/conj2.png"
    }

    Component.onCompleted: {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                var result = JSON.parse(xhr.responseText)["conjectures"];
                for (var i = 0; i < result.length; i++) {
                    conjModel.append({image: result[i]["image"]})
                }
                var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
                db.transaction(function(tx) {
                    var results = tx.executeSql("SELECT * FROM player");
                    var conj_id = results.rows.item(0).conj_id;
                    if (conj_id !== -1) {
                        image1.source = result[conj_id]["image"];
                    }
                });

            }
        }

        xhr.open("GET", "data.json", false);
        xhr.send();

    }

    Image {
        id: image1
        y: parent.height*0.8
        height: parent.height*0.2
        anchors.rightMargin: parent.width*0.2
        anchors.leftMargin: parent.width*0.2
        anchors.right: parent.right
        anchors.left: parent.left
    }
    ListModel {
        id: conjModel
    }

    GridView {
        id: gridView
        contentWidth: gridView.width*0.5
        contentHeight: gridView.height*0.5
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        anchors.bottomMargin: parent.height*0.21
        anchors.topMargin: parent.height*0.21
        anchors.fill: parent
        snapMode: GridView.SnapToRow
        clip: true
        delegate: Item {

            MouseArea {
                anchors.fill: parent
                onClicked: gridView.currentIndex = -1
            }

            Image {
                width: gridView.cellWidth
                height: gridView.cellHeight
                source: image
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        gridView.currentIndex = index;
                        image1.source = conjModel.get([gridView.currentIndex]).image;
                        var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
                        var xhr = new XMLHttpRequest();

                        db.transaction(function(tx) {
                            tx.executeSql('UPDATE player SET conj_id = ' + gridView.currentIndex);
                            var results = tx.executeSql("SELECT * FROM player");
                            xhr.onreadystatechange = function() {
                                if (xhr.readyState === 4) {
                                    if (xhr.status === 200) {
                                        var json = JSON.parse(xhr.responseText);
                                        for (var j = 0; j < results.rows.length; j++) {
                                            var total = [];
                                            var companies = results.rows.item(j)["companies"].split(',');
                                            if (companies.length > 0) {
                                                var index = j+1;
                                                companies.slice(0,-1).forEach(function(item) {
                                                    json["companies"][item.split('_')[1]].find(function(item2) {
                                                        if (item2.name === item.split('_')[0]) {
                                                            total.push(item2.profit[item.split('_')[2]]*json["conjectures"][gridView.currentIndex][item.split('_')[1]]);
                                                        }
                                                    });
                                                });
                                                tx.executeSql('UPDATE player SET total = ' + total.reduce(function(a,b) {return a+b}).toString() + ' WHERE id = ' + index.toString());

                                            }

                                        }
                                    }
                                }
                            }

                        xhr.open("GET", "data.json", false);
                        xhr.send();
                            });
                    }
                }
            }
        }
        cellWidth: gridView.width / 2
        model: conjModel
        cellHeight: gridView.height / 2
    }
}
