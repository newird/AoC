//> using toolkit default
import os._
import scala.collection.mutable.Map
import scala.collection.mutable.Set
val ans = Set[List[String]]()

def dfs(s: String, cur: String, mp: Map[String, List[String]], l: Int, path: List[String]): Unit =
  if l == 0 then
    if s == cur then
      ans += path.sorted
  else
    for (nxt <- mp.getOrElse(cur, List())) do
      dfs(s, nxt, mp, l - 1, nxt :: path)

@main def solve() =
  val path: Path = os.pwd / "1.in"
  val content: Seq[String] = os.read.lines(path)

  // Build adjacency list
  val mp = Map[String, List[String]]().withDefaultValue(List())
  val candi = Set[String]()

  for (line <- content) do
    val e = line.split("-")
    if e(0).startsWith("t") then candi += e(0)
    if e(1).startsWith("t") then candi += e(1)
    mp(e(0)) = mp(e(0)) :+ e(1)
    mp(e(1)) = mp(e(1)) :+ e(0)

  for (c <- candi) do
    dfs(c, c, mp, 3, List())

  println(ans.size)
