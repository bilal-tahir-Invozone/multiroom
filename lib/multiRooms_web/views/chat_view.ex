defmodule MultiRoomsWeb.ChatView do
  use MultiRoomsWeb, :view

  def render("index.json", %{result: result}) do

    # IO.inspect result
    render_many(result,__MODULE__,"chat.json", as: :chat)
  end

  def render("chat.json", %{chat: chat}) do
    %{body: chat.body,
    id: chat.id,
    name: chat.name,
    room: chat.room}
  end


end
