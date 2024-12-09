def main():
    n = 1000
    a = []
    for i in range(1000):
        a.append(list(map(int, input().split())))

    ans = 0
    for line in a:
        for i in range(len(line)):
            l = line[:i] + line[i + 1 :]
            f = 1
            if l[1] > l[0]:
                for x, y in zip(l, l[1:]):
                    if y - x > 3 or y - x < 1:
                        f = 0

            else:
                for x, y in zip(l[1:], l):
                    if y - x > 3 or y - x < 1:
                        f = 0
            if f == 1:
                ans += 1
                break

    print(ans)


if __name__ == "__main__":
    main()
