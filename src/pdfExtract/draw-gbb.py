# draw top and left bounds for a glyph

import json
import os
import cv2
import numpy as np
import sys
import pdb

if len(sys.argv) < 4:
    print("Usage: python {} <input-image-file> <json-file> <output-image-file>".format(sys.argv[0]))
    sys.exit(1)

img  = cv2.imread(sys.argv[1])
json = json.load(open(sys.argv[2], encoding='utf-8'))

for glyph in json['glyphs']:
    h = glyph['h']
    w = glyph['w']
    x = glyph['x']
    y = glyph['y']
    img[y+np.arange(h), x] = [255, 0, 0]
    img[y, x+np.arange(w)] = [255, 0, 0]

cv2.imwrite(sys.argv[3], img)
