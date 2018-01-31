defmodule Customizer.ItemView do
  use Customizer.Web, :view
  alias Customizer.FileManager

  def proper_punctuation(item) do
    item
    |> String.split("_")
    |> Enum.map(fn(x) -> String.capitalize(x) end)
    |> Enum.join(" ")
  end

  def default_selected(item) do
    Regex.match?(~r/default/, item)
  end

  def get_images(category) do
    FileManager.file_list()[String.to_atom(category)]
    |> Enum.sort
  end
end
