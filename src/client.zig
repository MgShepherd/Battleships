const std = @import("std");
const common = @import("common.zig");

pub fn connect() common.NetworkingError!void {
    const address = try common.getLocalhostAddress();

    const socket = std.net.tcpConnectToAddress(address) catch
        return common.NetworkingError.AddressCreationError;
    defer socket.close();

    std.debug.print("Client connected to server successfully\n", .{});
}
