defmodule MultiRoomsWeb.ChatChannelTest do
  use MultiRoomsWeb.ChannelCase

  setup do
    # IO.inspect socket
    {:ok, _, socket} =

      MultiRoomsWeb.UserSocket
      |> socket("user_id", %{user: "123"})
      # |> IO.inspect
      |> subscribe_and_join(MultiRoomsWeb.ChatChannel, "chat:lobby")
    # IO.inspect socket
    %{socket: socket}

  end

  test "ping replies with status ok", %{socket: socket} do

    ref = push socket, "ping", %{"body" => "demo", "id" => 1, "room" => 12}
    assert_reply ref, :ok, %{"body" => "demo", "id" => 1, "room" => 12}
  end

  test "shout broadcasts to chat:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
