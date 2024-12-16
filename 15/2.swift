import Foundation

let path = "1.in"

let dir = [0, 1, 0, -1, 0]

func find_robot(map: [[Character]]) -> (Int, Int) {
  for (posX, line) in map.enumerated() {
    for (posY, cell) in line.enumerated() where cell == "@" {
      return (posX, posY)
    }
  }
  return (-1, -1)
}

func print_map(map: [[Character]]) {
  for line in map {
    for cell in line {
      print("\(cell)", terminator: "")
    }
    print("")
  }
  print("")
}

func get_dir(cmd: Character) -> Int {
  var res = 0
  switch cmd {
  case ">":
    res = 0
  case "v":
    res = 1
  case "<":
    res = 2
  case "^":
    res = 3

  default: res = -1
  }
  return res
}

struct Point: Hashable {
  let x: Int
  let y: Int
}

func get_next_line(map: [[Character]], line: Set<Point>, direction: Int) -> Set<Point> {
  var nextLine = Set<Point>()
  for p in line {
    let x = p.x
    let y = p.y
    if map[x][y] == "." {
      continue
    }
    let dx = x + dir[direction]
    let dy = y + dir[direction + 1]

    if map[dx][dy] == "[" {
      nextLine.insert(Point(x: dx, y: dy))
      nextLine.insert(Point(x: dx, y: dy + 1))
    } else if map[dx][dy] == "]" {
      nextLine.insert(Point(x: dx, y: dy))
      nextLine.insert(Point(x: dx, y: dy - 1))
    } else {
      nextLine.insert(Point(x: dx, y: dy))
    }
  }
  return nextLine
}

func is_box(x: Int, y: Int, map: [[Character]]) -> Bool {
  if map[x][y] == "[" || map[x][y] == "]" {
    return true
  }
  return false
}

func all_box(line: [(Int, Int)], map: [[Character]]) -> Bool {
  for (x, y) in line {
    if !is_box(x: x, y: y, map: map) {
      return false
    }
  }
  return !line.isEmpty
}

func is_dot(x: Int, y: Int, map: [[Character]]) -> Bool {
  if map[x][y] == "." {
    return true
  }
  return false
}

func all_dot(line: Set<Point>, map: [[Character]]) -> Bool {
  for p in line {
    let x = p.x
    let y = p.y
    if !is_dot(x: x, y: y, map: map) {
      return false
    }
  }
  return true
}
func is_wall(x: Int, y: Int, map: [[Character]]) -> Bool {
  if map[x][y] == "#" {
    return true
  }
  return false
}

func has_wall(line: Set<Point>, map: [[Character]]) -> Bool {
  for p in line {
    let x = p.x
    let y = p.y
    if is_wall(x: x, y: y, map: map) {
      return true
    }
  }
  return false
}

do {
  let contents = try NSString(contentsOfFile: path, encoding: String.Encoding.ascii.rawValue)
  let parts = contents.components(separatedBy: "\n\n")

  var width_map = parts[0].replacingOccurrences(of: "O", with: "[]")
  width_map = width_map.replacingOccurrences(of: "#", with: "##")
  width_map = width_map.replacingOccurrences(of: ".", with: "..")
  width_map = width_map.replacingOccurrences(of: "@", with: "@.")
  var map = width_map.components(separatedBy: "\n").map { Array($0) }

  // print_map(map: map)
  let cmds = parts[1].replacingOccurrences(of: "\n", with: "")

  // find @
  var (posx, posy) = find_robot(map: map)
  // print("\(posx) \(posy)")

  for cmd in cmds {
    // print("\(cmd)")
    let front = get_dir(cmd: cmd)
    if front == -1 {
      continue
    }

    //< and  >
    if front % 2 == 0 {
      var dx = posx + dir[front]
      var dy = posy + dir[front + 1]

      while is_box(x: dx, y: dy, map: map) {
        dx += dir[front]
        dy += dir[front + 1]
      }
      if map[dx][dy] == "#" {
        // print_map(map: map)
        continue
      }
      while dx != posx || dy != posy {
        map[dx][dy] = map[dx - dir[front]][dy - dir[front + 1]]

        dx -= dir[front]
        dy -= dir[front + 1]
      }
      map[posx][posy] = "."
      posx += dir[front]
      posy += dir[front + 1]
    } else {
      var q = [Set<Point>]()
      var cur_line: Set<Point> = [Point(x: posx, y: posy)]
      q.append(cur_line)

      var next_line = get_next_line(map: map, line: cur_line, direction: front)
      while !next_line.isEmpty && !has_wall(line: next_line, map: map) {
        print(next_line)
        q.append(next_line)
        cur_line = next_line
        next_line = get_next_line(map: map, line: cur_line, direction: front)
      }
      if has_wall(line: next_line, map: map) {
        // print_map(map: map)
        continue
      }
      print(q.count)
      for i in (1..<q.count).reversed() {
        for p in q[i] {
          let x = p.x
          let y = p.y
          let newX = x - dir[front]
          let newY = y - dir[front + 1]
          if q[i - 1].contains(Point(x: newX, y: newY)) {
            map[x][y] = map[newX][newY]
          } else {
            map[x][y] = "."
          }
        }
      }
      map[posx][posy] = "."
      posx += dir[front]
      posy += dir[front + 1]
    }
    // print_map(map: map)
  }

  var ans = 0

  for (posX, line) in map.enumerated() {
    for (posY, cell) in line.enumerated() where cell == "[" {
      ans += posX * 100 + posY
    }
  }
  // print_map(map: map)
  print("\(ans)")

} catch {
  print("Error reading file: \(error)")
}
