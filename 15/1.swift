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

do {
  let contents = try NSString(contentsOfFile: path, encoding: String.Encoding.ascii.rawValue)
  let parts = contents.components(separatedBy: "\n\n")

  var map = parts[0].components(separatedBy: "\n").map { Array($0) }

  let cmds = parts[1].replacingOccurrences(of: "\n", with: "")

  // print("\(cmds)")
  // let height = map.count
  // let width = map.first?.count ?? 0
  // print("\(height) \(width)")

  // find @
  var (posx, posy) = find_robot(map: map)
  // print("\(posx) \(posy)")

  for cmd in cmds {
    // print("\(cmd)")
    let front = get_dir(cmd: cmd)
    if front == -1 {
      continue
    }
    var dx = posx + dir[front]
    var dy = posy + dir[front + 1]

    while map[dx][dy] == "O" {
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

    // print_map(map: map)
  }

  var ans = 0

  for (posX, line) in map.enumerated() {
    for (posY, cell) in line.enumerated() where cell == "O" {
      ans += posX * 100 + posY
    }
  }
  // print_map(map: map)
  print("\(ans)")

} catch {
  print("Error reading file: \(error)")
}
