f = open("input.txt", "r")

total = 0
for line in f:
    nums = ""
    for character in line:
        if character.isdigit():
            nums += character

    num = nums[0] + nums[-1]
    num = int(num)
    total += num

print(total)