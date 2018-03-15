#!/bin/bash

trayer --edge top --align right --widthtype request --height 18 --tint 0x292b2e --transparent true --expand true --SetDockType false --alpha 0 && xprop -name panel -f _NET_WM_WINDOW_TYPE 32a -set _NET_WM_WINDOW_TYPE _NET_WM_WINDOW_TYPE_DOCK
