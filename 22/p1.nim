import strutils
import tables
import strformat

let content = readFile("1.in").strip().split("\n")
let MOD = 16777216
var mp = initTable[(int, int), int]()
var ans = 0

proc calc(X, n: int): int =
  var x = X
  if n <= 0:
    return x
  if mp.hasKey((x, n)):
    return mp[(x, n)]

  var res = x shl 6
  x = x xor res
  x = x mod MOD
  res = x shr 5
  x = x xor res
  x = x mod MOD
  res = x shl 11
  x = x xor res
  x = x mod MOD

  let ans= calc(x, n - 1)
  mp[(x, n)] = ans
  return ans

for c in content:
  let t = calc(parseInt(c), 2000)
  ans += t

echo ans
