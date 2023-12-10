#ifndef CAR_H
#define CAR_H

#include <QObject>
#include <QQmlEngine>

class Car : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    Car();

Q_SIGNALS:
    void newReading(int xAbs, int yAbs);

public slots:
    void receivedReading(int mouseX, int mouseY);
};

#endif // CAR_H
