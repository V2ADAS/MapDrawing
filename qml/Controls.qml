import QtQuick
import QtQuick.Layouts

Item {
    ColumnLayout {
        id: bounding

        anchors.fill: parent

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: wheel.rotation
        }

        Rectangle {
            id: wheel

            Layout.alignment: Qt.AlignHCenter
            height: 150
            width: height
            radius: height/2

            color.a: 0
            border.color: colorMain
            border.width: 3

            Rectangle {
                anchors.centerIn: parent

                height: parent.height / 3
                width: height
                radius: height/2

                color.a: 0
                border.color: colorMain
                border.width: 2
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 5
                height: parent.height / 3

                color.a: 0
                border.color: colorMain
                border.width: 2
            }
        }

        RowLayout {

            Layout.fillWidth: true
            spacing: 15
            Layout.margins: 20

            FeatureButton {
                id: brakesButton
                Layout.fillWidth: true
                Label {
                    anchors.fill: parent
                    text: qsTr("Brakes")
                }

                onCheckedChanged: {
                    checked ? brakesEmitter.start() : brakesEmitter.stop()
                }

                Timer {
                    id: brakesEmitter
                    interval: 50
                    running: false
                    repeat: true

                    onTriggered: {
                        netMan.sendMessage("Brakes!!")
                    }
                }
            }

            FeatureButton {
                id: forwardButton
                Layout.fillWidth: true
                Label {
                    anchors.fill: parent
                    text: qsTr("Forward")
                }

                onCheckedChanged: {
                    checked ? forwardEmitter.start() : forwardEmitter.stop()
                }

                Timer {
                    id: forwardEmitter
                    interval: 50
                    running: false
                    repeat: true

                    onTriggered: {
                        netMan.sendMessage("Forward!!")
                    }
                }
            }

        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Right) {
            if (wheel.rotation < 600) {
                wheel.rotation += 10
                netMan.sendMessage("Wheel: " + wheel.rotation)
            }
        }

        if (event.key === Qt.Key_Left) {
            if (wheel.rotation > -600) {
                wheel.rotation -= 10
                netMan.sendMessage("Wheel: " + wheel.rotation)
            }
        }

        if (event.key === Qt.Key_Up) {
            forwardButton.checked = true
            forwardButton.checkableChanged()
        }

        if (event.key === Qt.Key_Down) {
            brakesButton.checked = true
            brakesButton.checkableChanged()
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Up) {
            forwardButton.checked = false
            forwardButton.checkableChanged()
        }

        if (event.key === Qt.Key_Down) {
            brakesButton.checked = false
            brakesButton.checkableChanged()
        }
    }
}
