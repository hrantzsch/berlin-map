import QtQuick 2.3
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0

ApplicationWindow {
    id: window
    visible: true

    width: 800
    height: 600

    ListModel {
        id: players
        ListElement { name: "Patrick"; color: "red" }
        ListElement { name: "Hannes"; color: "green" }
    }

    function store(position, owner) {
        console.log(position, "now belongs to", owner.name);
    }

    function addFlag(position, color, _parent) {
        Qt.createQmlObject(
                    'import QtQuick 2.0;' +
                    'Rectangle {' +
                    'color: "' + color + '";' +
                    'x: ' + position[0] + ';' +
                    'y: ' + position[1] + ';' +
                    'width: 50; height: 50; radius: 25}',
                    _parent);
    }

    //    Component.onCompleted: {
    //        var db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);

    //        db.transaction(function(tx) {
    //            // Create the database if it doesn't already exist
    //            tx.executeSql('CREATE TABLE IF NOT EXISTS Greeting(salutation TEXT, salutee TEXT)');

    //            // Add (another) greeting row
    //            tx.executeSql('INSERT INTO Greeting VALUES(?, ?)', [ 'hello', 'world' ]);

    //            // Show all added greetings
    //            var rs = tx.executeSql('SELECT * FROM Greeting');

    //            var r = ""
    //            for(var i = 0; i < rs.rows.length; i++) {
    //                r += rs.rows.item(i).salutation + ", " + rs.rows.item(i).salutee + "\n"
    //            }
    //            console.log(r);
    //        }
    //        )
    //    }

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "berlin.svg"

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
                popup.positionX = mouseX;
                popup.positionY = mouseY;
                popup.open();
            }
        }
    }

    Popup {
        id: popup
        property int positionX
        property int positionY
        function position() { return [positionX, positionY]; }

        Column {
            anchors.fill: parent
            Text {
                text: "select new owner"
            }

            Row {
                ComboBox {
                    id: owner
                    textRole: "name"
                    model: players
                }
                Button {
                    text: "OK"
                    onClicked: {
                        var o = players.get(owner.currentIndex)
                        store(popup.position(), o);
                        addFlag(popup.position(), o.color, image);
                        popup.close();
                    }
                }
            }
        }
        x: 200
        y: 200
        width: 400
        height: 200
        modal: true
        focus: true
    }
}
