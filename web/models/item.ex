defmodule Customizer.Item do
  use Customizer.Web, :model

  schema "items" do
    field :path, :string
    field :category, :string
    field :type, :string
    field :flavor, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:path, :category, :type, :flavor])
    |> validate_required([:path, :category, :type, :flavor])
  end
end
