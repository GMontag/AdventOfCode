f = open("input.txt", "r")

elfs = []
calories = 0
for line in f:
    line = line.strip()
    if line:
        calories += int(line)
    else:
        elfs.append(calories)
        calories = 0

elfs.sort(reverse=True)
print("Part 1: " + str(elfs[0]))
print("Part 2: " + str(sum(elfs[0:3])))