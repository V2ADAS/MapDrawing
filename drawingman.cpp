#include "drawingman.h"
#include <QDebug>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTimer>

DrawingMan::DrawingMan(QString appDir, QObject *parent) : QObject{parent} {
    this->appDir = appDir;
    channelFilePath = appDir + "/channel.csv";

    // Connect signals for asynchronous reading
    connect(&process, &QProcess::readyReadStandardOutput, this,
            &DrawingMan::readOutput);
    connect(&process, &QProcess::readyReadStandardError, this,
            &DrawingMan::readError);
    connect(&process, &QProcess::finished, this, &DrawingMan::processFinished);

    connect(&timer, &QTimer::timeout, this, &DrawingMan::onTimeout);
}

void DrawingMan::runScript() {
#ifdef Q_OS_UNIX
    QString runnerFile = "/runner.sh";
    process.start(appDir + runnerFile, QStringList() << channelFilePath << QString::number(numSensors));

    process.waitForStarted();

    timer.start(10);
#endif
}

void DrawingMan::stopScript() { process.close(); }

void DrawingMan::readOutput() {
    QProcess *process = qobject_cast<QProcess *>(sender());
    if (process) {
        QByteArray output = process->readAllStandardOutput();
        // Process the output as needed
        qDebug() << "Output: " << output;
    }
}

void DrawingMan::readError() {
    QProcess *process = qobject_cast<QProcess *>(sender());
    if (process) {
        QByteArray error = process->readAllStandardError();
        // Process the error as needed
        qDebug() << "Error: " << error;
    }
}

void DrawingMan::processFinished(int exitCode,
                                 QProcess::ExitStatus exitStatus) {
    QProcess *process = qobject_cast<QProcess *>(sender());
    if (process) {
        // Process has finished
        qDebug() << "Process finished with exit code: " << exitCode;
        qDebug() << "Exit status: " << exitStatus;
    }

    QFile::remove(channelFilePath);

    timer.stop();
}

void DrawingMan::onTimeout() {
    // Writing to the text file
    QFile fileOut(channelFilePath);
    if (fileOut.open(QIODevice::Append | QIODevice::Text)) {
        QTextStream out(&fileOut);

        // // Parse JSON string
        // QJsonDocument jsonDocument =
        //     QJsonDocument::fromJson(latestJsonReading.toUtf8());

        // // Check if the document is an object
        // if (!jsonDocument.isObject()) {
        //     qDebug() << "Invalid JSON object." << jsonDocument;
        //     return;
        // }
        // // Get the JSON object
        // QJsonObject jsonObject = jsonDocument.object();
        // QStringList keys = jsonObject.keys();

        // // Create arrays
        // QList<double> valArray;

        // // Iterate through keys
        // for (const QString &key : keys) {
        //     // Get the value for each key
        //     double value = QString(jsonObject.value(key).toString()).toDouble();
        //     if(value < 0) value *= -1;
        //     valArray.append(value * 100);
        // }

        QList<double> valArray;

        valArray << rng.bounded(400) << rng.bounded(400) << rng.bounded(400) << rng.bounded(400) << rng.bounded(400) << rng.bounded(400);

        // sensor 1, Center Front
        out << "0," << valArray[0] + 20;
        out << ",";

        // sensor 2, Center Right
        out << valArray[1] + 10 << ",0";
        out << ",";

        // sensor 3, Center Left
        out << -valArray[2] - 10 << ",0";
        out << ",";

        // sensor 4, Center Back
        out << "0," << -valArray[3] - 20;
        out << ",";

        // sensor 5, Left Back
        out << -valArray[4] - 10 << "," << -valArray[4] - 20;
        out << ",";

        // sensor 6, Right Back
        out << valArray[5] + 10 << "," << -valArray[5] - 20;
        out << ",";

        // Constant Translation and rotation
        out << 5 << "," << 10;

        out << '\n';

    } else {
        qDebug() << "Failed to open the file for writing.";
    }
}

void DrawingMan::updateLatestReading(QString message) {
    latestJsonReading = message;
}
