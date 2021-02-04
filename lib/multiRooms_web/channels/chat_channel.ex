defmodule MultiRoomsWeb.ChatChannel do
  use MultiRoomsWeb, :channel
  require Protocol


  alias MultiRooms.Chats

  @impl true
  def join("chat:" <> _room, _payload, socket) do

    send(self(), :after_join)
    {:ok, socket}

  end
  @impl true
  def handle_info(:after_join,socket) do
    "chat:"<> room = socket.topic
    result = Chats.list_messages_by_room(room)
    IO.inspect result

    # messages = Map.from_struct(result)
    # Enum.map(result.rows, fn row ->
    #   Enum.zip(result.columns, Tuple.to_list(row))
    #   |> Enum.into(%{})
    #   |> JSON.encode
    #   |> push(socket, "shout")
    # end)

    push(socket, "shout", %{result: result})
    # payload = Map.merge(payload, %{"messages" => messages})
    # IO.puts "here is after join"

    # broadcast socket, "shout", Jason.encode(result)
    {:noreply, socket}
  end

  @impl true
  def handle_in("shout", payload, socket) do
    "chat:"<> room = socket.topic
    payload = Map.merge(payload, %{"room" => room})
    Chats.create_message(payload)
    IO.puts "here is data post"

    broadcast socket, "shout", payload

    {:noreply, socket}
  end



end

defmodule B do
  defstruct [:name, :body]
end
