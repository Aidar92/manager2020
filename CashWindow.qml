import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0

Item {
    id: cashWindow
    width: 640
    height: 480
    Image {
        id: logo
        anchors.bottomMargin: parent.height*0.8
        anchors.fill: parent
        source: "images/buttons/profit2.png"
    }

    Component.onDestruction: {
        if (pId != 0) {
            var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
            db.transaction(function(tx) {
                if (checkBox.checked) tx.executeSql("UPDATE player SET total = total * 0.5 WHERE id = " + pId);
                else if (checkBox1.checked) tx.executeSql("UPDATE player SET total = total * 1.5 WHERE id = " + pId);
            });
            pId = 0;
        }
    }

    Component.onCompleted: { 
        if (pId != 0) {
            var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
            db.transaction(function(tx) {
                var playerData = tx.executeSql("SELECT * FROM player WHERE id = " + pId).rows.item(0);
                var companies = playerData["companies"].split(',').slice(0,-1);
                nameField.text = playerData["name"];
                figure.source = playerData["figure"];
                profitText.text = playerData["total"];
                superprofit.text = playerData["total"] / 2;
                var xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            if (playerData["conj_id"] !== -1) conj.source = JSON.parse(xhr.responseText)["conjectures"][playerData["conj_id"]].image;
                            companies.forEach(function(item, i, companies) {
                                companiesModel.append({name: item.split('_')[0], level: item.split('_')[2].toString(), colorCode: item.split('_')[1], profit: JSON.parse(xhr.responseText)["companies"][item.split('_')[1]][i].profit[item.split('_')[2]]*JSON.parse(xhr.responseText)["conjectures"][playerData["conj_id"]][item.split('_')[1]]});
                            });
                        }
                    }
                }
                xhr.open("GET", "data.json", false);
                xhr.send();
            });
        }
    }

    Image {
        id: conj
        y: parent.height*0.8
        height: parent.height*0.2
        anchors.rightMargin: parent.width*0.1
        anchors.leftMargin: parent.width*0.1
        anchors.right: parent.right
        anchors.left: parent.left
    }

    Label {
        id: nameField
        width: 482
        anchors.topMargin: parent.height*0.21
        fontSizeMode: Text.Fit
        anchors.rightMargin: parent.width*0.2
        anchors.leftMargin: parent.width*0.05
        anchors.bottomMargin: parent.height*0.7
        anchors.fill: parent
    }

    Image {
        id: figure
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.82
        anchors.bottomMargin: parent.height*0.7
        anchors.topMargin: parent.height*0.21
        anchors.fill: parent
    }
    ListModel {
        id: companiesModel
    }
    ListView {
        id: listView
        spacing: parent.height*0.05
        anchors.rightMargin: parent.width*0.05
        clip: true
        anchors.leftMargin: parent.width*0.05
        anchors.bottomMargin: parent.height*0.4
        anchors.topMargin: parent.height*0.31
        anchors.fill: parent
        delegate: Item {
            width: listView.width
            height: listView.height*0.2
            Row {
                spacing: listView.width*0.1
                Rectangle {
                    color: colorCode
                    id: textBackground
                    width: listView.width*0.2
                    height: listView.height*0.2
                    Text {
                        text: name
                        fontSizeMode: Text.VerticalFit

                    }
                }
                Text {
                    text: level
                    fontSizeMode: Text.VerticalFit
                }
                Text {
                    text: profit
                    fontSizeMode: Text.VerticalFit
                }


            }
        }
        model: companiesModel
    }



        ExclusiveGroup { id: exclGroup}
        CheckBox {
            id: checkBox
            anchors.rightMargin: parent.width*0.8
            anchors.leftMargin: parent.width*0.05
            anchors.bottomMargin: parent.height*0.35
            anchors.topMargin: parent.height*0.62
            anchors.fill: parent
            exclusiveGroup: exclGroup
            onCheckedChanged: {
                if (checked) { profitText.text = parseInt(profitText.text)*0.5 };
            }
        }

        CheckBox {
            id: checkBox1
            anchors.rightMargin: parent.width*0.55
            anchors.bottomMargin: parent.height*0.35
            anchors.topMargin: parent.height*0.62
            anchors.leftMargin: parent.width*0.3
            anchors.fill: parent
            exclusiveGroup: exclGroup
            onCheckedChanged: {
                var profit = parseInt(profitText.text);
                if (checked) { profit*=1.5 }
                else { profit/=1.5 }
                console.log(profit)

            }
        }


    Text {
        id: text1
        text: qsTr("ИТОГО:")
        anchors.rightMargin: parent.width*0.7
        anchors.leftMargin: parent.width*0.05
        anchors.bottomMargin: parent.height*0.3
        anchors.topMargin: parent.height*0.67
        anchors.fill: parent
        fontSizeMode: Text.VerticalFit
    }

    Text {
        id: profitText
        fontSizeMode: Text.VerticalFit
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.5
        anchors.bottomMargin: parent.height*0.26
        anchors.topMargin: parent.height*0.67
        anchors.fill: parent
    }

    Text {
        id: text3
        text: qsTr("Сверхприбыль")
        fontSizeMode: Text.VerticalFit
        anchors.rightMargin: parent.width*0.35
        anchors.leftMargin: parent.width*0.2
        anchors.bottomMargin: parent.height*0.23
        anchors.topMargin: parent.height*0.75
        anchors.fill: parent

    }

    Text {
        id: superprofit
        fontSizeMode: Text.VerticalFit
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.7
        anchors.bottomMargin: parent.height*0.21
        anchors.topMargin: parent.height*0.75
        anchors.fill: parent
    }
}
