internal import std.fs.*
import std.collection.*
internal import std.math.*

let dir = [1, 0, -1, 0, 1]
var cnt = 0

//let s = 'E#S.' [69 , 35, 83 , 46]
func find_start(map: Array<String>) {
    for (i in 0..map.size) {
        for (j in 0..map[i].size) {
            // 83 stands for 'S' , I know this is stupid
            // I don't know how to cast type
            if (map[i][j] == 83) {
                return (i, j)
            }
        }
    }
    return (-1, -1)
}

func find_end(map: Array<String>) {
    for (i in 0..map.size) {
        for (j in 0..map[i].size) {
            if (map[i][j] == 69) {
                return (i, j)
            }
        }
    }
    return (-1, -1)
}

struct State {
    let x: Int64
    let y: Int64
    let d: Int64
    public init(x: Int64 , y : Int64 , d : Int64) {
        this.x = x
        this.y = y
        this.d = d
      }
  }

// copyright by https://blog.csdn.net/liuliangcan/article/details/143969861
class MinHeap<T> <: Collection<T> where T <: MyLess<T> {
    public prop size: Int {
        get() {
            h.size
        }
    }
    protected var h = ArrayList<T>()
    public init() {}
    public init(items: Collection<T>) {
        h.appendAll(items)
        for (i in (h.size / 2)..=0 : -1) {
            _siftup(i)
        }
    }
    public func isEmpty() {
        return h.isEmpty()
    }
    public func iterator() {
        throw Exception("No Iterator for MinHeap")
        // return h.iterator()
    }
    public func heappush(v: T) {
        h.append(v)
        var i = h.size - 1
        while (i > 0 && v < (h[(i - 1) >> 1])) { // 比父节点小，则上移
            h[i] = h[(i - 1) >> 1]
            i = (i - 1) >> 1
        }
        h[i] = v
    }
    public func heappop() {
        // let last = h.remove(h.size-1)
        // if (h.size == 0) {
        //     return last
        // }
        // let ret = h[0]
        // h[0] = last
        // _siftup(0)
        // return ret
        let ret = h[0]
        h[0] = h[h.size - 1]
        h.remove(h.size - 1)
        if (!h.isEmpty()) {
            _siftup(0)
        }
        return ret
    }
    public func heapreplace(v: T) { // 替换并返回堆顶
        let ret = h[0]
        h[0] = v
        _siftup(0)
        return ret
    }
    public func heappushpop(v: T) { // 把v和堆顶保留更大的那个，pop返回更小的那个；常用语保留最大的k个值（小顶堆）
        if (!h.isEmpty() && h[0] < v) {
            let ret = h[0]
            h[0] = v
            return ret
        }
        return v
    }
    private func _siftup(i: Int64) {
        // 把i位置的大值下沉，小儿子提上来
        var fa = i
        let v = h[fa]
        let n = h.size
        while ((fa << 1 | 1) < n) { // 有左儿子
            var child = fa << 1 | 1
            let right = child + 1
            if (right < n && h[right] < h[child]) {
                child = right
            }
            if (h[child] < v) {
                h[fa] = h[child] // 小的儿子上移
                fa = child // 迭代
            } else {
                break
            }
        }
        if (fa != i) { // 有变化
            h[fa] = v
        }
    }
}

interface MyLess<T> {
    operator func <(rhs: T): Bool
}

extend<T> Array<T> <: MyLess<Array<T>> where T <: Less<T> {
    public operator func <(rhs: Array<T>): Bool {
        for (i in 0..min(size, rhs.size)) {
            if (this[i] < rhs[i]) {
                return true
            } else if (rhs[i] < this[i]) {
                return false
            }
        }

        return this.size < rhs.size
    }
    // public func equals(other: Array<T>){
    //     return true
    // }
}

extend<T> MinHeap<T> <: ToString where T <: ToString {
    public func toString() {
        return h.toString()
    }
}

main() {
    let file2 = File.openRead("example")
    let bytes = file2.readToEnd()
    let strings = String.fromUtf8(bytes)
    let map = strings.split("\n")

    //    for (line in map){
    //        println(line)
    //      }

    let m = map.size
    let n = map[0].size

    let (sx, sy) = find_start(map)

    var (ex, ey, ed) = (0, 0, 0)
    var dist = Array(m, {_ => Array(n, {_ => Array<Int64>(4, {_ => Int64.Max})})})

    var from = HashMap<State , State>()
    var p = Int64.Max
    let h = MinHeap([[0, sx, sy, 3]])


    while (!h.isEmpty()) {
        let arr = h.heappop()
        let (cd, cx, cy, cdir) = (arr[0], arr[1], arr[2], arr[3])

        if (cd > dist[cx][cy][cdir]) {
            continue
        }

        if (map[cx][cy] == 69) {
            println(cd)
            break
        }

        for (i in 0..4) {
            let dx = cx + dir[i]
            let dy = cy + dir[i + 1]
            if (dx < 0 || dx >= m || dy < 0 || dy >= n || map[dx][dy] == 35) {
                continue
            }

            var nd_cost = cd
            if (i == cdir) {
                nd_cost += 1
            } else {
                nd_cost += 1001
            }
            if(nd_cost < dist[dx][dy][i] ) {
              dist[dx][dy][i] = nd_cost
              h.heappush([nd_cost, dx, dy, i])
            }else if(nd_cost <= dist[dx][dy][i] ){
            }
        }
    }


}
