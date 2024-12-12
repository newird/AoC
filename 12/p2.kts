import java.io.File
import java.io.InputStream


fun main(args: Array<String>) {
    val inputStream: InputStream = File("1.in").inputStream()
    val content: MutableList<String> = ArrayList()
    val dir = arrayOf(1, 0, -1, 0, 1)

    inputStream.bufferedReader().forEachLine { content.add(it) }

    val m = content.size
    val n = content.get(0).length

    var vis = Array(m) { Array(n) { false } }

    fun inbound(
        i: Int,
        j: Int,
    ): Boolean = (i >= 0) && (i < m) && (j >= 0) && (j < n)

    fun dfs(
        i: Int,
        j: Int,
        pointCount: Array<Array<Int>>,
    ): Long {
        vis[i][j] = true

        pointCount[i + 0][j + 0] += 1
        pointCount[i + 1][j + 0] += 1
        pointCount[i + 0][j + 1] += 1
        pointCount[i + 1][j + 1] += 1

        var area: Long = 1
        for (k in 0..3) {
            val x = i + dir[k]
            val y = j + dir[k + 1]
            if (inbound(x, y) && !vis [x][y] && content[i][j] == content[x][y]) {
                val a = dfs(x, y, pointCount)
                area += a
            }
        }
        return area
    }

    // the key idea is the number of corner has odd degree equals the number of side
    // the cornor is the dot has odd number or 'X'
    fun count(pointCount: Array<Array<Int>>): Int {
        var res = 0
        for (i in 0..m) {
            for (j in 0..n) {
                // take care of 'X' condition
                // AAABBA
                // AAABBA
                // ABBAAA
                // ABBAAA
                // AAAAAA
                if (pointCount[i][j] == 2) {
                    if (i > 0 && j > 0 && i < m && j < n) {
                        if (content[i - 1][j - 1] == content[i][j] &&
                            content[i - 1][j] != content[i][j] &&
                            content[i][j - 1] != content[i][j]
                        ) {
                            res += 2
                        } else if (content[i - 1][j] == content[i][j - 1] &&
                            content[i - 1][j - 1] != content[i - 1][j] &&
                            content[i][j] != content[i - 1][j]
                        ) {
                            res += 2
                        }
                    }
                }
                // 1 and 3 is corner
                res += pointCount[i][j] % 2
            }
        }
        return res
    }

    var pointCount = Array(m + 1) { Array(n + 1) { 0 } }
    var ans: Long = 0
    for (i in 0..m - 1) {
        for (j in 0..n - 1) {
            if (vis[i][j] == true) {
                continue
            }
            for (i in 0..m) {
                for (j in 0..n) {
                    pointCount[i][j] = 0
                }
            }
            val a = dfs(i, j, pointCount)
            val sides = count(pointCount)
            // for (line in pointCount) {
            //     for (dot in line) {
            //         print(dot)
            //     }
            //     println()
            // }
            ans += a * sides
        }
    }

    println(ans)
}

// NOTE call main function
main(emptyArray())
