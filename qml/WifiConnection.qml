import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    ColumnLayout {
        anchors.fill: parent

        Header {
            id: header
            Layout.fillWidth: true
            headerText: qsTr("Wifi Connections")
        }

        Label {
            font.pixelSize: 20
            text: qsTr("Current Ip: ") + netMan.getCurrentIp()
        }

        Label {
            font.pixelSize: 20
            text: qsTr("Gateway Ip: ") + netMan.getGatewayIp()
        }

        Switch {
            id: control
            text: qsTr("Listening")
            Layout.alignment: Qt.AlignHCenter
            onCheckedChanged: {
                checked ? netMan.openSocket(4000) : netMan.closeSocket();
            }

            checked: false

            indicator: Rectangle {
                implicitWidth: 48
                implicitHeight: 26
                x: control.leftPadding
                y: parent.height / 2 - height / 2
                radius: 13
                color: control.checked ? colorMain : colorBright
                border.color: control.checked ? colorMain : colorGrey

                Rectangle {
                    x: control.checked ? parent.width - width : 0
                    width: 26
                    height: 26
                    radius: 13
                    color: control.down ? colorLightGrey : colorBright
                    border.color: colorDarkGrey
                }
            }
        }
    }
}
