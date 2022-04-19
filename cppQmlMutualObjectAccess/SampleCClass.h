#ifndef SAMPLECCLASS_H
#define SAMPLECCLASS_H

#include <QObject>
#include <QQuickItem>

class SampleCClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString foo READ foo WRITE setFoo NOTIFY fooChanged)

    int m_timerId = 0;
    QString m_foo = "";
    void timerEvent(QTimerEvent *event) override;
public:
    SampleCClass();

    // foo/setFoo is called when property foo is read/written as defined in Q_PROPERTY.
    // also can call method from C++ as usual.
    QString foo();
    void setFoo(QString foo);

    Q_INVOKABLE void invokingMethodFromQML(QString txt);
    Q_INVOKABLE void my_start();
    Q_INVOKABLE void my_stop();
signals:
    void fooChanged();
    void sampleSignalFromC(QString txt);
    Q_INVOKABLE void invokingSignalFromQML(QString txt);
public slots:
    void invokingSlotFromQML(QString txt);

    //------------------------------------------
    // sample for accessing QML object in C++
private:
    QObject *m_obj = nullptr;
    QQuickItem *m_item = nullptr;
public:
    Q_INVOKABLE void setQMLObjectsToCpp(QObject *obj, QQuickItem *item, QVariant qvObj, QVariant qvItem);
    Q_INVOKABLE void giveBack();
signals:
    void signalForPassBackObjectsToQML(QObject *obj, QQuickItem *item, QVariant qvObj, QVariant qvItem);
};

#endif // SAMPLECCLASS_H
