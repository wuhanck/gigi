# This Python file uses the following encoding: utf-8

import functools

import p_rpc


@p_rpc.call_remote
async def gigi_call(bus, call_to, proc_name, step, *args):
    pass


def bind_callto(bus, call_to, proc_name):
    class __inner:
        call = functools.partial(gigi_call, bus, call_to, proc_name)

    return __inner


# if__name__ == "__main__":
#     pass
