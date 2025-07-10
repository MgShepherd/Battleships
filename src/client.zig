const std = @import("std");
const common = @import("common.zig");
const GameState = @import("GameState.zig");
const NetworkMessage = @import("NetworkMessage.zig");

const MAX_INPUT_LEN = 5;

pub fn connect(alloc: std.mem.Allocator, outWriter: anytype, inReader: anytype) common.NetworkingError!void {
    const address = try common.getLocalhostAddress();

    const socket = std.net.tcpConnectToAddress(address) catch
        return common.NetworkingError.AddressCreationError;
    defer socket.close();

    std.debug.print("Client connected to server successfully\n", .{});

    var gameState = try GameState.init(alloc);
    defer gameState.deinit();

    var buffer: [32]u8 = undefined;
    var shouldExit = false;

    try gameState.format(outWriter);
    const position = try readInputPosition(outWriter, inReader);

    std.debug.print("Entered xPos: {d}, yPos: {d}\n", .{ position.x, position.y });

    while (!shouldExit) {
        const readSize = socket.read(&buffer) catch
            return common.NetworkingError.AddressCreationError;
        shouldExit = try processMessageFromServer(&buffer, readSize);
    }
}

fn processMessageFromServer(messageBuf: []const u8, readSize: usize) common.NetworkingError!bool {
    if (readSize > 0) {
        const message = try NetworkMessage.decodeMessage(messageBuf);

        switch (message) {
            .EXIT => {
                std.debug.print("Recieved Exit signal\n", .{});
                return true;
            },
        }
    }

    return false;
}

// TODO: Fix Error handling
fn readInputPosition(outWriter: anytype, inReader: anytype) common.NetworkingError!common.Position {
    const xPos = readUserInputToInt(outWriter, inReader, "Please enter the x position of your Battleship:\n", GameState.GRID_DIM_SIZE) catch
        return common.NetworkingError.AddressCreationError;
    const yPos = readUserInputToInt(outWriter, inReader, "Please enter the y position of your Battleship:\n", GameState.GRID_DIM_SIZE) catch
        return common.NetworkingError.AddressCreationError;

    return common.Position{ .x = xPos, .y = yPos };
}

fn readUserInputToInt(outWriter: anytype, inReader: anytype, msg: []const u8, maxVal: u8) !u8 {
    _ = try outWriter.write(msg);
    var buffer: [MAX_INPUT_LEN]u8 = undefined;

    const readChars = try inReader.readUntilDelimiter(&buffer, '\n');
    const result = try std.fmt.parseInt(u8, buffer[0..readChars.len], 10);

    if (result > maxVal) {
        return common.NetworkingError.OutOfMemory;
    }

    return result;
}
