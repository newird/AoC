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

    fun border(
        i: Int,
        j: Int,
    ): Int {
        var res = 0

        for (k in 0..3) {
            val x = i + dir[k]
            val y = j + dir[k + 1]
            if (!inbound(x, y)) {
                res += 1
            } else if (content[x][y] != content[i][j]) {
                res += 1
            }
        }
        return res
    }

    fun dfs(
        i: Int,
        j: Int,
    ): Pair<Int, Int> {
        vis[i][j] = true
        var area = 1
        var perimeters = border(i, j)
        for (k in 0..3) {
            val x = i + dir[k]
            val y = j + dir[k + 1]
            if (inbound(x, y) && !vis [x][y] && content[i][j] == content[x][y]) {
                val (a, p) = dfs(x, y)
                area += a
                perimeters += p
            }
        }
        return Pair(area, perimeters)
    }

    var ans = 0
    for (i in 0..m - 1) {
        for (j in 0..n - 1) {
            if (vis[i][j] == true) {
                continue
            }

            val (a, p) = dfs(i, j)
            ans += a * p
        }
    }

    println(ans)
}

// NOTE call main function
main(emptyArray())
