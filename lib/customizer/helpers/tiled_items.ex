defmodule Customizer.TiledItems do
  @top_tiles ["acacia_door_top", "birch_door_top", "oak_door_top", "jungle_door_top", "spruce_door_top",
    "dark_oak_door_top", "iron_door_top", "lilac_top", "peony_top", "rose_bush_top", "sunflower_top",
    "tall_grass_top"]

  @bottom_tiles ["acacia_door_bottom", "birch_door_bottom", "oak_door_bottom", "jungle_door_bottom",
    "spruce_door_bottom", "dark_oak_door_bottom", "iron_door_bottom", "lilac_top", "lilac_bottom", "peony_bottom",
    "rose_bush_bottom", "sunflower_bottom", "tall_grass_bottom"]

  def is_two_tiles?(item) do
    bottom_file?(item) || top_file?(item)
  end

  def bottom_file?(item) do
    Enum.member?(@bottom_tiles, item)
  end

  def top_file?(item) do
    Enum.member?(@top_tiles, item)
  end

  def lower_equiv(item) do
    String.replace(item, "_top", "_bottom")
  end
end
