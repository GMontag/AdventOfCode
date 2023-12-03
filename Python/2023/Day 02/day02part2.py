import re

f = open("input.txt", "r")

powertotal = 0

idregex = r"Game (\d+)"
colorregex = r"(\d+) (red|blue|green)"
for line in f:
    max = {"red": 0, "green": 0, "blue": 0}
    id = int(re.findall(idregex,line)[0])
    for match in re.findall(colorregex,line):
        if int(match[0]) > max[match[1]]:
            max[match[1]] = int(match[0])
    power = 1
    for color in max:
        power *= max[color]
    powertotal += power
print(powertotal)