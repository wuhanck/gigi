import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtMultimedia 5.12

Window {
    id: mainview
    title: qsTr("主视角")
    visible: false
    width: 800
    height: 800

    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            VideoOutput {
                id: vo
                Layout.fillWidth: true
                Layout.fillHeight: true
                fillMode: VideoOutput.PreserveAspectFit
                source: Camera {
                    id: maincam
                    //viewfinder.resolution: Qt.size(800, 800)
                    deviceId: '/dev/video31'

                }
                Connections {
                    target: maincam
                    function onErrorOccurred(errorCode, errorString) {
                        //console.log(`maincam err: ${errorString}. restart.`)
                        timermaincam.start()
                    }
                }
                autoOrientation: false
                property real line_x: 0.5
                property real angle_x: 90
                property real line_y: 0.5
                property real angle_y: 90
                Rectangle {
                    id: xline
                    color: "red"
                    y: parent.height*parent.line_y
                    width: parent.width
                    height: 1
                }
                Rectangle {
                    id: yline
                    color: "red"
                    x: parent.width*parent.line_x
                    height:  parent.height
                    width: 1
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        vo.line_x = mouseX/parent.width
                        vo.line_y = mouseY/parent.height
                    }
                }
            }
            Timer {
                id: timermaincam
                interval: 500; running: false
                onTriggered: {maincam.stop(); maincam.start()}
            }
        }

        ComboBox {
            id: mainsrc
            Layout.minimumWidth: 320
            model: [qsTr('光学镜'), qsTr('电子镜-USB'), qsTr('电子镜-4K-HDMI'), qsTr('电子镜-普通'), qsTr('电子镜-4K-SDI')]
            onActivated: (idx)=>{
                var tag = root.tags.push(console.log)
                bi.set_maincamidx(tag, idx)
                timermaincam.start()
            }
        }
    }
}
