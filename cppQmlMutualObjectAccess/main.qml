import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml

Window {
    id: window
    width: 800
    height: 480
    visible: true
    title: qsTr("Hello World")
    ColumnLayout{
        id: column
        anchors.fill: parent
        anchors.margins: 10
        readonly property int fontSize: 16
        spacing: 4

        Label{
            Layout.fillWidth: true
            Layout.maximumHeight: 25
            font{
                bold: true
                pointSize: column.fontSize
            }
            text: "---- sample for property ----"
        }
        Label{
            id: fooLabel
            Layout.fillWidth: true
            Layout.maximumHeight: 20
            font{
                bold: true
                pointSize: 12
            }
            // binding text to sampleInstance_inQml.foo property.
            // fooChanged signal will detected and text will be updated.
            text: "foo: " + sampleInstance_inQml.foo
        }
        RowLayout{
            Layout.fillWidth: true
            Layout.maximumHeight: 20
            TextArea{
                Layout.minimumWidth: 150
                id: textAreaForFoo
                selectByKeyboard : true
                selectByMouse : true
                placeholderText: "input some text here."
            }
            Button{
                text: "update foo"
                onClicked:{
                    sampleInstance_inQml.foo = textAreaForFoo.text
                }
            }
            Label{
                text: "this causes setFoo and also foo for updating binded label above."
            }
        }

        Label{
            Layout.fillWidth: true
            Layout.maximumHeight: 25
            font{
                bold: true
                pointSize: column.fontSize
            }
            text: "---- sample for accessing C++ object(one instance) in QML ----"
        }
        RowLayout{
            Layout.fillWidth: true
            Layout.maximumHeight: 20
            Button{
                text: "call public slots"
                onClicked:{
                    sampleInstance_inQml.invokingSlotFromQML("1. call from QML.")
                }
            }
            Label{
                text: "public slots can be called from qml."
            }
        }
        RowLayout{
            Layout.fillWidth: true
            Layout.maximumHeight: 20
            Button{
                text: "call Q_INVOKABLE public method"
                onClicked:{
                    sampleInstance_inQml.invokingMethodFromQML("2. call from QML.")
                }
            }
            Label{
                text: "Q_INVOKABLE public method can also be called from qml."
            }
        }
        RowLayout{
            id: dynamicConnectSample
            Layout.fillWidth: true
            Layout.maximumHeight: 60
            function slotInQml(text){
                console.log("slotInQml: " + text)
            }

            Button{
                text: "dynamic connect"
                onClicked:{
                    sampleInstance_inQml.invokingSignalFromQML.connect(dynamicConnectSample.slotInQml)
                    popupText.text = "dynamically connected C++ objects signal to QML slot."
                    sampleDialog.open()
                }
            }
            Button{
                text: "call Q_INVOKABLE signals"
                onClicked:{
                    sampleInstance_inQml.invokingSignalFromQML("3. call signal from QML.")
                }
            }
            Button{
                text: "disconnect"
                onClicked:{
                    sampleInstance_inQml.invokingSignalFromQML.disconnect(dynamicConnectSample.slotInQml)
                    popupText.text = "dynamically disconnected."
                    sampleDialog.open()
                }
            }
            Label{
                text: "Q_INVOKABLE signals can also be called from qml(first connect and then check log).\nif the invokingSignalFromQML signal is connected to other slots, \nthis will also invoke the connected other slots."
            }
        }
        RowLayout{
            Layout.fillWidth: true
            Layout.minimumHeight: 40
            Button{
                text: "start timer"
                onClicked:{
                    sampleInstance_inQml.my_start()
                    popupText.text = "timer started. check log."
                    sampleDialog.open()
                }
            }
            Button{
                text: "stop timer"
                onClicked:{
                    sampleInstance_inQml.my_stop()
                    popupText.text = "timer stopped."
                    sampleDialog.open()
                }
            }
            Label{
                text: "QML Connections can statically connect to signal. to catch signal, naming rules(on + UpperCaseLetter) must be followed.\nC++ signals: void signalName() -> QML Connections function onSignalName()"
            }
            Connections{
                target: sampleInstance_inQml
                function onSampleSignalFromC(text){
                    console.log("onSampleSignalFromC: " + text)
                }
            }
        }
        RowLayout{
            id: dynamicConnectSample2
            Layout.fillWidth: true
            Layout.maximumHeight: 60
            function slotInQml2(text){
                console.log("slotInQml2: " + text)
            }
            signal signalInQml(string text)

            Button{
                text: "dynamic connect"
                onClicked:{
                    dynamicConnectSample2.signalInQml.connect(dynamicConnectSample2.slotInQml2)
                    popupText.text = "dynamically connected QML objects signal to QML slot."
                    sampleDialog.open()
                }
            }
            Button{
                text: "call QML signals"
                onClicked:{
                    dynamicConnectSample2.signalInQml("4. call QML signal from QML.")
                }
            }
            Button{
                text: "disconnect"
                onClicked:{
                    dynamicConnectSample2.signalInQml.disconnect(dynamicConnectSample2.slotInQml2)
                    popupText.text = "dynamically disconnected."
                    sampleDialog.open()
                }
            }
            Label{
                text: "QML signals can also be called and connected in qml(first connect and then check log).\nif the invokingSignalFromQML signal is connected to other slots, \nthis will also invoke the connected other slots."
            }
        }
        Label{
            Layout.fillWidth: true
            Layout.maximumHeight: 25
            font{
                bold: true
                pointSize: column.fontSize
            }
            text: "---- sample for accessing QML object in C++ ----"
        }
        RowLayout{
            id: passQMLObjectToCpp
            Layout.fillWidth: true
            Layout.maximumHeight: 20
            Button{
                text: "pass QML object to C++"
                onClicked:{
                    qQuickItemSample.parent = passQMLObjectToCpp
                    sampleInstance_inQml.setQMLObjectsToCpp(qObjectSample,
                                                            qQuickItemSample,
                                                            qObjectSample,
                                                            qQuickItemSample)
                }
            }
            Label{
                text: "some QML objects is also accessable from C++."
            }
            QtObject{
                id: qObjectSample
                objectName: "my name is qObjectSample"
            }
            Rectangle{
                id: qQuickItemSample
                objectName: "my name is qQuickItemSample. I inherit QQuickItem."
                width: 20
                height: 10
                color: "red"
            }
        }
        RowLayout{
            id: passQMLObjectToCpp2
            Layout.fillWidth: true
            Layout.maximumHeight: 20
            Button{
                text: "QML object pass back to QML"
                onClicked:{
                    sampleInstance_inQml.giveBack()
                }
            }
            Label{
                text: "you can pass QML objects from C++ to QML. this button will change Rectangles color and parent."
            }
            Connections{
                target:sampleInstance_inQml
                function onSignalForPassBackObjectsToQML(obj, item, qvObj, qvItem){
                    console.log("onSignalForPassBackObjectsToQML: " + obj.objectName)
                    console.log("onSignalForPassBackObjectsToQML: " + item.objectName)
                    console.log("onSignalForPassBackObjectsToQML: " + qvObj.objectName)
                    console.log("onSignalForPassBackObjectsToQML: " + qvItem.objectName)
                    qvItem.color = "blue"
                    qvItem.parent = passQMLObjectToCpp2
                }
            }
        }

        Item{
            objectName: "spacer"
            Layout.fillHeight: true
        }
    }
    Dialog{
        id: sampleDialog
        anchors.centerIn : Overlay.overlay
        width: 400
        height: 100
        modal: true
        focus: true
        title: "message box"
        standardButtons:Dialog.Ok
        Label{
            id:popupText
        }
    }
}
