f = open("input.txt", "r")
lines = f.readlines()
lines = [line.rstrip('\n') for line in lines]

def check_for_symbol(x,y):
    symbol = False
    surrounding = [[-1,-1],[0,-1],[1,-1],[1,0],[1,1],[0,1],[-1,1],[-1,0]]
    for offset in surrounding:
        checkx = x + offset[0]
        checky = y + offset[1]
        if checkx >= 0 and checkx < len(lines[0]) and checky >= 0 and checky < len(lines):
            checkchar = lines[checky][checkx]
            if not checkchar.isdigit() and checkchar != '.':
                symbol = True
    return symbol

parttotal = 0

for y in range(len(lines)):
    line = lines[y]
    num = 0
    adjacent = False
    for x in range(len(line)):
        char = line[x]
        if char.isdigit():
            num *= 10
            num += int(char)
            adjacent = adjacent or check_for_symbol(x,y)
        if not char.isdigit() or x == len(line)-1:
            #if num != 0:
            #    print(str(num) + " " + str(adjacent))
            if adjacent:
                parttotal += num
            adjacent = False
            num = 0

print(parttotal)