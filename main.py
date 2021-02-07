#!/usr/bin/env python3

import os
import sys
import json

from PySide2 import QtCore
from PySide2 import QtGui
from PySide2 import QtQml
from PySide2.QtCore import Qt, QObject, Slot, Signal
from PySide2.QtQuick import QQuickWindow

import p_rpc

from op_serv import call_serv, op_init, op_exit, call_gui, gui_result
from selfconf import _kiwi, _orange, _melon
from gigi_tags import _gigi_pushval, _gigi_popval


_real_file = sys.argv[0]  # for qt debug issue
CURRENT_DIR = os.path.dirname(os.path.realpath(_real_file))


# Slot here used for QML to invoke py. Not For signal-connect
class Bi(QObject):
    # int, str(json)
    callRet = Signal(int, str)

    def gen_cb(self, tag):

        def cb(res):
            try:
                ret = res.result()
                ret = json.dumps(ret)
            except Exception as e:
                ret = repr(e)
                ret = json.dumps(ret)
            finally:
                self.callRet.emit(tag, ret)
        return cb

    @Slot(int, int)
    def set_maincamidx(self, tag, idx):
        call_serv(_kiwi.mainview1_set(idx), self.gen_cb(tag))

    @Slot(int)
    def u_status(self, tag):
        call_serv(_kiwi.u_status(), self.gen_cb(tag))

    @Slot(int)
    def v_status(self, tag):
        call_serv(_kiwi.v_status(), self.gen_cb(tag))

    @Slot(int)
    def d_status(self, tag):
        call_serv(_kiwi.d_status(), self.gen_cb(tag))

    @Slot(int, float)
    def u2dist(self, tag, dist):
        call_serv(_kiwi.u_rotate(False, dist), self.gen_cb(tag))

    @Slot(int, float)
    def u2rel(self, tag, dist):
        call_serv(_kiwi.u_rotate(True, dist), self.gen_cb(tag))

    @Slot(int)
    def u2min(self, tag):
        call_serv(_kiwi.u_rotate_min(), self.gen_cb(tag))

    @Slot(int)
    def u2max(self, tag):
        call_serv(_kiwi.u_rotate_max(), self.gen_cb(tag))

    @Slot(int, float)
    def v2dist(self, tag, dist):
        call_serv(_kiwi.v_rotate(False, dist), self.gen_cb(tag))

    @Slot(int, float)
    def v2rel(self, tag, dist):
        call_serv(_kiwi.v_rotate(True, dist), self.gen_cb(tag))

    @Slot(int)
    def v2min(self, tag):
        call_serv(_kiwi.v_rotate_min(), self.gen_cb(tag))

    @Slot(int)
    def v2max(self, tag):
        call_serv(_kiwi.v_rotate_max(), self.gen_cb(tag))

    @Slot(int, float)
    def d2dist(self, tag, dist):
        call_serv(_kiwi.d_move(False, dist), self.gen_cb(tag))

    @Slot(int)
    def d2min(self, tag):
        call_serv(_kiwi.d_move_min(), self.gen_cb(tag))

    @Slot(int)
    def d2max(self, tag):
        call_serv(_kiwi.d_move_max(), self.gen_cb(tag))

    @Slot(int)
    def ustop(self, tag):
        call_serv(_kiwi.u_stop(), self.gen_cb(tag))

    @Slot(int)
    def vstop(self, tag):
        call_serv(_kiwi.v_stop(), self.gen_cb(tag))

    @Slot(int)
    def dstop(self, tag):
        call_serv(_kiwi.d_stop(), self.gen_cb(tag))

    @Slot(int, float, float, float)
    def stop2plane(self, tag, u0, v0, d0):
        call_serv(_kiwi.stop2plane(u0, v0, d0), self.gen_cb(tag))

    @Slot(int, str, str)
    def proc_call(self, tag, proc_name, jargs):
        args = json.loads(jargs)
        call_serv(_orange.call(proc_name, *args), self.gen_cb(tag))

    @Slot(int, str, str)
    def ai_call(self, tag, proc_name, jargs):
        args = json.loads(jargs)
        call_serv(_melon.call(proc_name, *args), self.gen_cb(tag))

    # int, str(json)
    callGui = Signal(int, str)

    @Slot(int, str)
    def ret_call_gui(self, tag, jret):
        fut, = _gigi_popval(tag)
        try:
            ret = json.loads(jret)
        except Exception as e:
            ret = repr(e)
        finally:
            gui_result(fut, ret)


_bi = None


def _to_gui_call(fut, *args):
    tag = _gigi_pushval(fut)
    jargs = json.dumps(args)
    _bi.callGui.emit(tag, jargs)


@p_rpc.serve_remote
async def gigi_call(bus, call_from, proc_name, step, *args):
    return await call_gui(_to_gui_call, call_from, proc_name, step, *args)


def main():
    global _bi
    _bi = Bi()
    op_init()

    app = QtGui.QGuiApplication(sys.argv)
    screens = QtGui.QGuiApplication.screens()
    for screen in screens:
        screen.setOrientationUpdateMask(Qt.LandscapeOrientation
                                        | Qt.PortraitOrientation
                                        | Qt.InvertedLandscapeOrientation
                                        | Qt.InvertedPortraitOrientation)
    QQuickWindow.setDefaultAlphaBuffer(True)
    engine = QtQml.QQmlApplicationEngine()
    engine.rootContext().setContextProperty('bi', _bi)
    engine.load(QtCore.QUrl.fromLocalFile(f'{CURRENT_DIR}/window.qml'))
    if not engine.rootObjects():
        return -1

    # https://wiki.qt.io/Qt_for_Python_Signals_and_Slots
    app.aboutToQuit.connect(op_exit)

    return app.exec_()


if __name__ == '__main__':
    sys.exit(main())
