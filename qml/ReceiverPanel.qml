import QtQuick
import QtQuick.Layouts

ColumnLayout {
    anchors.fill: parent
    spacing: 16

    ListView {
        id: listView
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.margins: 15
        clip: true

        model: ListModel {
            ListElement { message: "Init" }
            // Add more ListElements or populate dynamically
        }

        delegate: Item {
            width: listView.width
            height: 50

            Rectangle {
                width: parent.width
                height: 50
                color: colorMain
                border.color: colorGlow

                Text {
                    anchors.centerIn: parent
                    text: model.message
                }
            }
        }

        Connections {
            target: netMan

            function onReadMessage(message) {
                listView.model.append({message: message})
            }
        }
    }

    FeatureButton {
        Layout.fillWidth: true
        text: qsTr("Delete")
        checkable: false

        onClicked: {
            listView.model.clear();
        }
    }
}
