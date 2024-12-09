#include <bits/stdc++.h>

#include <algorithm>
#include <array>
#include <functional>
#include <iomanip>
#include <iostream>

long long a[1000]{}, b[1000];
using namespace std;
void solve() {
  long long ans{};
  int t = 1000;
  for (int i{}; i < 1000; ++i) {
    cin >> a[i] >> b[i];
  }
  ranges::sort(a);
  ranges::sort(b);
  for (int i{}; i < 1000; ++i) {
    ans += abs(a[i] - b[i]);
  }
  cout << ans;
}
int main() {
  solve();
  return 0;
}
