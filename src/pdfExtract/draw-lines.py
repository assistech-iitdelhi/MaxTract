import matplotlib.pyplot as plt
import pdb
import sys

for line in sys.stdin:
    points = line.strip().split(',')
    if len(points) == 4:
        points = [float(i) for i in points]
        print(points)
        plt.plot((points[0], points[2]), (points[1], points[3]))
plt.savefig(sys.argv[1])
