import matplotlib.pyplot as plt
import sys

for line in sys.stdin:
    points = line.strip().split(',')
    if len(points) == 4:
        points = [float(i) for i in points]
        plt.plot([points[0], points[1]], [points[2], points[3]])
        print(points)
plt.savefig('out.png')
