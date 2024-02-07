#include "networkman.h"
#include <QHostAddress>

#ifdef Q_OS_WIN
#include <iphlpapi.h>
#elif defined(Q_OS_UNIX)
#include <arpa/inet.h>
#include <netinet/in.h>
#include <unistd.h>
#endif

NetworkMan::NetworkMan(QObject *parent) : QObject{parent} {
    currentMessage = "Init";
    connect(&wifiSocket, &QTcpSocket::readyRead, this, &NetworkMan::onReadyRead);
    connect(&wifiSocket, &QTcpSocket::connected, this, &NetworkMan::onConnected);
}

QString NetworkMan::getCurrentIp() {
    // Get the list of local IP addresses
    getWifiInterface();

    if (wifiInterface.isValid()) {
        QList<QNetworkAddressEntry> addresses = wifiInterface.addressEntries();
        if (!addresses.isEmpty()) {
            return addresses.constFirst().ip().toString();
        }
    }
    return "127.0.0.1";
}

QString NetworkMan::getGatewayIp() {
#ifdef Q_OS_WIN
    // Windows-specific code to retrieve the default gateway
    IP_ADAPTER_INFO AdapterInfo[16];
    DWORD dwBufLen = sizeof(AdapterInfo);
    DWORD dwStatus = GetAdaptersInfo(AdapterInfo, &dwBufLen);

    if (dwStatus != ERROR_SUCCESS) {
        qDebug() << "Error getting adapter information";
        return QString();
    }

    PIP_ADAPTER_INFO pAdapterInfo = AdapterInfo;
    while (pAdapterInfo) {
        IP_ADDR_STRING gateway = pAdapterInfo->GatewayList;
        if (gateway.IpAddress.String[0] != '\0') {
            return QString::fromUtf8(gateway.IpAddress.String);
        }
        pAdapterInfo = pAdapterInfo->Next;
    }
#elif defined(Q_OS_UNIX)
    // UNIX/Linux-specific code to retrieve the default gateway
    FILE *fp = popen("ip route show default", "r");
    if (fp) {
        char buffer[256];
        while (fgets(buffer, sizeof(buffer), fp) != nullptr) {
            char *pos = strstr(buffer, "via");
            if (pos != nullptr) {
                pos += 4; // Move past "via"
                QString gateway = QString::fromLatin1(pos).section(' ', 0, 0);
                pclose(fp);
                return gateway;
            }
        }
        pclose(fp);
    }
#endif

    qDebug() << "Unable to determine the access point IP address.";
    return QString();
}

void NetworkMan::openSocket(int port) {
    wifiSocket.bind(port);
    wifiSocket.connectToHost(getGatewayIp(), port);
}

void NetworkMan::closeSocket()
{
    wifiSocket.close();

    currentMessage = QString("Socket Closed");
    emit currentMessageChanged();
}

void NetworkMan::sendMessage(QString message)
{
    wifiSocket.write(message.toUtf8());
}

void NetworkMan::getWifiInterface() {
    // Get all network interfaces
    QList<QNetworkInterface> interfaces = QNetworkInterface::allInterfaces();

    // Loop through each interface
    for (int i = 0; i < interfaces.size(); ++i) {
        QNetworkInterface &interface = interfaces[i];

        // Check if it's a Wi-Fi interface
        if (interface.type() == QNetworkInterface::Wifi) {
            wifiInterface = interface;
            qDebug() << wifiInterface.name();
            return; // Exit loop if found
        }
    }

    wifiInterface = QNetworkInterface();
    return;
}

void NetworkMan::onReadyRead()
{
    emit readMessage(QString::fromUtf8(wifiSocket.readAll()));
}

void NetworkMan::onConnected()
{
    currentMessage = QString("Connected!");
    emit currentMessageChanged();
}
