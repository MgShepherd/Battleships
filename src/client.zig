const std = @import("std");
const common = @import("common.zig");

pub fn connect() common.NetworkingError!void {
    const address = try common.getLocalhostAddress();

    const socket = std.net.tcpConnectToAddress(address) catch
        return common.NetworkingError.AddressCreationError;
    defer socket.close();

    std.debug.print("Client connected to server successfully\n", .{});

    var buffer: [32]u8 = undefined;
    const closingSignal = "Closing Connection...";
    while (true) {
        _ = socket.read(&buffer) catch
            return common.NetworkingError.AddressCreationError;
        std.debug.print("Read server message: {s}\n", .{buffer});

        if (std.mem.eql(u8, closingSignal, buffer[0..closingSignal.len])) {
            std.debug.print("Recieved signal to close connection\n", .{});
            break;
        }
    }
}
