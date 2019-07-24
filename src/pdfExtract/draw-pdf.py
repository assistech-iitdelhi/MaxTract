# draw top and left bounds for a glyph

import json
import os
import cv2
import numpy as np
import sys
import pdb

if len(sys.argv) < 3:
    print("Usage: python {} <json-from-MaxTract> <output-image-file>".format(sys.argv[0]))
    sys.exit(1)

json = json.load(open(sys.argv[1], encoding='utf-8'))
img = np.zeros((5000, 5000,3), np.uint8)
img[:] = (255, 255, 255)
for symbol in json['symbols']:
    for glyph in symbol['glyphs']:
        h = glyph['h']
        w = glyph['w']
        x = glyph['x']
        y = glyph['y']
        img[y+np.arange(h), x] = [255, 0, 0]
        img[y, x+np.arange(w)] = [255, 0, 0]

cv2.imwrite(sys.argv[2], img)
