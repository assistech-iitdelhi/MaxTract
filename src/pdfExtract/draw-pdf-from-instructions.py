# draw figures from an uncompressed pdf stream
import re
import matplotlib.pyplot as plt
import os
import cv2
import numpy as np
import sys
import pdb

if len(sys.argv) < 2:
    print("Usage: python {} <output-image-file>".format(sys.argv[0]))
    sys.exit(1)

img = np.zeros((5000, 5000,3), np.uint8)
img[:] = (255, 255, 255)
for line in sys.stdin:
    if re.match("\d+ \d+ m", line):
        m = re.match("(\d+) (\d+) m", line)
        fromX, fromY = int(m.group(1)), int(m.group(2))
        srcX, srcY = fromX, fromY
    elif re.match("\d+ \d+ l", line):
        m = re.match("(\d+) (\d+) l", line)
        toX, toY = int(m.group(1)), int(m.group(2))
        plt.plot((fromX, toX), (fromY, toY))
        print(f"{fromX}, {fromY}, {toX}, {toY}")
        fromX, fromY = toX, toY
    elif re.match("h", line):
        plt.plot((fromX, srcX), (fromY, srcY))
        print(f"{fromX}, {fromY}, {srcX}, {srcY}")
    #elif re.match("\d+ \d+ \d+ \d+ re", line):
    #    m = re.match("(\d+) (\d+) (\d+) (\d+) re", line)
    #    x, y, w, h = int(m.group(1)), int(m.group(2)), int(m.group(3)), int(m.group(4))
    #    plt.plot((x, y), (x+w, y))
    #    plt.plot((x+w, y), (x+w, y+h))
    #    plt.plot((x+w, y+h), (x, y+h))
    #    plt.plot((x, y+h), (x, y))

plt.savefig(sys.argv[1])
