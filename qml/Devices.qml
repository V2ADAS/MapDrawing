// Copyright (C) 2013 BlackBerry Limited. All rights reserved.
// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

pragma ComponentBehavior: Bound
import QtCore
import QtQuick

Rectangle {
    id: devicesPage

    property bool deviceState: blueMan.state
    signal showServices

    color: "black"

    function toggleDiscovery() {
        if (!blueMan.state) {
            blueMan.startDeviceDiscovery()
            // if startDeviceDiscovery() failed blueMan.state is not set
            if (blueMan.state) {
                info.dialogText = "Searching..."
                info.visible = true
            }
        } else {
            blueMan.stopDeviceDiscovery()
        }
    }

    onDeviceStateChanged: {
        if (!blueMan.state)
            info.visible = false
    }

    LargeLabel {

        id: header

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        font.pixelSize: fontSizeLarge

        text: {
            if (blueMan.state)
                return "Discovering"

            if (blueMan.devicesList.length > 0)
                return "Select a device"

            return "Start Discovery"
        }
    }

    Dialog {
        id: info
        anchors.centerIn: parent
        visible: false
    }

    ListView {
        id: theListView
        width: parent.width
        clip: true

        anchors {
            top: header.bottom
            bottom: searchButton.top

            margins: 10
        }

        model: blueMan.devicesList


        delegate: Rectangle {
            required property var modelData
            id: box
            height: 100
            width: theListView.width
            color: "black"
            border.width: 2
            border.color: "white"
            radius: 5

            Label {
                anchors.fill: parent
                text: box.modelData.a
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    blueMan.scanServices(box.modelData.deviceAddress)
                    showServices()
                }
            }

            Label {
                id: deviceName
                textContent: box.modelData.deviceName
                anchors.top: parent.top
                anchors.topMargin: 5

                color: colorBright
            }

            Label {
                id: deviceAddress
                textContent: box.modelData.deviceAddress
                font.pointSize: deviceName.font.pointSize * 0.7
                anchors.bottom: box.bottom
                anchors.bottomMargin: 5

                color: colorBright
            }
        }
    }

    //! [permission-object]
    BluetoothPermission {
        id: permission
        communicationModes: BluetoothPermission.Access
        onStatusChanged: {
            if (permission.status === Qt.PermissionStatus.Denied)
                blueMan.update = "Bluetooth permission required"
            else if (permission.status === Qt.PermissionStatus.Granted)
                devicesPage.toggleDiscovery()
        }
    }
    //! [permission-object]

    FeatureButton {
        id: searchButton
        anchors.bottom: parent.bottom
        width: parent.width
        height: (parent.height / 6)
        text: blueMan.update
        //! [permission-request]
        onClicked: {
            if (permission.status === Qt.PermissionStatus.Undetermined)
                permission.request()
            else if (permission.status === Qt.PermissionStatus.Granted)
                devicesPage.toggleDiscovery()
        }
        //! [permission-request]
    }
}
