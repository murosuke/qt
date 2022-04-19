#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "SampleCClass.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    SampleCClass sampleInstance;

    QQmlApplicationEngine engine;

    // access to property defined in Q_PROPERTY.
    // also can access from method setFoo/foo. in this case setFoo/foo is better in performance.
    sampleInstance.setProperty("foo", "Hello Foo!!");   // write property
    qDebug() << __FUNCTION__ << sampleInstance.property("foo").toString();  // read property

    // this lets QML able to access to sampleInstance(only one instance) by name "sampleInstance_inQml"
    // this should be done before loading QML that uses sampleInstance_inQml.
    engine.rootContext()->setContextProperty("sampleInstance_inQml", &sampleInstance);

    const QUrl url(u"qrc:/cppQmlMutualObjectAccess/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
