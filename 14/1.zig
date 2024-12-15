const Robot = struct {
    x: i32,
    y: i32,
    dx: i32,
    dy: i32,

    fn move(self: *Robot, time: i32) void {
        self.x = @mod(self.x + self.dx * time, 101);
        self.y = @mod(self.y + self.dy * time, 103);
    }
};

const std = @import("std");
pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var robots = std.ArrayList(Robot).init(allocator);
    defer robots.deinit();

    var file = try std.fs.cwd().openFile("1.in", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var numbers = std.ArrayList(i32).init(allocator);
        defer numbers.deinit();

        var it = std.mem.tokenize(u8, line, "=,pv ");
        while (it.next()) |token| {
            const num = try std.fmt.parseInt(i32, token, 10);
            try numbers.append(num);
        }

        if (numbers.items.len >= 4) {
            const robot = Robot{
                .x = numbers.items[0],
                .y = numbers.items[1],
                .dx = numbers.items[2],
                .dy = numbers.items[3],
            };
            try robots.append(robot);
        }
    }


    var quarter: [4]u64 = .{ 0, 0, 0, 0 };
    for (robots.items) |*robot| {
        robot.move(100);
        std.debug.print("{any}\n", .{robot});
        if ((robot.x == 50) or (robot.y == 51)) continue;
        var index: u32 = 0;
        if (robot.x > 50) {
            index += 2;
        }
        if (robot.y > 51) {
            index += 1;
        }
        quarter[index] += 1;
    }

    std.debug.print("{d}\n", .{prod});
}
