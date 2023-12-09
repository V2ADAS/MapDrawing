// CarPath.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15

ApplicationWindow {
    visible: true
    width: 800
    height: 800

    Rectangle {
        anchors.fill: parent
        color: "black"

        PathView {
            id: pathView
            anchors.fill: parent
            model: ListModel {
                ListElement {
                    angle: 0
                    distance: 0
                }
                ListElement {
                    angle: 45
                    distance: 100
                }
                ListElement {
                    angle: 90
                    distance: 200
                }
                ListElement {
                    angle: 135
                    distance: 100
                }
                ListElement {
                    angle: 180
                    distance: 0
                }
            }

            delegate: Item {
                width: 100
                height: 100

                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: model.angle
                    }
                }

                PathSvg {
                    path: "M50,50 L150,50"
                }
            }

            highlightRangeMode: PathView.StrictlyEnforceRange

            pathItemCount: pathView.model.count

            onCurrentIndexChanged: carAnimation.start()
        }

        Image {
            id: car
            source: "car.png"
            width: 50
            height: 50
            smooth: true
            visible: true

            NumberAnimation {
                id: carAnimation
                target: car
                property: "rotation"

                from: car.rotation
                to: pathView.model.get(pathView.currentIndex).angle
                duration: 500
                easing.type: Easing.OutQuad
            }

            onRotationChanged: {
                car.x = pathView.model.get(
                            pathView.currentIndex).distance * Math.cos(
                            rotation * Math.PI / 180) + pathView.width / 2 - car.width / 2
                car.y = pathView.model.get(
                            pathView.currentIndex).distance * Math.sin(
                            rotation * Math.PI / 180) + pathView.height / 2 - car.height / 2
            }

            // Set the initial position
            Component.onCompleted: {
                car.x = pathView.model.get(
                            pathView.currentIndex).distance * Math.cos(
                            rotation * Math.PI / 180) + pathView.width / 2 - car.width / 2
                car.y = pathView.model.get(
                            pathView.currentIndex).distance * Math.sin(
                            rotation * Math.PI / 180) + pathView.height / 2 - car.height / 2
            }
        }
    }
}
