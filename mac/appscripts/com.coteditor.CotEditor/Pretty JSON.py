#!/usr/bin/python3
# %%%{CotEditorXInput=Selection}%%%
# %%%{CotEditorXOutput=ReplaceSelection}%%%
import json
import sys
json.dump(json.load(sys.stdin), sys.stdout, ensure_ascii=False, indent=4)