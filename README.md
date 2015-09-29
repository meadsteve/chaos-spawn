ChaosSpawn
==========

Inspired by netfix's chaos monkey. This library is intended to be a low level
process based equivalent. Intended to work by replacing the ```Kernel.spawn```
with overidden ones that return processes that die at random. This should
force an app's supervision tree to actually work.
