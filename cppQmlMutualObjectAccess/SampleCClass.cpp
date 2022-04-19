#include <QDebug>
#include "SampleCClass.h"

void SampleCClass::timerEvent(QTimerEvent *event)
{
    emit sampleSignalFromC("signal that timer expired.");
}
SampleCClass::SampleCClass()
{
}
QString SampleCClass::foo()
{
    qDebug() << __FUNCTION__ << "called.";
    return m_foo;
}
void SampleCClass::setFoo(QString foo)
{
    qDebug() << __FUNCTION__ << "called.";
    if(foo == m_foo) return;
    m_foo = foo;
    emit fooChanged();  // need to be emit for QML to know the value change.
}
void SampleCClass::invokingMethodFromQML(QString txt)
{
    qDebug() << __FUNCTION__ << txt;
}
void SampleCClass::my_start()
{
    if(m_timerId == 0){
        // start timer implemented in QObject
        // timerEvent(overridden method) is called when expired.
        m_timerId = startTimer(3000);
    }
}
void SampleCClass::my_stop()
{
    if(m_timerId != 0)
        killTimer(m_timerId);
    m_timerId = 0;
}
void SampleCClass::invokingSlotFromQML(QString txt)
{
    qDebug() << __FUNCTION__ << txt;
}


void SampleCClass::setQMLObjectsToCpp(QObject *obj, QQuickItem *item, QVariant qvObj, QVariant qvItem)
{
    // some QML Object can be accessed in c++ as like QObject, QQuickItem, or etc...
    qDebug() << __FUNCTION__ << obj->objectName();
    qDebug() << __FUNCTION__ << item->objectName() << " width=" << item->width() << " height=" << item->property("height");
    // can be passed as QVariant. in this case, it can be accessed as below.
    qDebug() << __FUNCTION__ << qvObj.value<QObject*>()->objectName();
    qDebug() << __FUNCTION__ << qvItem.value<QQuickItem*>()->objectName();

    // parameter item's type is defined QQuickItem*, but actual type is QML Rectangle.
    // There is no way to access to QML Rectangle implements in C++, but can access to property
    // with QObject::property, QObject::setProperty.
    // below is a sample changing color property that is not defined in QQuickItem.
    item->setProperty("color", QColor("red"));
    m_obj = obj;
    m_item = item;
}
void SampleCClass::giveBack()
{
    if(m_obj == nullptr || m_item == nullptr){
        qWarning() << __FUNCTION__ << "first pass objects to C++.";
        return;
    }
    emit signalForPassBackObjectsToQML(m_obj, m_item, QVariant::fromValue(m_obj), QVariant::fromValue(m_item));
}
