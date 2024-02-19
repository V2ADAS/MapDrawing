TEMPLATE = app
TARGET = automotive
QT += core qml quick quickcontrols2 network

SOURCES += \
    automotive.cpp \
    drawingman.cpp \
    networkman.cpp \

win32 {
    LIBS += -liphlpapi
}

RESOURCES += \
    icons/icons.qrc \
    imagine-assets/imagine-assets.qrc \
    qml/qml.qrc \
    qtquickcontrols2.conf

target.path = $$[QT_INSTALL_EXAMPLES]/quickcontrols/imagine/automotive
INSTALLS += target

HEADERS += \
    drawingman.h \
    networkman.h \
