import re

f = open("input.txt", "r")
lines = f.readlines()

times = re.findall(r"(\d+)", lines[0])
time = int("".join(times))
distances = re.findall(r"(\d+)", lines[1])
distance = int("".join(distances))

ways = 0
for j in range(time):
    curdist = j * (time-j)
    if curdist > distance:
        ways += 1

print(ways)