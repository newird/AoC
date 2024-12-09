#include <algorithm>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <ios>
#include <iostream>
#include <queue>
#include <vector>

using namespace std;

vector<int> split(string s) {
  vector<int> res;
  int a{};
  for (auto c : s) {
    if (c != ',') {
      a = a * 10 + (c - '0');
    } else {
      res.emplace_back(a);
      a = 0;
    }
  }
  res.emplace_back(a);
  return res;
}

bool check(vector<vector<int>> &g, int x, int y) {
  for (auto xx : g[x]) {
    if (xx == y) return false;
  }
  return true;
}

int main() {
  ifstream infile("2.in");
  vector<vector<int>> g(100);
  string s;

  int a, b;
  int ans{}, ans2{};

  while (getline(infile, s)) {
    if (s.find('|') == 2) {
      a = atoi(s.substr(0, 2).c_str()), b = atoi(s.substr(3, 2).c_str());
      g[a].emplace_back(b);
    } else if (s.find(',')) {
      vector<int> ar = split(s);
      int n = ar.size();
      bool f = true;
      for (int i = n - 2; i >= 0; i -= 1) {
        for (int j = n - 1; j > i; j -= 1) {
          auto x = ar[i], y = ar[j];
          if (not check(g, y, x)) {
            f = false;
            break;
          }
        }
      }
      if (f)
        ans += ar[n / 2];
      else {
        sort(ar.begin(), ar.end(), [&](const int i, const int j) {
          return find(g[i].begin(), g[i].end(), j) != g[i].end();
        });
        ans2 += ar[n / 2];
      }
    } else {
      continue;
    }
  }
  cout << ans << endl;
  cout << ans2 << endl;
  return 0;
}
