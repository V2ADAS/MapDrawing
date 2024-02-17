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

    QString gateway;
    bool init;
        ULONG tableSize = 0;

        tableSize = sizeof(MIB_IPFORWARDTABLE);
        DWORD status = GetIpForwardTable(nullptr, &tableSize, false);
        if (status != ERROR_SUCCESS && status != ERROR_INSUFFICIENT_BUFFER) {
            qWarning() << "GetIpForwardTable failed:", status;
            init = false;
        } else {
            init = true;
        }

        if (!init) {
            return "";
        }

        PMIB_IPFORWARDTABLE table = (PMIB_IPFORWARDTABLE)malloc(tableSize);
        if (!table) {
            qWarning() << "Memory allocation failed";
            return "";
        }

        status = GetIpForwardTable(table, &tableSize, false);
        if (status != ERROR_SUCCESS) {
            qWarning() << "GetIpForwardTable failed:", status;
            free(table);
            return "";
        }

        for (DWORD i = 0; i < table->dwNumEntries; i++) {
            if (table->table[i].dwForwardDest == 0) { // Check for default gateway
                gateway = QHostAddress(table->table[i].dwForwardNextHop).toString();
                free(table);

                QStringList parts = gateway.split(".");
                std::reverse(parts.begin(), parts.end());
                return parts.join(".");
            }
        }

        free(table);
        qWarning() << "Default gateway not found";
        return "";
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
        QNetworkInterface &iface = interfaces[i];

#ifdef Q_OS_WIN
        // Check if it's a Wi-Fi interface
        if (iface.type() == QNetworkInterface::Wifi) {
            wifiInterface = iface;
            qDebug() << wifiInterface.humanReadableName();
            if (wifiInterface.humanReadableName() == "Wi-Fi") {
                return;
            }
            // return; // Exit loop if found
        }
#else
        // Check if it's a Wi-Fi interface
        if (iface.type() == QNetworkInterface::Wifi) {
            wifiInterface = iface;
            qDebug() << wifiInterface.name();
            return; // Exit loop if found
        }
#endif
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
