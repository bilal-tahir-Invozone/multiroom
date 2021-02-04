defmodule MultiRoomsWeb.PageController do
  use MultiRoomsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
