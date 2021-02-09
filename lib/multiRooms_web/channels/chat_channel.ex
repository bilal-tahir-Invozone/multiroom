defmodule MultiRoomsWeb.ChatChannel do
  use MultiRoomsWeb, :channel
  require Protocol


  alias MultiRooms.Chats

  @impl true
  def join("chat:" <> _room, _payload, socket) do
    # {:ok , id} = payload

    # IO.puts "here payload"
    # DeltaCrdt.read(crdt1)
    # IO.inspect payload
    # IO.puts "Endddddd"

    send(self(), :after_join)
    {:ok, socket}

  end
  @impl true
  def handle_info(:after_join,socket) do
    "chat:"<> room = socket.topic
    result = Chats.list_messages_by_room(room)
    if result === [] do
      IO.puts "it is empty"
      result = %{:body => "demo", :room  => room}
      Chats.create_message(result)
      push(socket, "load", %{result: MultiRoomsWeb.ChatView.render("index.json", %{result: result})})
    else
      IO.puts "no it is not"
      push(socket, "load", %{result: MultiRoomsWeb.ChatView.render("index.json", %{result: result})})
    end


    # broadcast socket, "load", %{result: result}
    {:noreply, socket}
  end

  @impl true
  def handle_in("shout", payload, socket) do
    # IO.puts "here is payload"
    # IO.inspect payload["body"]
    # IO.puts "Endddddd"

    "chat:"<> room = socket.topic

    {:ok, id1} = DeltaCrdt.start_link(DeltaCrdt.AWLWWMap)
    {:ok, id2} = DeltaCrdt.start_link(DeltaCrdt.AWLWWMap)
    DeltaCrdt.set_neighbours(id1, [id2])
    DeltaCrdt.set_neighbours(id2, [id1])
    DeltaCrdt.mutate(id1, :add, [room, payload["body"]])
    Process.sleep(10)
    IO.inspect DeltaCrdt.read(id2)

    payload = Map.merge(payload, %{"room" => room})
    Chats.update_message( %{id: 50}, payload)
    broadcast socket, "shout", payload

    # push(socket, "shout", %{result: MultiRoomsWeb.ChatView.render("index.json", %{result: result})})

    {:noreply, socket}
  end



  # def handle_in("edit", payload, socket) do

  #   "chat:"<> room = socket.topic
  #   payload = Map.merge(payload, %{"room" => room})
  #   Chats.update_message(%{id: 38},payload)
  #   broadcast socket, "edit", payload

  #   {:noreply, socket}
  # end



end
