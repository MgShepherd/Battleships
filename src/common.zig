const std = @import("std");
const NetworkMessage = @import("NetworkMessage.zig");
const GameState = @import("GameState.zig");

pub const NetworkingError = error{AddressCreationError} || NetworkMessage.MessageError || GameState.GameStateError;

pub const Position = struct { x: u8, y: u8 };

pub const PORT_NUMBER = 3490;
pub const LOCALHOST_ADDRESS = "127.0.0.1";
pub const MAX_CONNECTIONS = 2;

pub fn getLocalhostAddress() NetworkingError!std.net.Address {
    return std.net.Address.parseIp(LOCALHOST_ADDRESS, PORT_NUMBER) catch
        return NetworkingError.AddressCreationError;
}
