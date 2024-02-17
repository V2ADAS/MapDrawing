// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Imagine
import QtQuick.Window

ApplicationWindow {
    id: window
    width: 1280
    height: 720
    visible: true
    title: "Qt Quick Controls - Imagine Style Example: Automotive"

    readonly property color colorGlow: "#1d6d64"
    readonly property color colorWarning: "#d5232f"
    readonly property color colorMain: "#6affcd"
    readonly property color colorBright: "#ffffff"
    readonly property color colorLightGrey: "#ccc"
    readonly property color colorGrey: "#888"
    readonly property color colorDarkGrey: "#333"

    readonly property int fontSizeExtraSmall: Qt.application.font.pixelSize * 0.8
    readonly property int fontSizeMedium: Qt.application.font.pixelSize * 1.5
    readonly property int fontSizeLarge: Qt.application.font.pixelSize * 2
    readonly property int fontSizeExtraLarge: Qt.application.font.pixelSize * 5

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 2
    }

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    Frame {
        id: frame
        anchors.fill: parent
        anchors.margins: 90

        Label {
            text: qsTr("NetMan Message: ") + netMan.currentMessage
        }

        Button {
            text: "Toggle Receiver Panel"
            anchors {
                top: parent.top
                right: parent.right
            }

            onClicked: receiverPanel.visible = !receiverPanel.visible
        }

        RowLayout {
            id: mainRowLayout
            anchors.fill: parent
            anchors.margins: 40
            spacing: 36

            Container {
                id: leftTabBar

                currentIndex: 1

                width: parent.width / 10 * 2
                // Layout.fillWidth: true
                Layout.fillHeight: true

                // Layout.horizontalStretchFactor: 2
                ButtonGroup {
                    id: radioGroup
                }

                contentItem: ColumnLayout {
                    id: columnLayout
                    spacing: 3

                    Repeater {
                        model: leftTabBar.contentModel
                    }
                }

                FeatureButton {
                    id: navigationFeatureButton
                    text: checked ? qsTr("Close Map") : qsTr("Open Map")
                    icon.name: "navigation"
                    Layout.fillHeight: true
                    onClicked: {
                        checked ? drawingMan.runScript(
                                      ) : drawingMan.stopScript()
                    }
                }

                FeatureButton {
                    ButtonGroup.group: radioGroup
                    text: qsTr("Message")
                    icon.name: "message"
                    Layout.fillHeight: true
                    onClicked: {
                        leftTabBar.setCurrentIndex(0)
                    }
                }

                FeatureButton {
                    ButtonGroup.group: radioGroup
                    text: qsTr("Command")
                    icon.name: "command"
                    Layout.fillHeight: true
                    onClicked: {
                        leftTabBar.setCurrentIndex(0)
                    }

                    enabled: false
                }

                FeatureButton {
                    ButtonGroup.group: radioGroup
                    text: qsTr("Connectivity")
                    icon.name: "settings"
                    Layout.fillHeight: true
                    onClicked: {
                        leftTabBar.setCurrentIndex(1)
                    }
                }
            }

            Rectangle {
                color: colorMain
                implicitWidth: 1
                Layout.fillHeight: true
            }

            StackLayout {
                currentIndex: leftTabBar.currentIndex

                // Layout.fillWidth: true
                width: parent.width / 10 * 8
                Layout.fillHeight: true

                // Layout.horizontalStretchFactor: 8
                Controls {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                WifiConnection {}
            }

            Rectangle {
                color: colorMain
                implicitWidth: 1
                Layout.fillHeight: true
                visible: receiverPanel.visible
            }

            Rectangle {
                id: receiverPanel
                color: colorDarkGrey
                Layout.fillHeight: true
                implicitWidth: 350
                visible: false

                ReceiverPanel {}
            }
        }
    }
}
