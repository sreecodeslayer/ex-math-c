# Exmath

This is a sample application written to learn the implementation of Interoperability of Elixir with C language.

The project's aim is to delegate the work of simple Mathematical function like trigonometry and finding square root, to `math.h` functions of the C Language.

Elixir supervises the bridge using GenServer(enhancement: a Supervisor over the GenServer later) that connects to the compiled binary of the C program using `Ports`.


## Usage
Currently, this can be tested using the Elixir shell : `iex`

1. Compile both C and Elixir sources. Just use:
```bash
$ iex -S mix
```

2. Init the GenServer
```elixir
iex> alias Exmath.Commands
iex> Commands.connect()
iex> Commands.sqrt(100)
10
iex> Commands.tan(45)
1
```

## Todo
1. Fix: Floating point values from C is being sent as Int to Elixir.  
2. Add: Supervisor to prevent C errors crashing the whole application.  
3. Debugging: Add better ways to debug.
