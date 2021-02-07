import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window {
    id: splash
    color: "transparent"
    title: "Splash Window"
    modality: Qt.ApplicationModal
    flags: Qt.SplashScreen
    property int timeoutInterval: 2000
    signal timeout
    x: (Screen.width - splashImage.width) / 2
    y: (Screen.height - splashImage.height) / 2
    width: splashImage.width
    height: splashImage.height

    Image {
        id: splashImage
        source: "./logo.png"
        MouseArea {
            anchors.fill: parent
        }
    }
    Timer {
        interval: splash.timeoutInterval; running: true; repeat: false
        onTriggered: {
            splash.visible = false
            splash.timeout()
        }
    }
    Component.onCompleted: visible = true
}
