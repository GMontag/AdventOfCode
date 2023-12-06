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
seeds = [seeds[x:x+2] for x in range(0,len(seeds),2)]
for seed in seeds:
    seed[1] = seed[0] + seed[1] - 1

maps = []
for i in range(1,len(sections)):
    map = []
    for j in range(1,len(sections[i])):
        rule = sections[i][j]
        rule = [int(num) for num in re.findall(r"(\d+)", rule)]
        rule = [rule[1], rule[1] + rule[2] - 1, rule[0] - rule[1]]
        map.append(rule)
    maps.append(map)

for map in maps:
    newseeds = []
    for rule in map:
        seedsleft = []
        for seed in seeds:
            

