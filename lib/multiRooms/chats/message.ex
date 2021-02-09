defmodule MultiRooms.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name , :body]}

  schema "messages" do
    field :body, :string
    field :name, :string
    field :room, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    # IO.puts "here is messages"
    # IO.inspect message
    # IO.puts "End"
    # IO.puts "attrs"
    # IO.inspect attrs
    # IO.puts "End"

    message
    |> cast(attrs, [:body, :room])
    |> validate_required([:body, :room])
  end
end
