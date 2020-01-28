defmodule Exmath.Commands do
  use GenServer

  @sin_fn_c 1
  @cos_fn_c 2
  @tan_fn_c 3
  @sqrt_fn_c 4

  # Client APIS

  def connect() do
    GenServer.start_link(__MODULE__, [], name: :commands)
  end

  def cos(angle) do
    GenServer.call(:commands, {:cos, angle})
  end

  def sin(angle) do
    GenServer.call(:commands, {:sin, angle})
  end

  def tan(angle) do
    GenServer.call(:commands, {:tan, angle})
  end

  def sqrt(number) do
    GenServer.call(:commands, {:sqrt, number})
  end

  # Server APIs
  @impl true
  def init(_) do
    Process.flag(:trap_exit, true)
    port = Port.open({:spawn, "priv_dir/math"}, [{:packet, 2}])
    {:ok, %{port: port}}
  end

  @impl true
  def handle_call({:cos, angle}, _from, %{port: port} = state) do
    Port.command(port, [@cos_fn_c, angle])
    answer = do_receive()
    {:reply, answer, state}
  end

  @impl true
  def handle_call({:sin, angle}, _from, %{port: port} = state) do
    Port.command(port, [@sin_fn_c, angle])
    answer = do_receive()
    {:reply, answer, state}
  end

  @impl true
  def handle_call({:tan, angle}, _from, %{port: port} = state) do
    Port.command(port, [@tan_fn_c, angle])
    answer = do_receive()
    {:reply, answer, state}
  end

  @impl true
  def handle_call({:sqrt, number}, _from, %{port: port} = state) do
    Port.command(port, [@sqrt_fn_c, number])
    answer = do_receive()
    {:reply, answer, state}
  end

  defp do_receive do
    receive do
      {_port, {:data, [result]}} ->
        result

      other ->
        IO.puts("Unhandled message from C: #{inspect(other)}")
    end
  end
end
