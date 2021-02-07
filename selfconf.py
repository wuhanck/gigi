import uuid

import p_rpc

from kiwi.agent.proxy import bind_callto as kiwi_bind
from orange.proxy import bind_callto as orange_bind
from melon.proxy import bind_callto as melon_bind
from kiwi.agent import redis_remote_conf


_self_id = '{}-{}'.format('gigi-0001', uuid.uuid1().hex)
_kiwi_id = 'kiwi-0001'
_orange_id = 'orange-0001'
_melon_id = 'melon-0001'
_bus = p_rpc.init(_self_id, redis_remote_conf)
_kiwi_bus = _bus
_orange_bus = _bus
_melon_bus = _bus
_kiwi = kiwi_bind(_kiwi_bus, _kiwi_id)
_orange = orange_bind(_orange_bus, _orange_id, _kiwi_id)
_melon = melon_bind(_melon_bus, _melon_id, _kiwi_id)
