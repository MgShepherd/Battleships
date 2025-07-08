const std = @import("std");

const GameState = @This();

pub const GameStateError = error{ OutOfMemory, RenderTextFailed };

const GRID_DIM_SIZE = 10;

grid: []u8,
alloc: std.mem.Allocator,

pub fn init(alloc: std.mem.Allocator) GameStateError!GameState {
    const grid = try alloc.alloc(u8, GRID_DIM_SIZE * GRID_DIM_SIZE);

    var i: usize = 0;
    while (i < GRID_DIM_SIZE * GRID_DIM_SIZE) : (i += 1) {
        grid[i] = 0;
    }

    return GameState{ .grid = grid, .alloc = alloc };
}

pub fn format(self: *const GameState, outStream: anytype) GameStateError!void {
    var x: usize = 0;
    var y: usize = 0;

    while (y < GRID_DIM_SIZE) : (y += 1) {
        x = 0;
        while (x < GRID_DIM_SIZE) : (x += 1) {
            std.fmt.format(outStream, "{d}", .{self.grid[(y * GRID_DIM_SIZE) + x]}) catch
                return GameStateError.RenderTextFailed;
        }
        std.fmt.format(outStream, "\n", .{}) catch
            return GameStateError.RenderTextFailed;
    }
}

pub fn deinit(self: *GameState) void {
    self.alloc.free(self.grid);
}
