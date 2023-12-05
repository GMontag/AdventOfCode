import re

f = open("input.txt", "r")
lines = f.readlines()
cardcount = [1 for i in range(len(lines))]

pointtotal = 0

for card in range(len(lines)):
    line = lines[card]
    winning = line.split('|')[0].split(':')[1]
    winning = re.findall(r'(\d+)', winning)
    numbers = line.split('|')[1]
    numbers = re.findall(r'(\d+)', numbers)
    wins = [num for num in numbers if num in winning]
    points = len(wins)
    for i in range(1,points+1):
        cardcount[card+i] += cardcount[card]

print(sum(cardcount))
