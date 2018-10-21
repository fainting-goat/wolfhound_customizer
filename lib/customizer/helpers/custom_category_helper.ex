#since so much of this is hardcoded and HAS to be hardcoded, it's in a separate module to help keep the wall of text
#out of the real code

defmodule Customizer.CustomCategoryHelper do
  #I am not typing this stuff over and over
  @trees ["birch", "acacia", "oak", "dark_oak", "spruce"]
  @colors ["black", "blue", "white", "light_gray", "gray", "yellow", "red", "green", "lime", "light_blue", "cyan",
    "orange", "magenta", "brown", "purple", "pink"]
  @corals ["brain", "bubble", "fire", "horn", "tube"]

  def custom_category_map() do
    misc_map = %{"glass" => "glass", "glass_pane_top" => "glass", "iron_door_top" => "doors",
    "iron_door_bottom" => "doors", "shulker_box" => "shulker_box", "terracotta" => "terracotta"}

    misc_map
    |> Map.merge(tree_map())
    |> Map.merge(color_map())
    |> Map.merge(coral_map())
  end

  def tree_map() do
    @trees
    |> Enum.reduce(%{}, fn(tree, accum) ->
      accum
      |> Map.put("#{tree}_planks", "planks")
      |> Map.put("#{tree}_trapdoor", "trapdoors")
      |> Map.put("#{tree}_leaves", "leaves")
      |> Map.put("#{tree}_sapling", "saplings")
      |> Map.put("#{tree}_door_bottom", "doors")
      |> Map.put("#{tree}_door_top", "doors")
      |> Map.put("#{tree}_log", "logs")
      |> Map.put("#{tree}_log_top", "logs")
    end)
  end

  def color_map() do
    @colors
    |> Enum.reduce(tree_map, fn(color, accum) ->
      accum
      |> Map.put("#{color}_wool", "wool")
      |> Map.put("#{color}_concrete", "concrete")
      |> Map.put("#{color}_concrete_powder", "concrete")
      |> Map.put("#{color}_glazed_terracotta", "terracotta")
      |> Map.put("#{color}_terracotta", "terracotta")
      |> Map.put("#{color}_stained_glass", "glass")
      |> Map.put("#{color}_stained_glass_pane_top", "glass")
      |> Map.put("#{color}_shulker_box", "shulker_box")
    end)
  end

  def coral_map() do
    @corals
    |> Enum.reduce(color_map, fn(coral, accum) ->
      accum
      |> Map.put("#{coral}_coral", "coral")
      |> Map.put("#{coral}_coral_block", "coral")
      |> Map.put("#{coral}_coral_fan", "coral")
      |> Map.put("dead_#{coral}_coral_fan", "coral")
      |> Map.put("dead_#{coral}_coral", "coral")
      |> Map.put("dead_#{coral}_coral_block", "coral")
    end)
  end

  def misc_map() do
    %{"glass" => "glass",
    "glass_pane_top" => "glass",
    "iron_door_top" => "doors",
    "iron_door_bottom" => "doors",
    "shulker_box" => "shulker_box",
    "terracotta" => "terracotta"}
  end

  def custom_category_names() do
    #hardcode this so I can be picky about the display order
    %{
      "block" => ["logs", "leaves", "saplings", "planks", "doors", "concrete", "terracotta", "shulker_box", "glass", "wool",
      "coral"]
    }

    #use this if you don't care
    #    custom_category_map
    #    |> Map.values()
    #    |> Enum.uniq
  end
end
