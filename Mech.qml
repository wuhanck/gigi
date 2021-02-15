import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window {
    id: mech
    title: qsTr("机械控制")
    visible: false
    width: 640 + root.defaultSpacing * 2
    height: col.implicitHeight + root.defaultSpacing * 2
    color: root.palette.window
    Column {
        id: col
        anchors.fill: parent
        anchors.margins: root.defaultSpacing
        spacing: root.defaultSpacing
        property real cellWidth: col.width / 3 - spacing
        property string uStatus: qsTr("未更新")
        property string vStatus: qsTr("未更新")
        property string dStatus: qsTr("未更新")
        Grid {
            columns: 6
            spacing: root.defaultSpacing
            width: parent.width
            Label {text: qsTr("U轴:")}
            Label {text: col.uStatus}
            Label {text: qsTr("V轴:")}
            Label {text: col.vStatus}
            Label {text: qsTr("D轴:")}
            Label {text: col.dStatus}
        }
        Button {
            id: updateMech
            width: col.cellWidth
            text: updateMech.enabled ? qsTr("更新U/V/D轴坐标") : qsTr("更新中")
            onClicked: {
                updateMech.enabled = false
                function fin_d(ret) {
                    col.dStatus = qsTr("坐标 ") + ret[0].toString() + (ret[1] ? qsTr(". 运动中.") : qsTr(". 已停止."))
                    updateMech.enabled = true
                }
                function fin_v(ret) {
                    col.vStatus = qsTr("坐标 ") + ret[0].toString() + (ret[1] ? qsTr(". 运动中.") : qsTr(". 已停止."))
                    var tag = root.tags.push(fin_d)
                    bi.d_status(tag)
                }
                function fin_u(ret) {
                    col.uStatus = qsTr("坐标 ") + ret[0].toString() + (ret[1] ? qsTr(". 运动中.") : qsTr(". 已停止."))
                    var tag = root.tags.push(fin_v)
                    bi.v_status(tag)
                }
                var tag = root.tags.push(fin_u)
                bi.u_status(tag)
            }
        }
        Rectangle {
            color: root.palette.text
            width: parent.width
            height: 1
        }
        Grid {
            columns: 2
            Button {
                id: s2pBtn
                width: col.cellWidth
                text: qsTr("停止到平面(法向U/V/D)")
                onClicked: {
                    var u0 = parseFloat(u0Txt.text)
                    var v0 = parseFloat(v0Txt.text)
                    var d0 = parseFloat(d0Txt.text)
                    s2pBtn.enabled = false
                    function _(ret) {s2pBtn.enabled = true; s2pLabel.text = JSON.stringify(ret)}
                    var tag = root.tags.push(_)
                    bi.stop2plane(tag, u0, v0, d0)
                }
            }
            Label {id: s2pLabel; text: "Stand by"}
        }
        Grid {
            columns: 3
            spacing: root.defaultSpacing
            width: parent.width
            TextField {id: u0Txt; text: "0"}
            TextField {id: v0Txt; text: "0"}
            TextField {id: d0Txt; text: "100"}
        }

        Rectangle {
            color: root.palette.text
            width: parent.width
            height: 1
        }
        Grid {
            columns: 3
            spacing: root.defaultSpacing
            width: parent.width
            Button {
                id: udistBtn
                width: col.cellWidth
                text: qsTr("U轴移动到坐标")
                onClicked: {
                    var dist = parseFloat(udistTxt.text)
                    udistBtn.enabled = false
                    function _() {udistBtn.enabled = true}
                    var tag = root.tags.push(_)
                    bi.u2dist(tag, dist)
                }
            }
            TextField {id: udistTxt; text: "0"}
            Label {text: " "}

            Button {
                id: umaxBtn
                width: col.cellWidth
                text: qsTr("U轴正向移动")
                onPressed: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.u2max(tag)
                }
                onReleased: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.ustop(tag)
                }
            }
            Button {
                id: uminBtn
                width: col.cellWidth
                text: qsTr("U轴反向移动")
                onPressed: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.u2min(tag)
                }
                onReleased: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.ustop(tag)
                }
            }
            Button {
                id: ustopBtn
                width: col.cellWidth
                text: qsTr("U轴急停")
                onClicked: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.ustop(tag)
                }
            }

            Button {
                id: urelpBtn
                width: col.cellWidth
                text: qsTr("U轴正向相对移动")
                onClicked: {
                    var dist = parseFloat(urelpTxt.text)
                    urelpBtn.enabled = false
                    function _() {urelpBtn.enabled = true}
                    var tag = root.tags.push(_)
                    bi.u2rel(tag, dist)
                }
            }
            TextField {id: urelpTxt; text: "0.5"}
            Label {text: " "}

            Button {
                id: urelnBtn
                width: col.cellWidth
                text: qsTr("U轴反向相对移动")
                onClicked: {
                    var dist = parseFloat(urelnTxt.text)
                    urelnBtn.enabled = false
                    function _() {urelnBtn.enabled = true}
                    var tag = root.tags.push(_)
                    bi.u2rel(tag, -dist)
                }
            }
            TextField {id: urelnTxt; text: "0.5"}
            Label {text: " "}
        }
        Rectangle {
            color: root.palette.text
            width: parent.width
            height: 1
        }
        Grid {
            columns: 3
            spacing: root.defaultSpacing
            Button {
                id: vdistBtn
                width: col.cellWidth
                text: qsTr("V轴移动到坐标")
                onClicked: {
                    var dist = parseFloat(vdistTxt.text)
                    vdistBtn.enabled = false
                    function _() {vdistBtn.enabled = true}
                    var tag = root.tags.push(_)
                    bi.v2dist(tag, dist)
                }
            }
            TextField {id: vdistTxt; text: "0"}
            Label {text: " "}

            Button {
                id: vmaxBtn
                width: col.cellWidth
                text: qsTr("V轴正向移动")
                onPressed: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.v2max(tag)
                }
                onReleased: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.vstop(tag)
                }
            }
            Button {
                id: vminBtn
                width: col.cellWidth
                text: qsTr("V轴反向移动")
                onPressed: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.v2min(tag)
                }
                onReleased: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.vstop(tag)
                }
            }
            Button {
                id: vstopBtn
                width: col.cellWidth
                text: qsTr("V轴急停")
                onClicked: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.vstop(tag)
                }
            }

            Button {
                id: vrelpBtn
                width: col.cellWidth
                text: qsTr("V轴正向相对移动")
                onClicked: {
                    var dist = parseFloat(vrelpTxt.text)
                    vrelpBtn.enabled = false
                    function _() {vrelpBtn.enabled = true}
                    var tag = root.tags.push(_)
                    bi.v2rel(tag, dist)
                }
            }
            TextField {id: vrelpTxt; text: "0.5"}
            Label {text: " "}

            Button {
                id: vrelnBtn
                width: col.cellWidth
                text: qsTr("V轴反向相对移动")
                onClicked: {
                    var dist = parseFloat(vrelnTxt.text)
                    vrelnBtn.enabled = false
                    function _() {vrelnBtn.enabled = true}
                    var tag = root.tags.push(_)
                    bi.v2rel(tag, -dist)
                }
            }
            TextField {id: vrelnTxt; text: "0.5"}
            Label {text: " "}
        }
        Rectangle {
            color: root.palette.text
            width: parent.width
            height: 1
        }
        Grid {
            columns: 3
            spacing: root.defaultSpacing
            Button {
                id: ddistBtn
                width: col.cellWidth
                text: qsTr("D轴移动到坐标")
                onClicked: {
                    var dist = parseFloat(ddistTxt.text)
                    ddistBtn.enabled = false
                    function _() {ddistBtn.enabled = true}
                    var tag = root.tags.push(_)
                    bi.d2dist(tag, dist)
                }
            }
            TextField {id: ddistTxt; text: "50"}
            Label {text: " "}

            Button {
                id: dmaxBtn
                width: col.cellWidth
                text: qsTr("D轴正向移动")
                onPressed: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.d2max(tag)
                }
                onReleased: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.dstop(tag)
                }
            }
            Button {
                id: dminBtn
                width: col.cellWidth
                text: qsTr("D轴反向移动")
                onPressed: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.d2min(tag)
                }
                onReleased: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.dstop(tag)
                }
            }
            Button {
                id: dstopBtn
                width: col.cellWidth
                text: qsTr("D轴急停")
                onClicked: {
                    function _() {}
                    var tag = root.tags.push(_)
                    bi.dstop(tag)
                }
            }
            Button {
                id: drelpBtn
                width: col.cellWidth
                text: qsTr("D轴正向相对移动")
                onClicked: {
                    var dist = parseFloat(drelpTxt.text)
                    drelpBtn.enabled = false
                    function _() {drelpBtn.enabled = true}
                    var tag = root.tags.push(_)
                    bi.d2rel(tag, dist)
                }
            }
            TextField {id: drelpTxt; text: "0.5"}
            Label {text: " "}

            Button {
                id: drelnBtn
                width: col.cellWidth
                text: qsTr("D轴反向相对移动")
                onClicked: {
                    var dist = parseFloat(drelnTxt.text)
                    drelnBtn.enabled = false
                    function _() {drelnBtn.enabled = true}
                    var tag = root.tags.push(_)
                    bi.d2rel(tag, -dist)
                }
            }
            TextField {id: drelnTxt; text: "0.5"}
            Label {text: " "}
        }
    }
}
