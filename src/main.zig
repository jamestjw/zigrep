const std = @import("std");
var stdin = std.fs.File.stdin().readerStreaming(&.{});
// const stdin = std.io.getStdIn().reader();

fn stringContainsDigits(text: []const u8) bool {
    for (text) |byte| {
        if (std.ascii.isDigit(byte)) {
            return true;
        }
    }
    return false;
}

fn matchPattern(input_line: []const u8, pattern: []const u8) bool {
    // TODO: refactor this into two separate stages, parsing
    // the pattern and matching
    if (pattern.len == 0) {
        @panic("empty pattern");
    } else if (pattern.len == 1) {
        return std.mem.indexOf(u8, input_line, pattern) != null;
    } else {
        if (pattern[0] == '\\') {
            if (pattern[1] == 'd') {
                return stringContainsDigits(input_line);
            } else {
                @panic("Unhandled pattern");
            }
        } else {
            @panic("Unhandled pattern");
        }
    }
}

pub fn main() !void {
    var buffer: [1024]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 3 or !std.mem.eql(u8, args[1], "-E")) {
        std.debug.print("Expected first argument to be '-E'\n", .{});
        std.process.exit(1);
    }

    var input_buffer: [1024]u8 = undefined;
    const input_len = try stdin.read(&input_buffer);
    const input_slice = input_buffer[0..input_len];

    const pattern = args[2];
    if (matchPattern(input_slice, pattern)) {
        std.process.exit(0);
    } else {
        std.process.exit(1);
    }
}

test "match digit" {
    try std.testing.expect(matchPattern("apple123", "\\d"));
    try std.testing.expect(!matchPattern("apple", "\\d"));
}
