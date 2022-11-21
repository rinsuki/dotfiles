#!/usr/bin/env python3
import os
import sys
import platform

NOW_DIR = os.path.dirname(os.path.realpath(__file__))
HOME = os.environ["HOME"]

for file in os.listdir(NOW_DIR + "/home/"):
    if os.path.exists(HOME + "/" + file):
        os.remove(HOME + "/" + file)
    os.symlink(NOW_DIR + "/home/" + file, HOME + "/" + file)

if sys.platform == "darwin":
    HOME_APPSCRIPTS = HOME + "/Library/Application Scripts/"
    appscripts_path = NOW_DIR+"/mac/appscripts/"
    for f in os.listdir(appscripts_path):
        for file in os.listdir(os.path.join(appscripts_path, f)):
            if not os.path.exists(HOME_APPSCRIPTS + f):
                os.makedirs(HOME_APPSCRIPTS + f)
            if os.path.exists(HOME_APPSCRIPTS + f + "/" + file):
                os.remove(HOME_APPSCRIPTS + f + "/" + file)
            filepath = os.path.join(appscripts_path, f, file)
            os.symlink(filepath, HOME_APPSCRIPTS + f + "/" + file)