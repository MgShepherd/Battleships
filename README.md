# Battleships

A terminal based Battleships game created in Zig. This is a two player game over a localhost connection.

## Starting the Game

This game works by having a server component and then two clients. The server must be running for the clients to be able to connect to.

Before starting the server, you must first build the application by running 
```
zig build
```

Once built, you then need to start the server by using:
```
./zig-out/bin/networking --server
```

And then, with the server running, you can (in different terminal instances) start the two client instances by running:
```
./zig-out/bin/networking --client
```

Once done, you should now be able to start playing battleships. Enjoy!
