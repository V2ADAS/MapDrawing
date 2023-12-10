// CarMapModel.qml

import QtQuick 2.15
import QtPositioning 5.15

Canvas {
    property variant positions: []

    function updatePosition(latitude, longitude) {
        // Update the car's position in the model
        positions.push({ latitude: latitude, longitude: longitude });

        // Limit the number of stored positions for performance reasons
        if (positions.length > 100) {
            positions.shift(); // remove the oldest position
        }
    }

    anchors.fill: parent

    readonly property color obstacleColor: "orange"
    readonly property int obstacleSideLength: 4
    readonly property color carColor: "blue"

    property int xReading: -100
    property int yReading: -100

    onPaint: {
        var ctx = getContext('2d')

        label.text = `Painting at: (${xReading}, ${yReading})`

        ctx.fillStyle = obstacleColor
        ctx.fillRect(xReading, yReading, obstacleSideLength, obstacleSideLength)
    }

    CarModel {
        carColor: carColor
    }

    // -> This is to simulate input only
    MouseArea {
        id: area
        anchors.fill: parent

        onPressed: {
            parent.xReading = mouseX
            parent.yReading = mouseY
            parent.requestPaint()
        }
    }
    // <-
}
