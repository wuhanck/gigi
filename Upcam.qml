import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtMultimedia 5.12

Window {
    id: upcam
    title: qsTr("底视角")
    visible: false
    width: 600
    height: 600

    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            VideoOutput {
                Layout.fillWidth: true
                Layout.fillHeight: true
                fillMode: VideoOutput.PreserveAspectFit
                source: Camera {
                    id: auxcam
                    deviceId: '/dev/video30'
                }
                autoOrientation: false
                Connections {
                    target: auxcam
                    function onErrorOccurred(errorCode, errorString) {
                        //console.log(`auxcam err: ${errorString}. restart.`)
                        timerauxcam.start()
                    }
                }
            }

            Timer {
                id: timerauxcam; running: false
                interval: 500
                onTriggered: {auxcam.stop(); auxcam.start()}
            }
        }
    }
}
