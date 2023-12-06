import re

f = open("input.txt", "r")
lines = f.readlines()

times = [int(num) for num in re.findall(r"(\d+)", lines[0])]
distances = [int(num) for num in re.findall(r"(\d+)", lines[1])]

result = 1
for i in range(len(times)):
    ways = 0
    for j in range(times[i]+1):
        distance = j * (times[i]-j)
        if distance > distances[i]:
            ways += 1
    result *= ways

print(result)