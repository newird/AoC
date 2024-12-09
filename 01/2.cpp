
#include <bits/stdc++.h>

#include <algorithm>
// #include <functional>
// #include <iomanip>
#include <iostream>
#include <unordered_map>

long long a[1000]{}, b[1000];
using namespace std;
void solve() {
  long long ans{};
  int t = 1000;
  for (int i{}; i < 1000; ++i) {
    cin >> a[i] >> b[i];
  }
  unordered_map<long long, int> c1, c2;
  for (auto c : a) {
    c1[c]++;
  }
  for (auto c : b) {
    c2[c]++;
  }
  for (auto [k, v] : c1) {
    ans += k * v * c2[k];
  }
  cout << ans << endl;
}
int main() {
  solve();
  return 0;
}
