#ifndef DRAWINGMAN_H
#define DRAWINGMAN_H

#include <QObject>
#include <QProcess>
#include <QTimer>
#include <QRandomGenerator64>

class DrawingMan : public QObject
{
    Q_OBJECT
public:
    explicit DrawingMan(QString appDir, QObject *parent = nullptr);

    Q_INVOKABLE void runScript();
    Q_INVOKABLE void stopScript();

private:
    QString appDir;
    QString channelFilePath;
    QProcess process = QProcess(this);
    QTimer timer = QTimer(this);
    QRandomGenerator rng;
    int numSensors = 6;
    QString latestJsonReading;

public slots:
    void readOutput();
    void readError();
    void processFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void onTimeout();
    void updateLatestReading(QString message);
};

#endif // DRAWINGMAN_H
