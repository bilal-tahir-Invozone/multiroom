defmodule MultiRoomsWeb.ChatChannel do

  # use GenServer
  use MultiRoomsWeb, :channel
  require Protocol
  # defstruct mapTable: %{}
  alias MultiRoomsWeb.Presence
  alias MultiRooms.Chats



  # def start_link() do
  #   GenServer.start_link(__MODULE__, [])
  # end

  # @impl true
  # def init(list) do
  #   {:ok, list}
  # end






  @impl true
  def join("chat:" <> _room, _payload, socket) do

    send(self(), :after_join)
    {:ok, socket}

  end
  @impl true
  def handle_info(:after_join, socket) do
    # IO.inspect socket
    Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })

    user_presence = Presence.list(socket)
    user_list = Map.keys(user_presence)

    if Enum.member?(user_list, socket.assigns.user) do

      map = Enum.reduce user_list, %{}, fn x, acc ->
        {:ok, result} = DeltaCrdt.start_link(DeltaCrdt.AWLWWMap, sync_interval: 3)
        Map.put(acc, x, result)
      end
      map_table =
      if Enum.member?(:ets.all(), :map_table) == false do
         :ets.new(:map_table, [:set, :public])
      end



      # %__MODULE__{mapTable: map_table}
      :ets.insert(map_table, {"map_key", map})

      for data <- Map.keys(map) do
        IO.puts "making neighbors"
        DeltaCrdt.set_neighbours(map[data], Map.values(map))
      end
    else
      IO.puts "this is a new members"
  end

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
    IO.puts "here is socket"
    # IO.inspect socket.assigns.user
    # IO.inspect :sendId
    sender_id =  socket.assigns.user
    # IO.puts "Endddddd"
    # %{
    #   user: socket.assigns.user,
    #   body: message,
    #   timestamp: :os.system_time(:milli_seconds)
    # }

    "chat:"<> room = socket.topic
    # IO.puts "here is list of users"
    # IO.puts "here is mmap"
    # IO.inspect :ets.tab2list(:map_table)

    # db_data = :ets.lookup(map_table, "map_key")
    # IO.puts "here is data from db"
    # IO.inspect db_data
    # DeltaCrdt.mutate(map[data], :add, [room, data])
    # IO.puts "start"
    # IO.inspect DeltaCrdt.read(map[data])
    # IO.puts "End"


    # IO.inspect map
    # values_of_map  = Map.values(map)
    # for data <- Map.keys(map) do
    #   DeltaCrdt.set_neighbours(map[data], Map.values(map))
    #   DeltaCrdt.mutate(map[data], :add, [room, data])
    #   IO.puts "start"
    #   IO.inspect DeltaCrdt.read(map[data])
    #   IO.puts "End"
    # end




    # IO.inspect Map.values(map)
    # for n <- Map.keys(map) do

    #   # IO.puts "here is n"
    #   # IO.inspect n

    # end
    # IO.inspect user_list
    # for data <- user_list do
    #   map_user
    #   |> %{}
    #   |> Map.put(map_user, :key, data)
    #   # map_user = %{key: data}
    #   IO.inspect map_user
    # end
    # IO.inspect map_user
    # Enum.each(user_list, fn (key) ->
    # key = DeltaCrdt.start_link(DeltaCrdt.AWLWWMap, sync_interval: 3)
    # end)
    # list_user = Enum.each(user_presence, fn ({key, value}) -> IO.puts "ok" end)
    # IO.inspect user_presence
    # user_list = []
    # for users <- Map.keys(user_presence) do
      # IO.inspect users
      # user_list = Enum.map(list_with_maps, fn (x) -> x[users] end)
      # %{user_list: users}
      # for n <- :user_list do
      #   n = DeltaCrdt.start_link(DeltaCrdt.AWLWWMap, sync_interval: 3)
      #   IO.inspect n
      # end
    #   # {:ok, :useres} = DeltaCrdt.start_link(DeltaCrdt.AWLWWMap, sync_interval: 3)
    #   # DeltaCrdt.mutate(:useres, :add, [room, payload["body"]])
      # end
    # IO.puts "here is object"


    # {:ok, user2} = DeltaCrdt.start_link(DeltaCrdt.AWLWWMap, sync_interval: 3)
    # DeltaCrdt.set_neighbours(user1, [user2])
    # DeltaCrdt.set_neighbours(user2, [user1])
    # DeltaCrdt.read(user1)
    # IO.inspect user1
    # IO.inspect user2
    # DeltaCrdt.set_neighbours(user1, [user2])
    # DeltaCrdt.set_neighbours(id2, [id1])

    # Process.sleep(10)
    # IO.puts "start"
    # IO.inspect DeltaCrdt.read(user2)
    # IO.puts "end"
    payload = Map.merge(payload, %{"room" => room })
    Chats.update_message( %{id: 51}, payload)

    payload = Map.merge(payload, %{"send_id" => sender_id})
    IO.puts "here is payload"
    IO.inspect payload
    IO.puts "Endddddd"
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
