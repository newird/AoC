//> using toolkit default
import scala.collection.mutable.ListBuffer
import scala.collection.mutable.Map
import os._

var ans = 0
var n = 0
var cn = 0
var x: Array[Boolean] = Array()
var bestX: Array[Boolean] = Array()
var g: Array[Array[Boolean]] = Array()

def dfs(i: Int): Unit =
  if i >= n then
    // for (c <- 0 until n if x(c) ) do
    //   println(c)
    if cn > ans then
      bestX = x.clone()
      ans = cn
    return

  var ok = true
  for (j <- 0 to i if ok) do
    if x(j) && !g(i)(j) then
      ok = false

  if ok then
    cn += 1
    x(i) = true
    dfs(i + 1)
    cn -= 1
    x(i) = false

  if n - i > ans - cn then
    dfs(i + 1)

@main def solve() =
  val path: Path = os.pwd / "1.in"
  val content: Seq[String] = os.read.lines(path)

  val mp = Map[String, Int]()
  var index = 0

  for (line <- content) do
    val e = line.split("-")
    if !mp.contains(e(0)) then
      mp(e(0)) = index
      index += 1
    if !mp.contains(e(1)) then
      mp(e(1)) = index
      index += 1

  // for ((k,v) <- mp ) do
  //   println(k + " " +  v)
  n = index
  g = Array.fill(n, n)(false)
  x = Array.fill(n)(false)

  for (line <- content) do
    val e = line.split("-")
    g(mp(e(0)))(mp(e(1))) = true
    g(mp(e(1)))(mp(e(0))) = true

  dfs(0)
  val mr = mp.map(_.swap)

  var res = ListBuffer[String]()
  for (c <- 0 until n if bestX(c)) do
    res += mr(c)


  println(res.sorted.mkString(","))
