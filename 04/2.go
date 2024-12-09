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
	file_path := "2.in"
	lines, err := readLines(file_path)
	if err != nil {
		log.Fatal(err)
	}

	m := len(lines)
	n := len(lines[0])

	ans := 0

	for x := range m {
		for y := range n {

			if lines[x][y] != 'A' {
				continue
			}
			M := 0
			S := 0
			dx := 0
			dy := 0
			for i := -1; i <= 1; i += 1 {
				for j := -1; j <= 1; j += 1 {
					if i == 0 || j == 0 {
						continue
					}
					dx = x + i
					dy = y + j
					if dx < 0 || dx >= m || dy < 0 || dy >= n {
						continue
					}
					if lines[dx][dy] == 'M' {
						M += 1
					}

					if lines[dx][dy] == 'S' {
						S += 1
					}
				}
			}
			if M == 2 && S == 2 && lines[x-1][y-1] != lines[x+1][y+1] {
				ans += 1
			}

		}
	}

	fmt.Println(ans)
}
