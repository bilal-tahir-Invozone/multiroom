defmodule MultiRoomsWeb.ChatController do
  use MultiRoomsWeb, :controller

  alias MultiRooms.Chats

  def show(conn, %{"id" => room}) do
    messages = Chats.list_messages_by_room(room)
    # IO.inspect messages
    render(conn, "show.html", room: room, messages: messages)
  end

  def delete(conn, %{"id" => room}) do
    delt = Chats.del_room_id(room)
    render(conn, "delete.html", room: room, delete: delt)
  end
end
