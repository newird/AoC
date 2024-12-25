import strutils
import tables
import strformat

let content = readFile("1.in").strip().split("\n")
let MOD = 16777216

proc calc(X: int): seq[int] =
  var x = X
  var i = 0
  var ans: seq[int] = @[]
  while i < 2000:
    ans.add(x)
    var res = x shl 6
    x = x xor res
    x = x mod MOD
    res = x shr 5
    x = x xor res
    x = x mod MOD
    res = x shl 11
    x = x xor res
    x = x mod MOD
    i = i + 1

  for i in 0..<ans.len:
   ans[i] = ans[i] mod 10
  return ans

var m: seq[Table[(int, int, int, int), int]] = @[]
var ans = 0
var i = 0
for c in content:
  let t = calc(parseInt(c))

  m.add(initTable[(int, int, int, int), int]())

  for j in 0..<t.len - 4:
    let k = (t[j+1] - t[j], t[j+2] - t[j+1], t[j+3] - t[j+2], t[j+4] - t[j+3])
    if not (m[i].hasKey(k)):
      m[i][k] = t[j+4]
  i += 1
for i in 0..<m.len:
  for k in m[i].keys:
    var tmp = 0
    for j in 0..<m.len:
      if m[j].hasKey(k):
        tmp += m[j][k]
    ans = max(ans, tmp)

echo ans
