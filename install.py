#!/usr/bin/env python3
import os
import sys

NOW_DIR = os.path.dirname(os.path.realpath(__file__))

for file in os.listdir(NOW_DIR + "/home/"):
    if os.path.exists(os.environ["HOME"] + "/" + file):
        os.remove(os.environ["HOME"] + "/" + file)
    os.symlink(NOW_DIR + "/home/" + file, os.environ["HOME"] + "/" + file)