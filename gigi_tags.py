_GIGI_MAX_TAG = 0x1000000000000  # 49 bits
_gigi_tag = 0
_gigi_tags = {}


def _gigi_pushval(*val):
    global _gigi_tag
    if _gigi_tag > _GIGI_MAX_TAG:
        _gigi_tag = 0
    else:
        _gigi_tag += 1
    _gigi_tags[_gigi_tag] = val
    return _gigi_tag


def _gigi_popval(tag):
    return _gigi_tags.pop(tag, [None])
