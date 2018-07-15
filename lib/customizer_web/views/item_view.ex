defmodule CustomizerWeb.ItemView do
  use CustomizerWeb, :view
  alias Customizer.Textures

  @two_tiles ["door_acacia_upper", "door_acacia_lower", "door_birch_upper", "door_birch_lower",
    "door_wood_upper", "door_wood_lower", "door_jungle_upper", "door_jungle_lower", "door_spruce_upper",
    "door_spruce_lower", "door_dark_oak_upper", "door_dark_oak_lower", "door_iron_upper", "door_iron_lower",
    "double_plant_grass_bottom", "double_plant_grass_top", "double_plant_paeonia_top", "double_plant_paeonia_bottom",
    "double_plant_rose_bottom", "double_plant_rose_top", "double_plant_sunflower_bottom", "double_plant_sunflower_top",
    "double_plant_syringa_bottom", "double_plant_syringa_top"]

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
    |> String.replace("Upper", "")
    |> String.replace("Double ", "")
  end


  def remove_subs(item) do
    if Enum.any?(item, fn(x) -> x == "Sub" end) do
      item = remove_subs(Enum.drop(item, 2))
    end
    item
  end

  def is_two_tiles(item) do
    Enum.member?(@two_tiles, item)
  end

  def upper_file(item) do
    Regex.match?(~r/_upper/, item) || Regex.match?(~r/_top/, item)
    #    Enum.member?(@upper_items, item)
  end

  def lower_equiv(item) do
    if Regex.match?(~r/_upper/, item) do
      String.replace(item, "upper", "lower")
    else
      String.replace(item, "_top", "_bottom")
    end
  end

  def default_selected(item) do
    Regex.match?(~r/default/, item)
  end

  def get_images(category) do
    Textures.file_list()[String.to_atom(category)]
    |> Enum.sort
  end
end
