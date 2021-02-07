'use strict'

const _map = {}
const _MAX_TAG = 0x1000000000000
var _tag = 0


const push = (...val)=>{
    if (_tag > _MAX_TAG)
        _tag = 0
    else
        _tag += 1
    _map[_tag] = val
    return _tag
}


const  pop = (tag)=>{
    const val = _map[tag]
    delete _map[tag]
    return val
}
