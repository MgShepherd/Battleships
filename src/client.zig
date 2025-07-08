const std = @import("std");
const common = @import("common.zig");
const GameState = @import("GameState.zig");
const NetworkMessage = @import("NetworkMessage.zig");

pub fn connect(alloc: std.mem.Allocator) common.NetworkingError!void {
    const address = try common.getLocalhostAddress();

    const socket = std.net.tcpConnectToAddress(address) catch
        return common.NetworkingError.AddressCreationError;
    defer socket.close();

    std.debug.print("Client connected to server successfully\n", .{});

    var gameState = try GameState.init(alloc);
    defer gameState.deinit();

    var buffer: [32]u8 = undefined;
    var shouldExit = false;

    try gameState.format(std.io.getStdOut().writer());

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
