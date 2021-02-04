defmodule MultiRoomsWeb.ChatChannel do
  use MultiRoomsWeb, :channel

  alias MultiRooms.Chats
  @impl true
  def join("chat:" <> _room, _payload, socket) do
    # IO.puts payload
    {:ok, socket}

  end

  @impl true
  def handle_in("shout", payload, socket) do
    "chat:"<> room = socket.topic
    payload = Map.merge(payload, %{"room" => room})
    Chats.create_message(payload)
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

end
