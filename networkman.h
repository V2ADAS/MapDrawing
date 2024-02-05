#ifndef NETWORKMAN_H
#define NETWORKMAN_H

#include <QObject>
#include <QtNetwork/QNetworkInterface>
#include <QTcpSocket>

class NetworkMan : public QObject
{
    Q_OBJECT
public:
    explicit NetworkMan(QObject *parent = nullptr);
    Q_INVOKABLE QString getCurrentIp();
    Q_INVOKABLE QString getGatewayIp();
    Q_INVOKABLE void openSocket(int port);
    Q_INVOKABLE void closeSocket();
    Q_INVOKABLE void sendMessage(QString message);

    Q_PROPERTY(QString currentMessage MEMBER currentMessage NOTIFY currentMessageChanged);

private:
    QTcpSocket wifiSocket = QTcpSocket(this);
    QNetworkInterface wifiInterface;
    void getWifiInterface();

    QString currentMessage;

signals:
    void currentMessageChanged();
    void readMessage(QString message);

public slots:
    void onReadyRead();
    void onConnected();
};

#endif // NETWORKMAN_H
