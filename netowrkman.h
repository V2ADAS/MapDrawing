#ifndef NETOWRKMAN_H
#define NETOWRKMAN_H

#include <QObject>

class NetowrkMan : public QObject
{
    Q_OBJECT
public:
    explicit NetowrkMan(QObject *parent = nullptr);

signals:
};

#endif // NETOWRKMAN_H
