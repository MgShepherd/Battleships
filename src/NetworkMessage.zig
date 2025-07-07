const common = @import("common.zig");
const std = @import("std");

pub const MessageType = enum(u8) { EXIT };

pub const MessageError = error{ UnsupportedMsgType, OutOfMemory };

pub const ExitMessage = struct {};

pub const NetworkMessage = union(MessageType) {
    EXIT: ExitMessage,
};

pub fn encodeMessage(msg: *const NetworkMessage, alloc: std.mem.Allocator) MessageError![]const u8 {
    switch (msg.*) {
        .EXIT => return encodeExitMessage(alloc),
    }
}

pub fn decodeMessage(bytes: []const u8) MessageError!NetworkMessage {
    const mtype = std.meta.intToEnum(MessageType, bytes[0]) catch return MessageError.UnsupportedMsgType;
    switch (mtype) {
        .EXIT => return decodeExitMessage(),
    }
}

fn encodeExitMessage(alloc: std.mem.Allocator) MessageError![]const u8 {
    const bytes = try alloc.alloc(u8, 1);
    bytes[0] = @intFromEnum(MessageType.EXIT);
    return bytes;
}

fn decodeExitMessage() MessageError!NetworkMessage {
    return NetworkMessage{ .EXIT = ExitMessage{} };
}
