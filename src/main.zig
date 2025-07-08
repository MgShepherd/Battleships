const std = @import("std");
const server = @import("server.zig");
const client = @import("client.zig");

const CliOptionsError = error{OutOfMemory};

const SERVER_ARG_NAME = "server";

pub fn main() !void {
    //TODO: Understand more about allocators to work out which should be used
    const alloc = std.heap.page_allocator;
    const isServer = processCliOptions(alloc);

    if (isServer) {
        try server.serve(alloc);
    } else {
        try client.connect(alloc);
    }
}

// TODO: Provide help function to explain how to use the app and improve arg parsing
fn processCliOptions(alloc: std.mem.Allocator) bool {
    var argIter = try std.process.ArgIterator.initWithAllocator(alloc);
    _ = argIter.next();

    const instanceType = argIter.next() orelse SERVER_ARG_NAME;

    if (std.mem.indexOf(u8, instanceType, SERVER_ARG_NAME) != null) {
        return true;
    }

    return false;
}
