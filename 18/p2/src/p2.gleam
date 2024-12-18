import gleam/bool
import gleam/deque.{type Deque}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/set.{type Set}
import gleam/string
import simplifile as file

pub type Map =
  List(List(Bool))

pub fn main() {
  let assert Ok(contents) = file.read("../1.in")

  let map = case parse(contents) {
    Ok(map) -> map
    Error(_) -> []
  }
  let l = 0
  let r = map |> list.length
  let ans = bi_search(l, r, l, map)
  io.debug(map |> list.at(ans))
}

fn bi_search(l: Int, r: Int, ans: Int, map: List(Point)) -> Int {
  let m = 71
  let n = 71
  case l <= r {
    False -> ans
    True -> {
      let mid = int.add(l, r) / 2
      let mp = take(mid, map)
      let q = deque.new() |> deque.push_back(#(#(0, 0), 0))
      let seen = set.new()
      let goal = #(m - 1, n - 1)

      let dist = search(q, seen, goal, m, n, mp)
      io.debug(mp |> list.length())
      io.debug(dist)
      case dist {
        Some(_) -> bi_search(mid + 1, r, ans, map)
        None -> bi_search(l, mid - 1, mid, map)
      }
    }
  }
}

fn search(
  q: Deque(#(Point, Int)),
  seen: Set(Point),
  goal: Point,
  m: Int,
  n: Int,
  map: List(Point),
) -> option.Option(Int) {
  case deque.pop_front(q) {
    Error(_) -> None
    Ok(#(#(point, dist), q)) -> {
      case point == goal {
        True -> Some(dist)
        False -> {
          case set.contains(seen, point) {
            True -> search(q, seen, goal, m, n, map)
            False -> {
              let seen = set.insert(seen, point)
              get_neighbors(point, m, n, map)
              |> list.map(fn(p) { #(p, dist + 1) })
              |> list.fold(q, fn(acc, x) { deque.push_back(acc, x) })
              |> search(seen, goal, m, n, map)
            }
          }
        }
      }
    }
  }
}

pub fn get_neighbors(
  current: Point,
  m: Int,
  n: Int,
  map: List(Point),
) -> List(Point) {
  let #(x, y) = current
  let possible_neighbors = [#(x + 1, y), #(x - 1, y), #(x, y + 1), #(x, y - 1)]

  possible_neighbors
  |> list.filter(fn(neighbor) {
    let #(nx, ny) = neighbor
    inbound(nx, ny, m, n) && bool.negate(is_obstacle(nx, ny, map))
  })
}

pub type Point =
  #(Int, Int)

pub fn is_obstacle(x: Int, y: Int, map: List(Point)) -> Bool {
  case
    list.find(map, fn(point) {
      case point {
        #(nx, ny) -> nx == x && ny == y
      }
    })
  {
    Ok(_) -> True
    Error(_) -> False
  }
}

pub fn inbound(x: Int, y: Int, m: Int, n: Int) -> Bool {
  x >= 0 && x < m && y >= 0 && y < n
}

pub fn take(s: Int, map: List(#(Int, Int))) -> List(#(Int, Int)) {
  case s {
    0 -> []
    _ ->
      case map {
        [] -> []
        [x, ..xs] -> [x, ..take(s - 1, xs)]
      }
  }
}

pub fn parse(input: String) -> Result(List(#(Int, Int)), String) {
  input
  |> string.split("\n")
  |> list.filter(fn(s) { s |> string.is_empty() |> bool.negate() })
  |> list.try_map(parse_line)
}

fn parse_line(line: String) -> Result(#(Int, Int), String) {
  let parts =
    line
    |> string.split(",")
    |> list.map(fn(x) {
      case int.parse(x) {
        Ok(a) -> a
        Error(Nil) -> 0
      }
    })

  case parts {
    [f, s] -> Ok(#(f, s))
    _ -> Error("error format")
  }
}