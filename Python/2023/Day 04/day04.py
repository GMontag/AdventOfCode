import re

f = open("input.txt", "r")

pointtotal = 0

for line in f:
    winning = line.split('|')[0].split(':')[1]
    winning = re.findall(r'(\d+)', winning)
    numbers = line.split('|')[1]
    numbers = re.findall(r'(\d+)', numbers)

    wins = [num for num in numbers if num in winning]
    if len(wins) > 0:
        points = pow(2, (len(wins)-1))
        pointtotal += points

print(pointtotal)

