// CarMap.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtPositioning 5.15

//import QtLocation 5.15
ApplicationWindow {
    visible: true
    width: 800
    height: 800
    title: "Car Map App"

    Rectangle {
        width: 800
        height: 800

        Component.onCompleted: {

            // Initialize Bluetooth communication and connect to the device
            // Implement your Bluetooth communication logic here
        }

        Connections {
            target: bluetoothController // Assuming you have a Bluetooth controller object

            onPositionUpdate: {
                // Update the car's position based on Bluetooth data
                carModel.updatePosition(latitude, longitude)
            }
        }

        CarMapModel {
            id: carModel
        }
    }
}
