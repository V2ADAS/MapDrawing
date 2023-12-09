// CarMapModel.qml

import QtQuick 2.15
import QtPositioning 5.15

QtObject {
    property variant positions: []

    function updatePosition(latitude, longitude) {
        // Update the car's position in the model
        positions.push({ latitude: latitude, longitude: longitude });

        // Limit the number of stored positions for performance reasons
        if (positions.length > 100) {
            positions.shift(); // remove the oldest position
        }
    }
}
