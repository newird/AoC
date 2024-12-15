const std = @import("std");

const Robot = struct {
    pos: [2]i32,
    vel: [2]i32,
};

pub fn main() !void {
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
        var parts = std.mem.split(u8, line, " ");
        var part1 = parts.next() orelse continue;
        var part2 = parts.next() orelse continue;

        part1 = part1[2..];
        var pos_splits = std.mem.split(u8, part1, ",");
        const x = try std.fmt.parseInt(i32, pos_splits.next() orelse continue, 10);
        const y = try std.fmt.parseInt(i32, pos_splits.next() orelse continue, 10);

        part2 = part2[2..];
        var v = std.mem.split(u8, part2, ",");
        const dx = try std.fmt.parseInt(i32, v.next() orelse continue, 10);
        const dy = try std.fmt.parseInt(i32, v.next() orelse continue, 10);

        try robots.append(Robot{
            .pos = .{ x, y },
            .vel = .{ dx, dy },
        });
    }

    const width: i32 = 101;
    const height: i32 = 103;

    // I just find the XMAS tree by hand before
    // but I get the idea that if not robot colapse there will be the answer
    // I wonder why , but it workd
    for (0..10404) |s| {
        const t: i32 = @intCast(s);
        var positions = std.AutoHashMap([2]i32, void).init(allocator);
        defer positions.deinit();
        var valid = true;

        for (robots.items) |robot| {
            const new_x = @mod(robot.pos[0] + t * robot.vel[0], width);
            const new_y = @mod(robot.pos[1] + t * robot.vel[1], height);
            const new_pos = [2]i32{ new_x, new_y };

            if (positions.contains(new_pos)) {
                valid = false;
                break;
            }
            try positions.put(new_pos, {});
        }

        if (valid) {
            std.debug.print("{d}\n", .{t});
            var y: i32 = 0;
            while (y < height) : (y += 1) {
                var x: i32 = 0;
                while (x < width) : (x += 1) {
                    const pos = [2]i32{ x, y };
                    if (positions.contains(pos)) {
                        std.debug.print("@", .{});
                    } else {
                        std.debug.print(" ", .{});
                    }
                }
                std.debug.print("\n", .{});
            }
            break;
        }
    }
}
