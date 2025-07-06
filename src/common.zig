const std = @import("std");

pub const NetworkingError = error{AddressCreationError};

pub const PORT_NUMBER = 3490;
pub const LOCALHOST_ADDRESS = "127.0.0.1";
pub const MAX_CONNECTIONS = 2;

pub fn getLocalhostAddress() NetworkingError!std.net.Address {
    return std.net.Address.parseIp(LOCALHOST_ADDRESS, PORT_NUMBER) catch
        return NetworkingError.AddressCreationError;
}
