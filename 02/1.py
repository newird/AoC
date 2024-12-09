def main():
    n = 1000
    a = []
    for i in range(1000):
        a.append(list(map(int, input().split())))

    ans = 0
    for line in a:
        f = 1
        if line[1] > line[0]:
            for x, y in zip(line, line[1:]):
                if y - x > 3 or y - x < 1:
                    f = 0
        else:
            for x, y in zip(line[1:], line):
                if y - x > 3 or y - x < 1:
                    f = 0
        ans += f

    print(ans)


if __name__ == "__main__":
    main()
