#!/bin/bash

Xvfb $DISPLAY -screen 0 1920x1080x24 &

python3 mesh.py 