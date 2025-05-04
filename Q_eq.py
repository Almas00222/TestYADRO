def Q_eq(a, b, c, d):
    return ((a - b) * (1 + 3 * c) - 4 * d) // 2

test_cases = [
    (10, 5, 2, 3),
    (20, 8, 1, 5),
    (0, 0, 0, 0),
    (-5, 10, 3, -2),
    (100, 50, -1, 10),
    (32767, 1, 0, 0),
    (-32768, 0, 0, 0),
    (1000, 500, 100, 200)
]

for i, (a, b, c, d) in enumerate(test_cases):
    result = Q_eq(a, b, c, d)
    print(f"Test {i+1}: \n Input: a={a}, b={b}, c={c}, d={d} \n Result: Q={result}")

print("!SUCCESSFUL!")
