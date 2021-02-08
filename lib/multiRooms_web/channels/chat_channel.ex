defmodule MultiRoomsWeb.ChatChannel do
  use MultiRoomsWeb, :channel
  require Protocol


  alias MultiRooms.Chats

  @impl true
  def join("chat:" <> _room, _payload, socket) do
    # {:ok , id} = payload

    # IO.puts "here socket"
    # DeltaCrdt.read(crdt1)



    # IO.puts "Endddddd"

    send(self(), :after_join)
    {:ok, socket}

  end
  @impl true
  def handle_info(:after_join,socket) do
    "chat:"<> room = socket.topic
    result = Chats.list_messages_by_room(room)
    # IO.inspect result


    push(socket, "load", %{result: result})

    # broadcast socket, "load", Jason.encode(result)
    {:noreply, socket}
  end

  @impl true
  def handle_in("shout", payload, socket) do
    # IO.puts "here is payload"
    # IO.inspect payload["body"]
    # IO.puts "Endddddd"

    "chat:"<> room = socket.topic
    {:ok, id} = DeltaCrdt.start_link(DeltaCrdt.AWLWWMap)
    DeltaCrdt.mutate(id, :add, [room, payload["body"]])
    # IO.inspect DeltaCrdt.read(id)
    payload = Map.merge(payload, %{"room" => room})
    Chats.create_message(payload)
    # IO.puts "here is data post"

    broadcast socket, "shout", payload

    {:noreply, socket}
  end



end
