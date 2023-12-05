import re

f = open("input.txt", "r")
lines = f.readlines()

blanks = [i for i, e in enumerate(lines) if e == "\n"]
previous = 0
sections = []
for blank in blanks:
    sections.append(lines[previous:blank])
    previous = blank + 1
sections.append(lines[previous:])

seeds = [int(seed) for seed in re.findall(r"(\d+)", sections[0][0])]

maps = []
for i in range(1,len(sections)):
    map = []
    for j in range(1,len(sections[i])):
        rule = sections[i][j]
        map.append([int(num) for num in re.findall(r"(\d+)", rule)])
    maps.append(map)

for map in maps:
    for i in range(len(seeds)):
        seed = seeds[i]
        matchingrule = -1
        for j in range(len(map)):
            rule = map[j]
            if seed >= rule[1] and seed < (rule[1] + rule[2]):
                matchingrule = j
        if matchingrule > -1:
            rule = map[matchingrule]
            seeds[i] = seed - (rule[1] - rule[0])

seeds.sort()
print("Part 1: " + str(seeds[0]))
