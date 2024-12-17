
package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"




literalNum :: proc (s : string ) -> i64 {
       b, err := strconv.parse_i64(s)
       return b
}

power :: proc(x : int , n : int) ->  int {
  b := x
  res : int = 1
  tempN := n
  for tempN > 0 {
    if tempN & 1 == 1 {
      res *= b
    }
    b *= b
    tempN >>= 1
  }
  return res
}



run :: proc(a: i64) -> i64 {
    b := a % 8
    b = b ~ 3
    c := a >> uint(b)
    b = b ~ 5
    b = b ~ c
    return b % 8
}

solve :: proc(instrs: [] string)  {
    if result := find(0,len(instrs), instrs); result != -1 {
      fmt.println(result)
    }
}

find :: proc(a: i64,idx : uint,  program: [] string) -> i64 {
    if idx == 0 {
        return -1
    }

    for i := 0; i < 8; i += 1 {
        new_a := a * 8 + i64(i)
        out := run(new_a)
        if literalNum(program[idx-uint(1)]) == out {
            if idx  == 1 {
                return new_a
            } else {
                if result := find(new_a, idx - uint(1), program); result != -1 {
                    return result
                }
            }
        }
    }
    return -1
}

main :: proc() {

	data, ok := os.read_entire_file("1.in", context.allocator)
	if !ok {
		return
	}
	defer delete(data, context.allocator)
	it := string(data)
	for line in strings.split_lines_iterator(&it) { if strings.has_prefix(line , "Register A:" ) {
      s := strings.split(line, ": ")[1]
       a, err := strconv.parse_int(s)
    }
    if strings.has_prefix(line , "Register B:" ) {
      s := strings.split(line, ": ")[1]
       b, err := strconv.parse_int(s)
    }
    if strings.has_prefix(line , "Register C:" ) {
      s := strings.split(line, ": ")[1]
       c, err := strconv.parse_int(s)
    }
    if strings.has_prefix(line , "Program: " ) {
      instruction := strings.split(line, ": ")[1]
      instructions := strings.split(instruction, ",")
      solve (instructions)
    }
	}

}
