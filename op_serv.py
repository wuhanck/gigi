# This Python file uses the following encoding: utf-8

import threading
import logging
import asyncio

from PySide2.QtCore import QObject, Signal, Slot
from PySide2.QtCore import Qt

import arun


_call_serv_tag = 0
_call_gui_tag = 0
_call_serv = {}
_call_gui = {}
_serv_thread = None


class _Callcomm(QObject):
    serv = Signal(int)
    gui = Signal(int)


@Slot(int)
def _call_serv_bd(tag):
    ret = _call_serv.pop(tag, None)
    assert(ret is not None)
    func = ret[0]
    result = ret[1]
    func(result)


async def _put_gui_except(fut, e):
    fut.set_exception(e)


@Slot(int)
def _call_gui_bd(tag):
    ret = _call_gui.pop(tag, None)
    assert(ret is not None)
    func = ret[0]
    args = ret[1]
    kwargs = ret[2]
    fut = ret[3]
    try:
        func(fut, *args, **kwargs)
    except Exception as e:
        arun.post_in_main(_put_gui_except(fut, e))


_call_comm = _Callcomm()
_call_comm.serv.connect(_call_serv_bd, type=Qt.QueuedConnection)
_call_comm.gui.connect(_call_gui_bd, type=Qt.QueuedConnection)


async def _call_serv_wrap(task, tag):
    try:
        return await task
    finally:
        _call_comm.serv.emit(tag)


def _noop_cb(result):
    try:
        result.result()
    except asyncio.CancelledError:
        pass
    except Exception:
        pass


def call_serv(task, cb=_noop_cb):
    global _call_serv_tag
    _call_serv_tag += 1
    tag = _call_serv_tag
    result = arun.post_in_main(_call_serv_wrap(task, tag))
    _call_serv[tag] = (cb, result)


async def _put_gui_result(fut, ret):
    fut.set_result(ret)


def gui_result(fut, ret):
    arun.post_in_main(_put_gui_result(fut, ret))


async def call_gui(func, *args, **kwargs):
    global _call_gui_tag
    _call_gui_tag += 1
    tag = _call_gui_tag
    fut = arun.new_future()
    _call_gui[tag] = (func, args, kwargs, fut)
    _call_comm.gui.emit(tag)
    return await fut


_ev = threading.Event()


async def _init_fi():
    _ev.set()


def _run_serv():
    _loop = asyncio.new_event_loop()
    asyncio.set_event_loop(_loop)
    arun.append_init(_init_fi())
    arun.run(loglevel=logging.WARNING, forever=True)


def op_init():
    global _serv_thread
    assert(_serv_thread is None)
    _serv_thread = threading.Thread(name='serv_thread', target=_run_serv)
    _serv_thread.daemon = False
    _serv_thread.start()
    _ev.wait()


def op_exit():
    arun.post_exit()
