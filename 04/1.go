package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func readLines(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}

func main() {
	file_path := "1.in"
	lines, err := readLines(file_path)
	if err != nil {
		log.Fatal(err)
	}

	m := len(lines)
	n := len(lines[0])

	ans := 0

	target := "XMAS"
	for x := range m {
		for y := range n {
			if lines[x][y] != 'X' {
				continue
			}
			for i := -1; i <= 1; i += 1 {
				for j := -1; j <= 1; j += 1 {
					if i == 0 && j == 0 {
						continue
					}
					f := true
					dx := x
					dy := y
					for k := range 3 {
						dx = dx + i
						dy = dy + j
						if dx < m && dx >= 0 && dy < n && dy >= 0 {
							if lines[dx][dy] != target[k+1] {
								f = false
								break
							}
							fmt.Printf("cur %c target %c\t", lines[dx][dy], target[k+1])

						} else {
							f = false
							break
						}
					}
					if f {
						ans += 1
					}
					fmt.Println()
				}
			}
		}
	}

	fmt.Println(ans)
}
