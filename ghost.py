#!/usr/bin/env python3

class GhostDict(dict):
    """A dict that remembers deletions."""
    
    __slots__ = ('_ghost',)
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._ghost = {}
    
    def __delitem__(self, key):
        self._ghost[key] = self[key]
        super().__delitem__(key)
    
    def recall(self, key):
        return self._ghost[key]

if __name__ == '__main__':
    gd = GhostDict(foo=18)
    gd['bar'] = 20
    print(gd)

    del gd['bar']
    print(gd)
    print(gd.recall('bar'))
