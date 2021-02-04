defmodule MultiRoomsWeb.ChatChannel do
  use MultiRoomsWeb, :channel

  alias MultiRooms.Chats

  @impl true
  def join("chat:" <> _room, _payload, socket) do

    send(self(), :after_join)
    {:ok, socket}

  end
  @impl true
  def handle_info(:after_join, payload, socket) do
    "chat:"<> room = socket.topic
    messages = Chats.list_messages_by_room(room)
    payload = Map.merge(payload, %{"messages" => messages})
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  @impl true
  def handle_in("shout", payload, socket) do
    "chat:"<> room = socket.topic
    payload = Map.merge(payload, %{"room" => room})
    Chats.create_message(payload)
    # IO.puts "hello this is payload : #{payload}"
    broadcast socket, "shout", payload

    # IO.puts "this is payload :" <> payload
    {:noreply, socket}
  end

end
