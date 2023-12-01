f = open("input.txt", "r")

numnames = {
    "zero": "0",
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9"
}

total = 0
for line in f:
    firstdigit = ""
    lastdigit = ""
    for index in range(len(line)):
        if line[index].isdigit():
            firstdigit = line[index]
        for digit in numnames:
            if digit in line[:index]:
                firstdigit = numnames[digit]
        if firstdigit:
            break
    for index in reversed(range(len(line))):
        if line[index].isdigit():
            lastdigit = line[index]
        for digit in numnames:
            if digit in line[index:]:
                lastdigit = numnames[digit]
        if lastdigit:
            break
    num = firstdigit + lastdigit
    num = int(num)
    total += num

print(total)