import time
def lineManage(remaining, waiting):
    if remaining >= waiting:
        group = True
    elif remaining < waiting:
        group = False
    return group

remain, wait = map(int,input().split())
group_judgement = lineManage(remain, wait)
FCFS = False # First Come First Served
cnt = 0

if group_judgement:
    print("그룹 입장")
else:
    print(remain,"명 개인 입장")