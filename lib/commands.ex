defmodule Exmath.Commands do
  use GenServer

  # Client APIS

  def connect() do
    GenServer.start_link(__MODULE__, [])
  end

  def cos(angle) do
    GenServer.call(:cos, [angle])
  end

  # Server APIs
  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:cos, angle}, _from, state) do
    {:reply, answer, state}
  end
end
