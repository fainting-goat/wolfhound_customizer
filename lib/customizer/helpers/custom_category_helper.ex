#since so much of this is hardcoded and HAS to be hardcoded, it's in a separate module to help keep the wall of text
#out of the real code

defmodule Customizer.CustomCategoryHelper do
  #I am not typing this stuff over and over
  @trees ["birch", "acacia", "oak", "dark_oak", "spruce", "jungle", "mangrove"]
  @colors ["black", "blue", "white", "light_gray", "gray", "yellow", "red", "green", "lime", "light_blue", "cyan",
    "orange", "magenta", "brown", "purple", "pink"]
  @corals ["brain", "bubble", "fire", "horn", "tube"]
  @tools ["stone", "wooden", "iron", "golden", "diamond", "netherite"]

  def custom_category_map() do
    misc_map()
    |> Map.merge(tree_map())
    |> Map.merge(plant_map())
    |> Map.merge(color_map())
    |> Map.merge(coral_map())
    |> Map.merge(redstone_map())
    |> Map.merge(nether_map())
    |> Map.merge(animal_map())
    |> Map.merge(weapons_and_tools())
  end

  def tree_map() do
    @trees
    |> Enum.reduce(%{}, fn(tree, accum) ->
      accum
      |> Map.put("#{tree}_planks", "trees")
      |> Map.put("#{tree}_trapdoor", "doors")
      |> Map.put("#{tree}_leaves", "trees")
      |> Map.put("#{tree}_sapling", "trees")
      |> Map.put("#{tree}_door_bottom", "doors")
      |> Map.put("#{tree}_door_top", "doors")
      |> Map.put("#{tree}_log", "trees")
      |> Map.put("#{tree}_log_top", "trees")
      |> Map.put("stripped_#{tree}_log_top", "trees")
      |> Map.put("stripped_#{tree}_log", "trees")
      |> Map.put("sub_boat_#{tree}", "boats")
      |> Map.put("sub_chest_boat_#{tree}", "boats")
    end)
    |> Map.put("azalea_leaves", "trees")
    |> Map.put("flowering_azalea_leaves", "trees")
  end

  def plant_map() do
    %{
      "allium" => "plants",
      "azalea_plant" => "plants",
      "azalea_side" => "plants",
      "azalea_top" => "plants",
      "azure_bluet" => "plants",
      "bamboo_large_leaves" => "plants",
      "bamboo_singleleaf" => "plants",
      "bamboo_small_leaves" => "plants",
      "bamboo_stage0" => "plants",
      "bamboo_stalk" => "plants",
      "beetroots_stage0" => "plants",
      "beetroots_stage1" => "plants",
      "beetroots_stage2" => "plants",
      "beetroots_stage3" => "plants",
      "big_dripleaf_side" => "plants",
      "big_dripleaf_stem" => "plants",
      "big_dripleaf_tip" => "plants",
      "big_dripleaf_top" => "plants",
      "blue_orchid" => "plants",
      "brown_mushroom" => "plants",
      "brown_mushroom_block" => "plants",
      "cactus_bottom" => "plants",
      "cactus_side" => "plants",
      "cactus_top" => "plants",
      "carrots_stage0" => "plants",
      "carrots_stage1" => "plants",
      "carrots_stage2" => "plants",
      "carrots_stage3" => "plants",
      "carved_pumpkin" => "plants",
      "cave_vines" => "plants",
      "cave_vines_lit" => "plants",
      "cave_vines_plant" => "plants",
      "cave_vines_plant_lit" => "plants",
      "cocoa_stage0" => "plants",
      "cocoa_stage1" => "plants",
      "cocoa_stage2" => "plants",
      "cornflower" => "plants",
      "dandelion" => "plants",
      "dead_bush" => "plants",
      "glow_lichen" => "plants",
      "grass" => "plants",
      "flowering_azalea_side" => "plants",
      "flowering_azalea_top" => "plants",
      "jack_o_lantern" => "plants",
      "lilac_top" => "plants",
      "lilac_bottom" => "plants",
      "lily_of_the_valley" => "plants",
      "melon_side" => "plants",
      "melon_top" => "plants",
      "moss" => "plants",
      "mushroom_stem" => "plants",
      "orange_tulip" => "plants",
      "oxeye_daisy" => "plants",
      "peony_top" => "plants",
      "peony_bottom" => "plants",
      "pink_tulip" => "plants",
      "poppy" => "plants",
      "potted_azalea_bush_plant" => "plants",
      "potted_azalea_bush_side" => "plants",
      "potted_azalea_bush_top" => "plants",
      "potted_flowering_azalea_bush_plant" => "plants",
      "potted_flowering_azalea_bush_side" => "plants",
      "potted_flowering_azalea_bush_top" => "plants",
      "potatoes_stage0" => "plants",
      "potatoes_stage1" => "plants",
      "potatoes_stage2" => "plants",
      "potatoes_stage3" => "plants",
      "pumpkin_side" => "plants",
      "pumpkin_top" => "plants",
      "red_mushroom" => "plants",
      "red_mushroom_block" => "plants",
      "red_tulip" => "plants",
      "rose_bush_top" => "plants",
      "rose_bush_bottom" => "plants",
      "small_dripleaf_side" => "plants",
      "small_dripleaf_stem_bottom" => "plants",
      "small_dripleaf_stem_top" => "plants",
      "small_dripleaf_top" => "plants",
      "spore_blossom" => "plants",
      "spore_blossom_base" => "plants",
      "sugar_cane" => "plants",
      "sunflower_back" => "plants",
      "sunflower_front" => "plants",
      "sunflower_top" => "plants",
      "sunflower_bottom" => "plants",
      "sweet_berry_bush_stage0" => "plants",
      "sweet_berry_bush_stage1" => "plants",
      "sweet_berry_bush_stage2" => "plants",
      "sweet_berry_bush_stage3" => "plants",
      "tall_grass_top" => "plants",
      "tall_grass_bottom" => "plants",
      "vine" => "plants",
      "wheat_stage0" => "plants",
      "wheat_stage1" => "plants",
      "wheat_stage2" => "plants",
      "wheat_stage3" => "plants",
      "wheat_stage4" => "plants",
      "wheat_stage5" => "plants",
      "wheat_stage6" => "plants",
      "wheat_stage7" => "plants",
      "white_tulip" => "plants"
    }
  end

  def color_map() do
    @colors
    |> Enum.reduce(tree_map(), fn(color, accum) ->
      accum
      |> Map.put("#{color}_wool", "wool")
      |> Map.put("#{color}_concrete", "concrete")
      |> Map.put("#{color}_concrete_powder", "concrete")
      |> Map.put("#{color}_glazed_terracotta", "terracotta")
      |> Map.put("#{color}_terracotta", "terracotta")
      |> Map.put("#{color}_stained_glass", "glass")
      |> Map.put("#{color}_stained_glass_pane_top", "glass")
      |> Map.put("#{color}_shulker_box", "shulker_box")
      |> Map.put("sub_bed_#{color}", "beds")
      |> Map.put("sub_llama_sub_decor_#{color}", "llama_decor")
      |> Map.put("sub_shulker_shulker_#{color}", "shulker")
      |> Map.put("#{color}_dye", "dye")
      |> Map.put("#{color}_candle", "candles")
      |> Map.put("#{color}_candle_lit", "candles")
      |> Map.put("#{color}_candle", "candle_icons")
    end)
    |> Map.put("candle", "candles")
    |> Map.put("candle", "candle_icons")
    |> Map.put("candle_lit", "candles")
    |> Map.put("tinted_glass", "glass")
  end

  def coral_map() do
    @corals
    |> Enum.reduce(color_map(), fn(coral, accum) ->
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
    %{
      "glass" => "glass",
      "glass_pane_top" => "glass",
      "iron_door_top" => "doors",
      "iron_door_bottom" => "doors",
      "shulker_box" => "shulker_box",
      "terracotta" => "terracotta",
      "sub_shulker_shulker" => "shulker",
      "sub_chest_ender" => "chests",
      "sub_chest_normal" => "chests",
      "sub_chest_normal_double" => "chests",
      "sub_chest_trapped" => "chests",
      "sub_chest_trapped_double" => "chests",
      "sub_chest_normal_left" => "chests",
      "sub_chest_normal_right" => "chests",
      "sub_chest_trapped_left" => "chests",
      "sub_chest_trapped_right" => "chests",
      "sub_villager_butcher" => "villagers",
      "sub_villager_librarian" => "villagers",
      "sub_villager_priest" => "villagers",
      "sub_villager_farmer" => "villagers",
      "sub_villager_smith" => "villagers",
      "sub_villager_villager" => "villagers",
      "sub_villager_sub_profession_armorer" => "villagers",
      "sub_villager_sub_profession_butcher" => "villagers",
      "sub_villager_sub_profession_cartographer" => "villagers",
      "sub_villager_sub_profession_cleric" => "villagers",
      "sub_villager_sub_profession_fisherman" => "villagers",
      "sub_villager_sub_profession_farmer" => "villagers",
      "sub_villager_sub_profession_fletcher" => "villagers",
      "sub_villager_sub_profession_leatherworker" => "villagers",
      "sub_villager_sub_profession_level_diamond" => "villagers",
      "sub_villager_sub_profession_level_emerald" => "villagers",
      "sub_villager_sub_profession_level_gold" => "villagers",
      "sub_villager_sub_profession_level_iron" => "villagers",
      "sub_villager_sub_profession_level_stone" => "villagers",
      "sub_villager_sub_profession_librarian" => "villagers",
      "sub_villager_sub_profession_mason" => "villagers",
      "sub_villager_sub_profession_nitwit" => "villagers",
      "sub_villager_sub_profession_toolsmith" => "villagers",
      "sub_villager_sub_profession_shepherd" => "villagers",
      "sub_villager_sub_profession_weaponsmith" => "villagers",
      "sub_villager_sub_type_desert" => "villagers",
      "sub_villager_sub_type_jungle" => "villagers",
      "sub_villager_sub_type_plains" => "villagers",
      "sub_villager_sub_type_savanna" => "villagers",
      "sub_villager_sub_type_snow" => "villagers",
      "sub_villager_sub_type_swamp" => "villagers",
      "sub_villager_sub_type_taiga" => "villagers",
      "sub_illager_evoker" => "illager",
      "sub_illager_vex" => "illager",
      "sub_illager_vex_charging" => "illager",
      "sub_illager_vindicator" => "illager",
      "sub_illager_illusioner" => "illager",
      "sub_illager_pillager" => "illager",
      "sub_illager_ravager" => "illager",
      "sub_skeleton_skeleton" => "skeletons",
      "sub_skeleton_stray" => "skeletons",
      "sub_skeleton_stray_overlay" => "skeletons",
      "sub_skeleton_wither_skeleton" => "skeletons",
      "sub_zombie_drowned" => "zombies",
      "sub_zombie_drowned_outer_layer" => "zombies",
      "sub_zombie_husk" => "zombies",
      "sub_zombie_zombie" => "zombies",
      "zombie_pigman" => "zombies",
      "sub_hoglin_hoglin" => "piglin",
      "sub_hoglin_zoglin" => "piglin",
      "sub_piglin_piglin" => "piglin",
      "sub_piglin_piglin_brute" => "piglin",
      "sub_piglin_zombified_piglin" => "piglin",
      "sub_zombie_villager_zombie_butcher" => "zombies",
      "sub_zombie_villager_zombie_farmer" => "zombies",
      "sub_zombie_villager_zombie_librarian" => "zombies",
      "sub_zombie_villager_zombie_priest" => "zombies",
      "sub_zombie_villager_zombie_smith" => "zombies",
      "sub_zombie_villager_zombie_villager" => "zombies",
      "sub_zombie_villager_sub_profession_armorer" => "zombies",
        "sub_zombie_villager_sub_profession_butcher" => "zombies",
        "sub_zombie_villager_sub_profession_cartographer" => "zombies",
        "sub_zombie_villager_sub_profession_cleric" => "zombies",
        "sub_zombie_villager_sub_profession_fisherman" => "zombies",
        "sub_zombie_villager_sub_profession_farmer" => "zombies",
        "sub_zombie_villager_sub_profession_fletcher" => "zombies",
        "sub_zombie_villager_sub_profession_leatherworker" => "zombies",
        "sub_zombie_villager_sub_profession_level_diamond" => "zombies",
        "sub_zombie_villager_sub_profession_level_emerald" => "zombies",
        "sub_zombie_villager_sub_profession_level_gold" => "zombies",
        "sub_zombie_villager_sub_profession_level_iron" => "zombies",
        "sub_zombie_villager_sub_profession_level_stone" => "zombies",
        "sub_zombie_villager_sub_profession_librarian" => "zombies",
        "sub_zombie_villager_sub_profession_mason" => "zombies",
        "sub_zombie_villager_sub_profession_nitwit" => "zombies",
        "sub_zombie_villager_sub_profession_toolsmith" => "zombies",
        "sub_zombie_villager_sub_profession_shepherd" => "zombies",
        "sub_zombie_villager_sub_profession_weaponsmith" => "zombies",
        "sub_zombie_villager_sub_type_desert" => "zombies",
        "sub_zombie_villager_sub_type_jungle" => "zombies",
        "sub_zombie_villager_sub_type_plains" => "zombies",
        "sub_zombie_villager_sub_type_savanna" => "zombies",
        "sub_zombie_villager_sub_type_snow" => "zombies",
        "sub_zombie_villager_sub_type_swamp" => "zombies",
        "sub_zombie_villager_sub_type_taiga" => "zombies",
      "cocoa_beans" => "dye",
      "lapis_lazuli" => "dye",
      "rose_red" => "dye",
      "ink_sac" => "dye",
      "cactus_green" => "dye",
      "dandelion_yellow" => "dye",
      "bone_meal" => "dye",
      "book" => "books",
      "enchanted_book" => "books",
      "knowledge_book" => "books",
      "writable_book" => "books",
      "written_book" => "books",
      "apple" => "food",
      "baked_potato" => "food",
      "beef" => "food",
      "beetroot" => "food",
      "beetroot_seeds" => "food",
      "beetroot_soup" => "food",
      "bowl" => "food",
      "bread" => "food",
      "cake" => "food",
      "carrot" => "food",
      "chicken" => "food",
      "cod" => "food",
      "cooked_beef" => "food",
      "cooked_chicken" => "food",
      "cooked_cod" => "food",
      "cooked_mutton" => "food",
      "cooked_rabbit" => "food",
      "cooked_salmon" => "food",
      "cookie" => "food",
      "glistering_melon_slice" => "food",
      "glow_berries" => "food",
      "golden_apple" => "food",
      "golden_carrot" => "food",
      "melon_slice" => "food",
      "mushroom_stew" => "food",
      "poisonous_potato" => "food",
      "porkchop" => "food",
      "potato" => "food",
      "pumpkin_pie" => "food",
      "pumpkin_seeds" => "food",
      "rabbit_stew" => "food",
      "salmon" => "food",
      "sugar" => "food",
      "wheat" => "food",
      "wheat_seeds" => "food",
      "water_bucket" => "buckets",
      "tropical_fish_bucket" => "buckets",
      "salmon_bucket" => "buckets",
      "pufferfish_bucket" => "buckets",
      "milk_bucket" => "buckets",
      "lava_bucket" => "buckets",
      "cod_bucket" => "buckets",
      "axolotl_bucket" => "buckets",
      "tadpole_bucket" => "buckets",
      "bucket" => "buckets",
      "music_disc_11" => "music_disks",
      "music_disc_13" => "music_disks",
      "music_disc_blocks" => "music_disks",
      "music_disc_cat" => "music_disks",
      "music_disc_chirp" => "music_disks",
      "music_disc_far" => "music_disks",
      "music_disc_mall" => "music_disks",
      "music_disc_mellohi" => "music_disks",
      "music_disc_stal" => "music_disks",
      "music_disc_strad" => "music_disks",
      "music_disc_wait" => "music_disks",
      "music_disc_ward" => "music_disks",
      "music_disc_pigstep" => "music_disks"
    }
  end

  def redstone_map() do
    %{
      "activator_rail_on" => "redstone",
      "activator_rail" => "redstone",
      "command_block_back" => "redstone",
      "command_block_conditional" => "redstone",
      "command_block_front" => "redstone",
      "command_block_side" => "redstone",
      "chain_command_block_back" => "redstone",
      "chain_command_block_conditional" => "redstone",
      "chain_command_block_front" => "redstone",
      "chain_command_block_side" => "redstone",
      "repeating_command_block_back" => "redstone",
      "repeating_command_block_conditional" => "redstone",
      "repeating_command_block_front" => "redstone",
      "repeating_command_block_side" => "redstone",
      "comparator" => "redstone",
      "comparator_on" => "redstone",
      "daylight_detector_inverted_top" => "redstone",
      "daylight_detector_side" => "redstone",
      "daylight_detector_top" => "redstone",
      "detector_rail" => "redstone",
      "detector_rail_on" => "redstone",
      "lever" => "redstone",
      "observer_back" => "redstone",
      "observer_back_on" => "redstone",
      "observer_front" => "redstone",
      "observer_side" => "redstone",
      "observer_top" => "redstone",
      "piston_bottom" => "redstone",
      "piston_inner" => "redstone",
      "piston_side" => "redstone",
      "piston_top" => "redstone",
      "piston_top_sticky" => "redstone",
      "powered_rail" => "redstone",
      "powered_rail_on" => "redstone",
      "rail" => "redstone",
      "rail_corner" => "redstone",
      "redstone_dust_dot" => "redstone",
      "redstone_dust_line0" => "redstone",
      "redstone_dust_line1" => "redstone",
      "redstone_lamp" => "redstone",
      "redstone_lamp_on" => "redstone",
      "redstone_torch" => "redstone",
      "redstone_torch_off" => "redstone",
      "repeater" => "redstone",
      "repeater_on" => "redstone",
    }
  end

  def nether_map() do
      %{
        "ancient_debris_side" => "nether",
        "ancient_debris_top" => "nether",
        "ancient_debris_top" => "nether",
        "basalt_side" => "nether",
        "basalt_top" => "nether",
        "blackstone" => "nether",
        "blackstone_top" => "nether",
        "chiseled_nether_bricks" => "nether",
        "chiseled_polished_blackstone" => "nether",
        "cracked_nether_bricks" => "nether",
        "cracked_polished_blackstone_bricks" => "nether",
        "crimson_door_bottom" => "nether",
        "crimson_door_top" => "nether",
        "crimson_fungus" => "nether",
        "crimson_nylium" => "nether",
        "crimson_nylium_side" => "nether",
        "crimson_planks" => "nether",
        "crimson_roots" => "nether",
        "crimson_roots_pot" => "nether",
        "crimson_stem" => "nether",
        "crimson_stem_top" => "nether",
        "crimson_trapdoor" => "nether",
        "crying_obsidian" => "nether",
        "gilded_blackstone" => "nether",
        "glowstone" => "nether",
        "nether_bricks" => "nether",
        "nether_gold_ore" => "nether",
        "nether_quartz_ore" => "nether",
        "nether_sprouts" => "nether",
        "nether_wart_block" => "nether",
        "nether_wart_stage0" => "nether",
        "nether_wart_stage1" => "nether",
        "nether_wart_stage2" => "nether",
        "netherite_block" => "nether",
        "polished_basalt_side" => "nether",
        "polished_basalt_top" => "nether",
        "polished_blackstone" => "nether",
        "polished_blackstone_bricks" => "nether",
        "quartz_block_side" => "nether",
        "quartz_block_top" => "nether",
        "quartz_pillar" => "nether",
        "quartz_pillar_top" => "nether",
        "red_nether_bricks" => "nether",
        "respawn_anchor_bottom" => "nether",
        "respawn_anchor_side0" => "nether",
        "respawn_anchor_side1" => "nether",
        "respawn_anchor_side2" => "nether",
        "respawn_anchor_side3" => "nether",
        "respawn_anchor_side4" => "nether",
        "respawn_anchor_top" => "nether",
        "respawn_anchor_top_off" => "nether",
        "shroomlight" => "nether",
        "smooth_basalt" => "nether",
        "soul_campfire_fire" => "nether",
        "soul_campfire_log_lit" => "nether",
        "soul_fire_0" => "nether",
        "soul_fire_1" => "nether",
        "soul_lantern" => "nether",
        "soul_sand" => "nether",
        "soul_soil" => "nether",
        "soul_torch" => "nether",
        "stripped_crimson_stem" => "nether",
        "stripped_crimson_stem_top" => "nether",
        "stripped_warped_stem" => "nether",
        "stripped_warped_stem_top" => "nether",
        "twisting_vines" => "nether",
        "twisting_vines_plant" => "nether",
        "warped_door_bottom" => "nether",
        "warped_door_top" => "nether",
        "warped_fungus" => "nether",
        "warped_nylium_side" => "nether",
        "warped_planks" => "nether",
        "warped_roots" => "nether",
        "warped_roots_pot" => "nether",
        "warped_stem" => "nether",
        "warped_stem_top" => "nether",
        "warped_trapdoor" => "nether",
        "warped_wart_block" => "nether",
        "weeping_vines" => "nether",
        "weeping_vines_plant" => "nether",
        "wither_rose" => "nether",
      }
    end

  def animal_map() do
    %{
      "sub_horse_horse_black" => "horses",
      "sub_horse_horse_brown" => "horses",
      "sub_horse_horse_white" => "horses",
      "sub_horse_horse_chestnut" => "horses",
      "sub_horse_horse_creamy" => "horses",
      "sub_horse_horse_darkbrown" => "horses",
      "sub_horse_horse_gray" => "horses",
      "sub_horse_horse_skeleton" => "horses",
      "sub_cat_black" => "cats",
      "sub_cat_ocelot" => "cats",
      "sub_cat_red" => "cats",
      "sub_cat_siamese" => "cats",
      "sub_parrot_parrot_blue" => "parrots",
      "sub_parrot_parrot_green" => "parrots",
      "sub_parrot_parrot_grey" => "parrots",
      "sub_parrot_parrot_red_blue" => "parrots",
      "sub_parrot_parrot_yellow_blue" => "parrots",
      "sub_wolf_wolf" => "wolves",
      "sub_wolf_wolf_angry" => "wolves",
      "sub_wolf_wolf_tame" => "wolves"
    }
  end

  def weapons_and_tools() do
    @tools
    |> Enum.reduce(%{}, fn(tool, accum) ->
      accum
      |> Map.put("#{tool}_sword", "weapons_and_armor")
      |> Map.put("#{tool}_axe", "tools")
      |> Map.put("#{tool}_pickaxe", "tools")
      |> Map.put("#{tool}_shovel", "tools")
      |> Map.put("#{tool}_hoe", "tools")
      |> Map.put("#{tool}_hoe", "tools")
      |> Map.put("#{tool}_boots", "weapons_and_armor")
      |> Map.put("#{tool}_chestplate", "weapons_and_armor")
      |> Map.put("#{tool}_helmet", "weapons_and_armor")
      |> Map.put("#{tool}_leggings", "weapons_and_armor")
    end)
    |> Map.put("bow", "weapons_and_armor")
    |> Map.put("bow_pulling_0", "weapons_and_armor")
    |> Map.put("bow_pulling_1", "weapons_and_armor")
    |> Map.put("bow_pulling_2", "weapons_and_armor")
    |> Map.put("arrow", "weapons_and_armor")
    |> Map.put("chainmail_boots", "weapons_and_armor")
    |> Map.put("chainmail_chestplate", "weapons_and_armor")
    |> Map.put("chainmail_helmet", "weapons_and_armor")
    |> Map.put("chainmail_leggings", "weapons_and_armor")
    |> Map.put("leather_boots", "weapons_and_armor")
    |> Map.put("leather_chestplate", "weapons_and_armor")
    |> Map.put("leather_helmet", "weapons_and_armor")
    |> Map.put("leather_leggings", "weapons_and_armor")
    |> Map.put("leather_boots_overlay", "weapons_and_armor")
    |> Map.put("leather_chestplate_overlay", "weapons_and_armor")
    |> Map.put("leather_helmet_overlay", "weapons_and_armor")
    |> Map.put("leather_leggings_overlay", "weapons_and_armor")
    |> Map.put("trident", "weapons_and_armor")
  end

  def custom_category_names() do
    #hardcode this so I can be picky about the display order
    %{
      "block" => ["trees", "plants", "doors", "concrete", "terracotta", "shulker_box", "glass", "wool",
      "candles", "coral", "redstone", "nether"],
      "entity" => ["beds", "shulker", "chests", "boats", "llama_decor", "horses", "cats", "parrots", "wolves", "skeletons", "zombies", "illager", "piglin", "villagers"],
      "item" => ["dye", "candle_icons", "books", "buckets", "music_disks", "food", "weapons_and_armor", "tools"]
    }

    #use this if you don't care
    #    custom_category_map
    #    |> Map.values()
    #    |> Enum.uniq
  end
end
