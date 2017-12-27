#!/usr/bin/env python3
import os
import sys

NOW_DIR = os.path.dirname(os.path.realpath(__file__))

for file in os.listdir(NOW_DIR + "/home/"):
    os.symlink(NOW_DIR + "/home/" + file, os.environ["HOME"] + "/" + file)