import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.LocalStorage 2.0
import QtQuick.Dialogs 1.2

Item {
    id: companyWindow
    width: 640
    height: 480
    Image {
        id: logo
        x: 0
        y: 0
        width: parent.width
        height: parent.height*0.2
        source: "images/buttons/buyCompany2.png"
    }

    Component.onCompleted: {
        var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
        if (pId != 0) {

            db.transaction(function(tx) {
                var query = tx.executeSql("SELECT * FROM player WHERE id = " + pId);
                text1.text = query.rows.item(0).name;
                var results = query.rows.item(0)["companies"].split(',');
                tx.executeSql("UPDATE player SET total = 0 WHERE id=" + pId);
                var xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            results.slice(0,-1).forEach(function(item) {
                                JSON.parse(xhr.responseText)["companies"][item.split('_')[1]].forEach(function(item2) {
                                    if (item2.name === item.split('_')[0]) {
                                        playerCompaniesModel.append({image: item2.image});
                                    }
                                });
                            });
                        }
                    }
                }
                xhr.open("GET", "data.json", false);
                xhr.send();
            });

        }

        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    var companies = JSON.parse(xhr.responseText)["companies"];
                    for (var i = 0; i < companies["yellow"].length; i++) {
                        yellowCompaniesModel.append({image: companies["yellow"][i].image})
                    }
                    for (var i = 0; i < companies["orange"].length; i++) {
                        orangeCompaniesModel.append({image: companies["orange"][i].image})
                    }
                    for (var i = 0; i < companies["pink"].length; i++) {
                        pinkCompaniesModel.append({image: companies["pink"][i].image})
                    }
                    for (var i = 0; i < companies["red"].length; i++) {
                        redCompaniesModel.append({image: companies["red"][i].image})
                    }
                    for (var i = 0; i < companies["lightgreen"].length; i++) {
                        lightGreenCompaniesModel.append({image: companies["lightgreen"][i].image})
                    }
                    for (var i = 0; i < companies["green"].length; i++) {
                        greenCompaniesModel.append({image: companies["green"][i].image})
                    }
                    for (var i = 0; i < companies["blue"].length; i++) {
                        blueCompaniesModel.append({image: companies["blue"][i].image})
                    }
                    for (var i = 0; i < companies["purple"].length; i++) {
                        purpleCompaniesModel.append({image: companies["purple"][i].image})
                    }
                }
            }
        }
        xhr.open("GET", "data.json", false);
        xhr.send();
    }
    ListModel {
        id: yellowCompaniesModel
    }
    ListModel {
        id: orangeCompaniesModel
    }
    ListModel {
        id: pinkCompaniesModel
    }
    ListModel {
        id: redCompaniesModel
    }
    ListModel {
        id: lightGreenCompaniesModel
    }
    ListModel {
        id: greenCompaniesModel
    }
    ListModel {
        id: blueCompaniesModel
    }
    ListModel {
        id: purpleCompaniesModel
    }

    SwipeView {
        id: view
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        anchors.bottomMargin: parent.height*0.37
        anchors.topMargin: parent.height*0.21
        anchors.fill: parent
        currentIndex: indicator.currentIndex
        Item {
            width: view.width
            height: view.height
            ListView {
                id: yellowView
                width: parent.width
                height: parent.height
                orientation: ListView.Horizontal
                spacing: width*0.04
                flickableDirection: Flickable.VerticalFlick
                clip: true
                delegate: Image {
                        width:  yellowView.width*0.3
                        height: yellowView.height*0.87
                        source: image
                        z: 0
                        MouseArea {
                            z: 1
                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                yellowView.currentIndex = index;
                                var xhr = new XMLHttpRequest();
                                xhr.onreadystatechange = function() {
                                    if (xhr.readyState === 4) {
                                        if (xhr.status === 200) {
                                            var results = JSON.parse(xhr.responseText)["companies"];
                                            buyCompanyDialog.text = "Вы уверены, что хотите приобрести " + results["yellow"][yellowView.currentIndex].name + "?";
                                        }
                                    }
                                }
                                xhr.open("GET", "data.json", false);
                                xhr.send();

                                buyCompanyDialog.open();
                            }
                        }                    
                }
                model: yellowCompaniesModel
            }
        }
        Item {
            width: view.width
            height: view.height
            ListView {
                id: orangeView
                width: parent.width
                height: parent.height
                orientation: ListView.Horizontal
                spacing: width*0.04
                flickableDirection: Flickable.VerticalFlick
                clip: true
                delegate: Image {
                        width:  orangeView.width*0.3
                        height: orangeView.height*0.87
                        source: image
                        z: 0
                        MouseArea {
                            z: 1

                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                orangeView.currentIndex = index;
                                var xhr = new XMLHttpRequest();
                                xhr.onreadystatechange = function() {
                                    if (xhr.readyState === 4) {
                                        if (xhr.status === 200) {
                                            var results = JSON.parse(xhr.responseText)["companies"];
                                            buyCompanyDialog.text = "Вы уверены, что хотите приобрести " + results["orange"][orangeView.currentIndex].name + "?";
                                        }
                                    }
                                }
                                xhr.open("GET", "data.json", false);
                                xhr.send();

                                buyCompanyDialog.open();
                            }
                        }
                }
                model: orangeCompaniesModel
            }
        }
        Item {
            width: view.width
            height: view.height
            ListView {
                id: pinkView
                width: parent.width
                height: parent.height
                orientation: ListView.Horizontal
                spacing: width*0.04
                flickableDirection: Flickable.VerticalFlick
                clip: true
                delegate: Image {
                        width:  pinkView.width*0.3
                        height: pinkView.height*0.87
                        source: image
                        z: 0
                        MouseArea {
                            z: 1

                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                pinkView.currentIndex = index;
                                var xhr = new XMLHttpRequest();
                                xhr.onreadystatechange = function() {
                                    if (xhr.readyState === 4) {
                                        if (xhr.status === 200) {
                                            var results = JSON.parse(xhr.responseText)["companies"];
                                            buyCompanyDialog.text = "Вы уверены, что хотите приобрести " + results["pink"][pinkView.currentIndex].name + "?";
                                        }
                                    }
                                }
                                xhr.open("GET", "data.json", false);
                                xhr.send();

                                buyCompanyDialog.open();
                            }
                        }
                }
                model: pinkCompaniesModel
            }
        }
        Item {
            width: view.width
            height: view.height
            ListView {
                id: redView
                width: parent.width
                height: parent.height
                orientation: ListView.Horizontal
                spacing: width*0.04
                flickableDirection: Flickable.VerticalFlick
                clip: true
                delegate: Image {
                        width:  redView.width*0.3
                        height: redView.height*0.87
                        source: image
                        z: 0
                        MouseArea {
                            z: 1

                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                redView.currentIndex = index;
                                var xhr = new XMLHttpRequest();
                                xhr.onreadystatechange = function() {
                                    if (xhr.readyState === 4) {
                                        if (xhr.status === 200) {
                                            var results = JSON.parse(xhr.responseText)["companies"];
                                            buyCompanyDialog.text = "Вы уверены, что хотите приобрести " + results["red"][redView.currentIndex].name + "?";
                                        }
                                    }
                                }
                                xhr.open("GET", "data.json", false);
                                xhr.send();

                                buyCompanyDialog.open();
                            }
                        }
                }
                model: redCompaniesModel
            }
        }
        Item {
            width: view.width
            height: view.height
            ListView {
                id: lightGreenView
                width: parent.width
                height: parent.height
                orientation: ListView.Horizontal
                spacing: width*0.04
                flickableDirection: Flickable.VerticalFlick
                clip: true
                delegate: Image {
                        width:  lightGreenView.width*0.3
                        height: lightGreenView.height*0.87
                        source: image
                        z: 0
                        MouseArea {
                            z: 1

                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                lightGreenView.currentIndex = index;
                                var xhr = new XMLHttpRequest();
                                xhr.onreadystatechange = function() {
                                    if (xhr.readyState === 4) {
                                        if (xhr.status === 200) {
                                            var results = JSON.parse(xhr.responseText)["companies"];
                                            buyCompanyDialog.text = "Вы уверены, что хотите приобрести " + results["lightgreen"][lightGreenView.currentIndex].name + "?";
                                        }
                                    }
                                }
                                xhr.open("GET", "data.json", false);
                                xhr.send();

                                buyCompanyDialog.open();
                            }
                        }
                }
                model: lightGreenCompaniesModel
            }
        }
        Item {
            width: view.width
            height: view.height
            ListView {
                id: greenView
                width: parent.width
                height: parent.height
                orientation: ListView.Horizontal
                spacing: width*0.04
                flickableDirection: Flickable.VerticalFlick
                clip: true
                delegate: Image {
                        width:  greenView.width*0.3
                        height: greenView.height*0.87
                        source: image
                        z: 0
                        MouseArea {
                            z: 1

                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                greenView.currentIndex = index;
                                var xhr = new XMLHttpRequest();
                                xhr.onreadystatechange = function() {
                                    if (xhr.readyState === 4) {
                                        var results = JSON.parse(xhr.responseText)["companies"];
                                        buyCompanyDialog.text = "Вы уверены, что хотите приобрести " + results["green"][greenView.currentIndex].name + "?";
                                    }
                                }
                                xhr.open("GET", "data.json", false);
                                xhr.send();

                                buyCompanyDialog.open();
                            }
                        }
                }
                model: greenCompaniesModel
            }
        }
        Item {
            width: view.width
            height: view.height
            ListView {
                id: blueView
                width: parent.width
                height: parent.height
                orientation: ListView.Horizontal
                spacing: width*0.04
                flickableDirection: Flickable.VerticalFlick
                clip: true
                delegate: Image {
                        width:  blueView.width*0.3
                        height: blueView.height*0.87
                        source: image
                        z: 0
                        MouseArea {
                            z: 1

                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                blueView.currentIndex = index;
                                var xhr = new XMLHttpRequest();
                                xhr.onreadystatechange = function() {
                                    if (xhr.readyState === 4) {
                                        if (xhr.status === 200) {
                                            var results = JSON.parse(xhr.responseText)["companies"];
                                            buyCompanyDialog.text = "Вы уверены, что хотите приобрести " + results["blue"][blueView.currentIndex].name + "?";
                                        }
                                    }
                                }
                                xhr.open("GET", "data.json", false);
                                xhr.send();

                                buyCompanyDialog.open();
                            }
                        }
                }
                model: blueCompaniesModel
            }
        }
        Item {
            width: view.width
            height: view.height
            ListView {
                id: purpleView
                width: parent.width
                height: parent.height
                orientation: ListView.Horizontal
                spacing: width*0.04
                flickableDirection: Flickable.VerticalFlick
                clip: true
                delegate: Image {
                        width:  purpleView.width*0.3
                        height: purpleView.height*0.87
                        source: image
                        z: 0
                        MouseArea {
                            z: 1

                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                purpleView.currentIndex = index;
                                var xhr = new XMLHttpRequest();
                                xhr.onreadystatechange = function() {
                                    if (xhr.readyState === 4) {
                                        if (xhr.status === 200) {
                                            var results = JSON.parse(xhr.responseText)["companies"];
                                            buyCompanyDialog.text = "Вы уверены, что хотите приобрести " + results["purple"][purpleView.currentIndex].name + "?";
                                        }
                                    }
                                }
                                xhr.open("GET", "data.json", false);
                                xhr.send();

                                buyCompanyDialog.open();
                            }
                        }
                }
                model: purpleCompaniesModel
            }
        }
    }
    PageIndicator {
        id: indicator
        count: view.count
        currentIndex: view.currentIndex
        anchors.bottom: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        interactive: true
        delegate: Rectangle {
            implicitWidth: 18
            implicitHeight: 18
            radius: width
            color: "#21be2b"
            opacity: index === view.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

            Behavior on opacity {
                OpacityAnimator {
                    duration: 100
                }
            }
        }


    }
    MessageDialog {
        id: buyCompanyDialog
        title: "Покупка предприятия"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            playerCompaniesModel.clear();
            if (pId != 0) {
                var category = "";
                switch (view.currentIndex) {
                case 0:
                    category = "yellow"
                    break
                case 1:
                    category = "orange"
                    break
                case 2:
                    category = "pink"
                    break
                case 3:
                    category = "red"
                    break
                case 4:
                    category = "lightgreen"
                    break
                case 5:
                    category = "green"
                    break
                case 6:
                    category = "blue"
                    break
                case 7:
                    category = "purple"
                    break
                }

                var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
                db.transaction(function(tx) {
                    // companies structure - name_category_level
                    tx.executeSql("UPDATE player SET companies = companies || '"+ buyCompanyDialog.text.split("приобрести ")[1].slice(0,-1) + "_" + category + "_0,' WHERE id="+ pId);
                    if (category === "yellow") yellowCompaniesModel.remove(yellowView.currentIndex);
                    if (category === "orange") orangeCompaniesModel.remove(orangeView.currentIndex);
                    if (category === "pink") pinkCompaniesModel.remove(pinkView.currentIndex);
                    if (category === "red") redCompaniesModel.remove(redView.currentIndex);
                    if (category === "lightgreen") lightGreenCompaniesModel.remove(lightGreenView.currentIndex);
                    if (category === "green") greenCompaniesModel.remove(greenView.currentIndex);
                    if (category === "blue") blueCompaniesModel.remove(blueView.currentIndex);
                    if (category === "purple") purpleCompaniesModel.remove(purpleView.currentIndex);

                    var query = tx.executeSql('SELECT * FROM player WHERE id='+pId);
                    var results = query.rows.item(0)["companies"].split(',');
                    var total = [];
                    total.push(query.rows.item(0)["total"]);
                    if (query.rows.item(0)["conj_id"] !== -1) {
                        var xhr = new XMLHttpRequest();
                        xhr.onreadystatechange = function() {
                            if (xhr.readyState === 4) {
                                if (xhr.status === 200) {
                                    var json = JSON.parse(xhr.responseText);
                                    results.slice(0,-1).forEach(function(item) {
                                        json["companies"][item.split('_')[1]].find(function(item2) {
                                            if (item2.name === item.split('_')[0]) {
                                                total.push(item2.profit[item.split('_')[2]]*json["conjectures"][query.rows.item(0)['conj_id']][item.split('_')[1]]);
                                                playerCompaniesModel.append({image: item2.image});
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
                });
            }
        }
    }
    ListModel {
        id: playersModel
    }

    MessageDialog {
        id: sellForBankDialog
        text: "Вы уверены, что хотите продать данное предприятие?"
        standardButtons: StandardButton.Yes | StandardButton.No
        title: "Продать банку"
    }
    Dialog {
        id: sellForPlayerDialog
        width: parent.width*0.5
        height: parent.height*0.3
        visible: false
        title: "Продать игроку"
        standardButtons: StandardButton.Yes | StandardButton.No
        Component.onCompleted: {
            playersModel.clear();
            playersModel.append({text: "Выберите игрока"});
            var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
            db.transaction(function(tx) {
                var players = tx.executeSql("SELECT * FROM player WHERE id !=" + pId);
                for (var i = 0; i < players.rows.length; i++) {
                    playersModel.append({text: players.rows.item(i).name});
                }
            });
        }

        ComboBox {
            id: playersChoise
            width: parent.width
            height: parent.height
            model: playersModel
        }
        onYes: {
            var db = LocalStorage.openDatabaseSync("GameDB", "1.0", "Database for manager2020 game", 100000);
            db.transaction(function(tx)  {
                var byuingPlayer = tx.executeSql("SELECT * FROM player WHERE name = '" + playersModel.get(playersChoise.currentIndex).text + "'").rows.item(0)["companies"].split(",").slice(0,-1);
                var sellingPlayer = tx.executeSql("SELECT * FROM player WHERE id = " + pId).rows.item(0)["companies"].split(',').slice(0,-1);
                console.log(byuingPlayer);
                console.log(sellingPlayer);
                var xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            var companies = JSON.parse(xhr.responseText)["companies"];
                            var sellingCompany = companies.find(function(item, i, sellingPlayer) {
                               return sellingPlayer === companies[item.split['_'][1]]
                            });
                        }
                    }
                }
                xhr.open("GET", "data.json", false);
                xhr.send();
            });
        }
    }

    Popup {
        id: popup
        x: parent.width*0.2
        y: parent.height*0.2
        width: parent.width*0.6
        height: parent.height*0.6
        modal: true
        focus: true
        Button {
            x: 0
            y: 0
            width: parent.width
            height: parent.height*0.45
            text: "Продать игроку"
            onClicked: {
                sellForPlayerDialog.open();
            }
        }
        Button {
            x: 0
            y: parent.height*0.5
            width: parent.width
            height: parent.height*0.45
            text: "Продать банку"
            onClicked: {
                sellForBankDialog.open();
            }
        }
        closePolicy: Popup.CloseOnPressOutside

    }

    ListView {
        id: listView
        anchors.rightMargin: parent.width*0.05
        anchors.leftMargin: parent.width*0.05
        anchors.bottomMargin: parent.height*0.02
        anchors.topMargin: parent.height*0.73
        anchors.fill: parent
        spacing: width*0.1
        orientation: ListView.Horizontal
        flickableDirection: Flickable.HorizontalFlick
        delegate: Item {
            id: playerCompany
            width: listView.width*0.2
            height: listView.height
            Image {
                width: playerCompany.width
                height: playerCompany.height
                source: image
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listView.currentIndex = index;
                    popup.open();

                }
            }
        }
        model: playerCompaniesModel
    }

    ListModel {
        id: playerCompaniesModel

    }

    Text {
        id: text1
        text: qsTr("")
        anchors.bottomMargin: parent.height*0.28
        anchors.leftMargin: parent.width*0.05
        anchors.rightMargin: parent.width*0.6
        anchors.topMargin: parent.height*0.64
        anchors.fill: parent
        fontSizeMode: Text.VerticalFit
    }


}
