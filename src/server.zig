const std = @import("std");
const common = @import("common.zig");

pub fn serve() common.NetworkingError!void {
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

        connection.stream.writeAll("Testing...\n") catch
            return common.NetworkingError.AddressCreationError;

        connections[numPlayers] = connection;

        numPlayers += 1;
    }
    std.debug.print("All players connected\n", .{});

    for (&connections) |*connection| {
        std.debug.print("Closing connection\n", .{});
        _ = connection.stream.writeAll("Closing Connection...") catch
            return common.NetworkingError.AddressCreationError;
        connection.stream.close();
    }
}
