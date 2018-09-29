defmodule CustomizerWeb.ItemView do
  use CustomizerWeb, :view

  import Customizer.TiledItems

  alias Customizer.Textures

  def proper_punctuation(item) do
    item
    |> String.split("_")
    |> Enum.map(fn(x) -> String.capitalize(x) end)
    |> Enum.uniq()
    |> Enum.join(" ")
    |> String.replace("Sub ", "")
  end

  def proper_punctuation_for_tiled(item) do
    item
    |> String.split("_")
    |> Enum.map(fn(x) -> String.capitalize(x) end)
    |> Enum.uniq()
    |> Enum.join(" ")
    |> String.replace("Sub ", "")
    |> String.replace("Top", "")
  end

  def remove_subs(item) do
    if Enum.any?(item, fn(x) -> x == "Sub" end) do
      item = remove_subs(Enum.drop(item, 2))
    end
    item
  end

  def default_selected(item) do
    Regex.match?(~r/default/, item)
  end

  def get_images(category) do
    Textures.file_list()[String.to_atom(category)]
    |> Enum.sort
  end
end
