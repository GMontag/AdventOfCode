import re

f = open("input.txt", "r")

max = {"red": 12, "green": 13, "blue": 14}

idtotal = 0

idregex = r"Game (\d+)"
colorregex = r"(\d+) (red|blue|green)"
for line in f:
    id = int(re.findall(idregex,line)[0])
    possible = True
    for match in re.findall(colorregex,line):
        if int(match[0]) > max[match[1]]:
            possible = False
    if possible:
        idtotal += id

print(idtotal)