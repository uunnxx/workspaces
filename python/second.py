a = [1, 2, 3, 4, 5]


# for i in range(len(a)):
    # print(i)

d = 5

class Test():
    def tt(self, a, b):
        c = a + b
        return c


def test():
    for b in range(len(a)):
        print(b)
    # global d
    d = 88
    print(d)

test()

print(f"{d+2}")


ss = Test()
print(ss.tt(2, 2))