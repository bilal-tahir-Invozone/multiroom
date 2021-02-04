defmodule MultiRooms.Query do
  use GenStage

  # Client
  def start_link(socket), do: GenStage.start_link(__MODULE__, socket)

  # Server
  def init(socket), do: {:producer, socket, buffer_size: 1}

  def handle_cast({:notify, event}, socket) do
    {:noreply, [{socket, event}], socket}
  end

  def handle_demand(_demand, state), do: {:noreply, [], state}
end
