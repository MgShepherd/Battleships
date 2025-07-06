const std = @import("std");
const common = @import("common.zig");

pub fn start() common.NetworkingError!void {
    const address = try common.getLocalhostAddress();

    const listenOptions = std.net.Address.ListenOptions{
        .kernel_backlog = common.MAX_CONNECTIONS,
    };
    var server = address.listen(listenOptions) catch
        return common.NetworkingError.AddressCreationError;
    defer server.deinit();

    std.debug.print("Listening on address: {any}...\n", .{address});
    _ = server.accept() catch
        return common.NetworkingError.AddressCreationError;

    std.debug.print("Server got connection\n", .{});
}
