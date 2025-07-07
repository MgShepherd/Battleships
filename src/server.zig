const std = @import("std");
const common = @import("common.zig");
const NetworkMessage = @import("NetworkMessage.zig");

pub fn serve(alloc: std.mem.Allocator) common.NetworkingError!void {
    const address = try common.getLocalhostAddress();

    const listenOptions = std.net.Address.ListenOptions{
        .kernel_backlog = common.MAX_CONNECTIONS,
    };
    var server = address.listen(listenOptions) catch
        return common.NetworkingError.AddressCreationError;
    defer server.deinit();

    var numPlayers: u8 = 0;
    var connections: [common.MAX_CONNECTIONS]std.net.Server.Connection = undefined;

    while (numPlayers < common.MAX_CONNECTIONS) {
        std.debug.print("Waiting on {d} players to connect...\n", .{common.MAX_CONNECTIONS - numPlayers});

        const connection = server.accept() catch
            return common.NetworkingError.AddressCreationError;

        connections[numPlayers] = connection;

        numPlayers += 1;
    }
    std.debug.print("All players connected\n", .{});

    const exitMessage = NetworkMessage.NetworkMessage{ .EXIT = NetworkMessage.ExitMessage{} };
    const encodedMessage = try NetworkMessage.encodeMessage(&exitMessage, alloc);
    defer alloc.free(encodedMessage);

    for (&connections) |*connection| {
        _ = connection.stream.write(encodedMessage) catch
            return common.NetworkingError.AddressCreationError;

        connection.stream.close();
    }
}
