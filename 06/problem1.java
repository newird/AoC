import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;

public class problem1 {

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
    return new int[] {};
  }

  static int[] dir = new int[] { 1, 0, -1, 0, 1 };

  public static void main(String[] args) {
    try {
      BufferedReader br = new BufferedReader(new FileReader("2.in"));
      ArrayList<StringBuilder> lines = new ArrayList<>();
      String line = br.readLine();
      while (line != null) {
        lines.add(new StringBuilder(line));
        line = br.readLine();
      }

      int m = lines.size(), n = lines.get(0).length();
      int[] res = getlocation(lines);
      int x = res[0], y = res[1], k = res[2];
      int ans = 1;

      lines.get(x).setCharAt(y, 'X');
      while (true) {
        int dx = x + dir[k], dy = y + dir[k + 1];
        char c = lines.get(dx).charAt(dy);
        if (c == '#') {
          k = (k + 1) % 4;
          continue;
        } else if (c == '.') {
          lines.get(dx).setCharAt(dy, 'X');
          ans += 1;
        }
        if (dx == 0 || dx == m - 1 || dy == 0 || dy == n - 1) {
          break;
        }
        x = dx;
        y = dy;
      }
      System.out.println(ans);
    } catch (Exception e) {
      System.out.println(e);
    }
  }
}
