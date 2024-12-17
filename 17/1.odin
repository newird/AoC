package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"



getNumValue :: proc(str : string) -> int {
  num: int

    if str == "0" {
        num = 0
    } else if str == "1" {
        num = 1
    } else if str == "2" {
        num = 2
    } else if str == "3" {
        num = 3
    } else if str == "4" {
        num = A
    } else if str == "5" {
        num = B
    } else if str == "6" {
        num = C
    } else {
        assert(false)
       num = -1
    }
    return num
}

literalNum :: proc (s : string ) -> int {
       b, err := strconv.parse_int(s)
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

A : int = 0 ;
B : int = 0 ;
C : int = 0 ;
pc : int = 0;

run :: proc(insts : []string) {
  n := len(insts)

  outputs :int = 0
  for pc < n {
    op := insts[pc]

//The adv instruction (opcode 0) performs division.
//The numerator is the value in the A register.
//The denominator is found by raising 2 to the power of the instruction's combo operand.
//(So, an operand of 2 would divide A by 4 (2^2); an operand of 5 would divide A by 2^B.)
//The result of the division operation is truncated to an integer and then written to the A register.
    if op == "0" {
    num := getNumValue(insts[pc + 1])
      A = A / power(2 , num)

//The bxl instruction (opcode 1) calculates the bitwise XOR of register B and the instruction's literal operand,
//then stores the result in register B.
    } else if op == "1" {
    num := literalNum(insts[pc + 1])
      B ~=  num
//The bst instruction (opcode 2) calculates the value of its combo operand modulo 8
//(thereby keeping only its lowest 3 bits),
//then writes that value to the B register.
    } else if op == "2" {
    num := getNumValue(insts[pc + 1])
      B = num % 8
//The jnz instruction (opcode 3) does nothing if the A register is 0.
//However, if the A register is not zero,
//it jumps by setting the instruction pointer to the value of its literal operand;
//if this instruction jumps, the instruction pointer is not increased by 2 after this instruction.
    } else if op == "3" {
    num := literalNum(insts[pc + 1])
       if A != 0 {
         pc = num - 2
       }
//The bxc instruction (opcode 4) calculates the bitwise XOR of register B and register C,
       //then stores the result in register B.
       //(For legacy reasons, this instruction reads an operand but ignores it.)
    } else if op == "4" {
      B ~= C
//The out instruction (opcode 5) calculates the value of its combo operand modulo 8,
//then outputs that value. (If a program outputs multiple values, they are separated by commas.)
    } else if op == "5" {
    num := getNumValue(insts[pc + 1])
      if outputs != 0 {
        fmt.print(",")
      }
      outputs = 1
      fmt.print(num % 8)
//The bdv instruction (opcode 6) works exactly like the adv instruction
//except that the result is stored in the B register.
//(The numerator is still read from the A register.)
    } else if op == "6" {
    num := getNumValue(insts[pc + 1])
      B = A / power(2 , num)
//The cdv instruction (opcode 7) works exactly like the adv instruction
//except that the result is stored in the C register. (The numerator is still read from the A register.)
    } else {
    num := getNumValue(insts[pc + 1])
      C = A / power(2 , num)
    }
    pc = pc + 2
  }
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
       A = a
    }
    if strings.has_prefix(line , "Register B:" ) {
      s := strings.split(line, ": ")[1]
       b, err := strconv.parse_int(s)
       B = b
    }
    if strings.has_prefix(line , "Register C:" ) {
      s := strings.split(line, ": ")[1]
       c, err := strconv.parse_int(s)
       C = c
    }
    if strings.has_prefix(line , "Program: " ) {
      instruction := strings.split(line, ": ")[1]
      instructions := strings.split(instruction, ",")
      run(instructions)
    }
	}

}
