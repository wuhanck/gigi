import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "./tags.js" as Tags

QtObject {
    id: root
    property real defaultSpacing: 10
    property SystemPalette palette: SystemPalette {}

    property var controlWindow: Window {
        title: qsTr("主控制窗口")
        //width: col.implicitWidth + root.defaultSpacing * 2
        width: 600 + root.defaultSpacing * 2
        height: col.implicitHeight + root.defaultSpacing * 2
        color: root.palette.window
        Column {
            id: col
            anchors.fill: parent
            anchors.margins: root.defaultSpacing
            spacing: root.defaultSpacing
            property real cellWidth: col.width / 3 - spacing
            Grid {
                id: grid
                columns: 3
                spacing: root.defaultSpacing
                width: parent.width
                Button {
                    id: showCamea
                    width: col.cellWidth
                    text: root.upcamWindow.visible ? qsTr("关闭底视角窗口") : qsTr("打开底视角窗口")
                    onClicked: root.upcamWindow.visible = !root.upcamWindow.visible
                }
                Button {
                    id: showMainview
                    width: col.cellWidth
                    text: root.mainviewWindow.visible ? qsTr("关闭主视角窗口") : qsTr("打开主视角窗口")
                    onClicked: root.mainviewWindow.visible = !root.mainviewWindow.visible
                }
                Button {
                    id: showMech
                    width: col.cellWidth
                    text: root.mechWindow.visible ? qsTr("关闭机械控制窗口") : qsTr("打开机械控制窗口")
                    onClicked: root.mechWindow.visible = !root.mechWindow.visible
                }
            }
            Rectangle {
                color: root.palette.text
                width: parent.width
                height: 1
            }
            property string procStage: qsTr("Stand by")
            Grid {
                columns: 2
                spacing: root.defaultSpacing
                width: parent.width
                Label {text: qsTr("type(0 for orange;1 for melon):")}
                TextField {id: proc_type; text: "0"}
                Label {text: qsTr("proc name:")}
                TextField {id: proc_name; text: "test0"}
                Label {text: qsTr("arg1:")}
                TextField {id: arg1; text: "1"}
                Label {text: qsTr("arg2:")}
                TextField {id: arg2}
                Label {text: qsTr("arg3:")}
                TextField {id: arg3}
                Label {text: qsTr("arg4:")}
                TextField {id: arg4}
                Label {text: qsTr("arg5:")}
                TextField {id: arg5}
                Label {text: qsTr("arg6:")}
                TextField {id: arg6}
                Label {text: qsTr("arg7:")}
                TextField {id: arg7}
                Label {text: qsTr("arg8:")}
                TextField {id: arg8}
            }
            Button {
                id: callProcBtn
                width: col.cellWidth
                text: callProcBtn.enabled ? qsTr("Begin to run proc") : qsTr("Wait for proc to finished")
                onClicked: {
                    callProcBtn.enabled = false
                    const proctype = proc_type.text
                    const args = [arg1.text, arg2.text, arg3.text, arg4.text, arg5.text, arg6.text, arg7.text, arg8.text]
                    const jargs = JSON.stringify(args)
                    function fin_proc(ret) {
                        col.procStage = qsTr("Last result: ") + ret.toString() + qsTr(". Stand by")
                        callProcBtn.enabled = true
                    }
                    var tag = root.tags.push(fin_proc)
                    if (proctype === '0')
                        bi.proc_call(tag, proc_name.text, jargs)
                    else
                        bi.ai_call(tag, proc_name.text, jargs)
                    col.procStage = qsTr("Running proc: ") + proc_name.text
                }
            }
            Rectangle {
                color: root.palette.text
                width: parent.width
                height: 1
            }
            Label {text: col.procStage}
        }
    }

    property var callguiWindow: Window {
        title: qsTr("Called Window")
        width: 600 + root.defaultSpacing * 2
        height: col2.implicitHeight + root.defaultSpacing * 2
        color: root.palette.window
        flags: Qt.WindowStaysOnTopHint
        Column {
            id: col2
            anchors.fill: parent
            anchors.margins: root.defaultSpacing
            spacing: root.defaultSpacing
            property real cellWidth: col2.width / 3 - spacing
            property string procName: qsTr("unknown")
            property string procStep: qsTr("unknown")
            property string procArgs: qsTr("[unknown]")
            property var procTag: 0
            Label {text: qsTr("Called by: ") + parent.procName}
            Label {text: qsTr("In step: ") + parent.procStep}
            Label {text: qsTr("With args: ") + parent.procArgs}
            Rectangle {
                color: root.palette.text
                width: parent.width
                height: 1
            }
            Grid {
                columns: 2
                spacing: root.defaultSpacing
                width: parent.width
                Label {text: qsTr("return:")}
                TextField {id: callguiret; text: "ok"}
                Label {text: qsTr("arg1:")}
                TextField {id: callguiarg1; text: "1"}
                Label {text: qsTr("arg2:")}
                TextField {id: callguiarg2}
                Label {text: qsTr("arg3:")}
                TextField {id: callguiarg3}
                Label {text: qsTr("arg4:")}
                TextField {id: callguiarg4}
                Label {text: qsTr("arg5:")}
                TextField {id: callguiarg5}
                Label {text: qsTr("arg6:")}
                TextField {id: callguiarg6}
                Label {text: qsTr("arg7:")}
                TextField {id: callguiarg7}
                Label {text: qsTr("arg8:")}
                TextField {id: callguiarg8}
            }
            Button {
                id: callGuiBtn
                width: col2.cellWidth
                text: qsTr("Ready to reply")
                onClicked: {
                    const args = [callguiret.text, callguiarg1.text, callguiarg2.text, callguiarg3.text, callguiarg4.text,
                                  callguiarg5.text, callguiarg6.text, callguiarg7.text, callguiarg8.text]
                    const ret = JSON.stringify(args)
                    bi.ret_call_gui(parent.procTag, ret)
                    callguiWindow.visible = false
                }
            }
        }
    }

    property var upcamWindow: Upcam {}
    property var mainviewWindow: Mainview {}
    property var mechWindow: Mech {}


    property var splashWindow: Splash {
        function show_root() {
            root.controlWindow.visible = true
            //root.upcamWindow.visible = true
            //root.mainviewWindow.visible = true
        }
        onTimeout: show_root()
    }

    property var tags: Tags
    property var bibridge: Connections {
        target: bi
        function onCallRet(tag, jstr) {
            const [cb] = Tags.pop(tag)
            const ret = JSON.parse(jstr)
            cb(ret)
        }
        function onCallGui(tag, jstr) {
            if (callguiWindow.visible) {
                var ret = JSON.stringify(["err", "allow only one proc-call one time"])
                bi.ret_call_gui(tag, ret)
                return
            }
            const [call_from, proc_name, step,
                   ...args] = JSON.parse(jstr)
            col2.procTag = tag
            col2.procName = proc_name
            col2.procStep = step
            col2.procArgs = JSON.stringify(args)
            col.procStage = proc_name + qsTr(" in step: ") + step
            callguiWindow.visible = true
        }
    }
}
