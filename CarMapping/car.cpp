#include "car.h"

Car::Car() {}

void Car::receivedReading(int mouseX, int mouseY)
{
    emit newReading(mouseX + 15, mouseY + 15);
}
