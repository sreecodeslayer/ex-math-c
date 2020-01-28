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
    GenServer.cast(:commands, {:cos, angle})
  end

  def sin(angle) do
    GenServer.cast(:commands, {:sin, angle})
  end

  def tan(angle) do
    GenServer.cast(:commands, {:tan, angle})
  end

  def sqrt(number) do
    GenServer.cast(:commands, {:sqrt, number})
  end

  # Server APIs
  @impl true
  def init(_) do
    Process.flag(:trap_exit, true)
    port = Port.open({:spawn, "priv_dir/math"}, [{:packet, 2}])
    {:ok, port}
  end

  @impl true
  def handle_cast({:cos, angle}, port) do
    Port.command(port, [@cos_fn_c, "#{angle}"])
    {:noreply, port}
  end

  @impl true
  def handle_cast({:sin, angle}, port) do
    Port.command(port, [@sin_fn_c, "#{angle}"])
    {:noreply, port}
  end

  @impl true
  def handle_cast({:tan, angle}, port) do
    Port.command(port, [@tan_fn_c, "#{angle}"])
    {:noreply, port}
  end

  @impl true
  def handle_cast({:sqrt, number}, port) do
    Port.command(port, [@sqrt_fn_c, "#{number}"])
    {:noreply, port}
  end

  @impl true
  def handle_info({_port, {:data, result}}, port) do
    result
    |> to_string()
    |> String.to_float()
    |> IO.inspect()

    {:noreply, port}
  end
end
