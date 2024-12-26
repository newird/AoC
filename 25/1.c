#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int locks[4000][5] = {0};
int keys[4000][5] = {0};
int lock_cnt = 0;
int key_cnt = 0;

bool check(int i, int j) {
  for (int k = 0; k < 5; k += 1) {
    if (keys[i][k] + locks[j][k] > 5) return false;
  }
  return true;
}

void process_block(char* block) {
  // puts(block);
  char lines[7][5];
  int len = strlen(block);
  int line = 0;
  int pos = 0;

  for (int i = 0; i < len; i += 1) {
    if (block[i] == '\n') {
      line += 1;
      pos = 0;
    } else {
      lines[line][pos] = block[i];
      pos += 1;
    }
  }
  if (lines[0][0] == '#') {
    for (int i = 0; i < 5; ++i) {
      int k = 1;
      while (k < line && lines[k][i] == '#') {
        k += 1;
      }
      locks[lock_cnt][i] = k - 1;
    }
    lock_cnt += 1;
  } else {
    for (int i = 0; i < 5; ++i) {
      int k = 1;
      while (k < line && lines[k][i] == '.') {
        k += 1;
      }
      keys[key_cnt][i] = 6 - k;
    }
    key_cnt += 1;
  }
}

int main() {
  char* buf = 0;
  long length;
  FILE* f = fopen("example", "rb");

  if (f) {
    fseek(f, 0, SEEK_END);
    length = ftell(f);
    fseek(f, 0, SEEK_SET);
    buf = malloc(length + 1);
    if (buf) {
      fread(buf, 1, length, f);
      buf[length] = '\0';
    }
    fclose(f);
  }

  char* current = buf;
  char* next;
  while (current && *current) {
    next = strstr(current, "\n\n");
    if (next) {
      *next = '\0';
      process_block(current);
      current = next + 2;
    } else {
      process_block(current);
      break;
    }
  }

  free(buf);

  int ans = 0;
  for (int i = 0; i < key_cnt; i += 1) {
    for (int j = 0; j < lock_cnt; j += 1) {
      if (check(i, j)) ans += 1;
    }
  }

  printf("%d\n", ans);
  return 0;
}
