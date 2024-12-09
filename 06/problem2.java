import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;

public class problem2 {

  public static int[] getlocation(ArrayList<StringBuilder> lines) {
    int m = lines.size();
    int n = lines.get(0).length();
    int x = 0, y = 0;
    for (x = 0; x < m; x++) {
      for (y = 0; y < n; y++) {
        char ch = lines.get(x).charAt(y);
        switch (ch) {
          case '>':
            return new int[] { x, y, 3 };
          case 'v':
            return new int[] { x, y, 0 };
          case '<':
            return new int[] { x, y, 1 };
          case '^':
            return new int[] { x, y, 2 };
        }
      }
    }
    return new int[] { 0, 0, 0 };
  }

  static int[] dir = new int[] { 1, 0, -1, 0, 1 };

  static boolean is_loop(int x, int y, int k, ArrayList<StringBuilder> lines) {
    int m = lines.size(), n = lines.get(0).length();
    HashSet<String> s = new HashSet<>();
    while (true) {
      int dx = x + dir[k], dy = y + dir[k + 1];
      char c = lines.get(dx).charAt(dy);
      if (c == '#') {
        k = (k + 1) % 4;
        continue;
      }
      String state = dx + "," + dy + "," + k;
      if (s.contains(state)) {
        System.out.println("loop");
        return true;
      } else {
        s.add(state);
      }
      if (dx == 0 || dx == m - 1 || dy == 0 || dy == n - 1) {
        return false;
      }
      x = dx;
      y = dy;
    }
  }

  public static void main(String[] args) {
    try {
      BufferedReader br = new BufferedReader(new FileReader("1.in"));
      ArrayList<StringBuilder> lines = new ArrayList<>();
      String line = br.readLine();

      while (line != null) {
        lines.add(new StringBuilder(line));
        line = br.readLine();
      }

      int m = lines.size(), n = lines.get(0).length();
      int ans = 0;
      int[] res = getlocation(lines);
      int x = res[0], y = res[1], k = res[2];

      for (int i = 0; i < m; i += 1) {
        for (int j = 0; j < n; j += 1) {
          if (i == x && y == j)
            continue;

          if (lines.get(i).charAt(j) == '#')
            continue;

          lines.get(i).setCharAt(j, '#');
          if (is_loop(x, y, k, lines)) {
            ans += 1;
          }
          lines.get(i).setCharAt(j, '.');
        }
      }

      System.out.println(ans);
    } catch (Exception e) {
      System.out.println(e);
    }
  }
}
