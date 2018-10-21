defmodule CustomizerWeb.ItemView do
  use CustomizerWeb, :view

  import Customizer.TiledItems

  alias Customizer.Textures
  alias Customizer.SaveManager

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

  def default?(item) do
    Regex.match?(~r/default/, item)
  end

  def preload?(socket) do
    socket.assigns != %{}
  end

  def selected_file?(category, item, file, socket) do
    check_preload_assign(socket.assigns, "#{category}/#{item}/#{file}")
  end

  def check_preload_assign(%{keyword: password}, file) do
    SaveManager.verify_selection(password, file)
  end
  def check_preload_assign(_, _) do
    false
  end

  def get_images(category) do
    Textures.file_list()[String.to_atom(category)]
    |> Enum.sort
  end
end
