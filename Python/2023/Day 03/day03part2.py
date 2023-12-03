f = open("input.txt", "r")
lines = f.readlines()
lines = [line.rstrip('\n') for line in lines]

gearcount = [[0 for i in range(len(lines[0]))] for j in range(len(lines))]
gearratio = [[1 for i in range(len(lines[0]))] for j in range(len(lines))]

def check_for_gear(x,y,length,num):
    surrounding = []
    for x_off in range(-1,length+1):
        surrounding.append([x_off,-1])
        surrounding.append([x_off,1])
    surrounding.append([length,0])
    surrounding.append([-1,0])

    for offset in surrounding:
        checkx = x + offset[0]
        checky = y + offset[1]
        if checkx >= 0 and checkx < len(lines[0]) and checky >= 0 and checky < len(lines):
            checkchar = lines[checky][checkx]
            if checkchar == '*':
                gearcount[checkx][checky] += 1
                gearratio[checkx][checky] *= num
                #print(checkx, checky, gearcount[checkx][checky], gearratio[checkx][checky])
                #print(gearcount)

for y in range(len(lines)):
    line = lines[y]
    num = 0
    in_num = False
    for x in range(len(line)):
        char = line[x]
        if not in_num:
            if char.isdigit():
                startx = x
                length = 1
                num = int(char)
                in_num = True
        else:
            if char.isdigit():
                num *= 10
                num += int(char)
                length += 1
            if not char.isdigit() or x == len(line)-1:
                check_for_gear(startx,y,length,num)
                num = 0
                length = 0
                in_num = False
        

gearratiototal = 0

for y in range(len(lines)):
    for x in range(len(lines[0])):
        if gearcount[x][y] == 2:
            #print(x, y, gearratio[x][y])
            gearratiototal += gearratio[x][y]

print(gearratiototal)
#print(gearcount)
#print(gearratio)