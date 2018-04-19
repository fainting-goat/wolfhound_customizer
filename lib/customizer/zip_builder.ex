defmodule Customizer.ZipBuilder do

  alias Customizer.FileManager

  @full_path "assets/minecraft/textures"

  def create_zip(directory) do
    path = "./temporary"
    categories = FileManager.categories()

    items = categories
            |> Enum.reduce([], fn (category, accum) ->
      {:ok, items} = File.ls("#{path}/#{directory}/#{@full_path}/#{category}")
      correct_items = items
                      |> Enum.reduce([], fn (item, item_accum) ->
        %{subcat: subcat_path, item: item} = build_subcat(item)
        item_accum ++ ["#{@full_path}/#{category}#{subcat_path}/#{item}"]
      end)
      accum ++ correct_items
    end)

    blockstates = elem(File.ls("#{path}/#{directory}/assets/minecraft/blockstates"), 1)
                  |> Enum.reduce([], fn(file, file_accum) -> file_accum ++ ["assets/minecraft/blockstates/#{file}"] end)

    include_meta = items ++ ["pack.mcmeta"]
    include_blockstates = include_meta ++ blockstates

    files = include_blockstates
            |> Enum.map(fn (x) -> String.to_charlist(x) end)

    :zip.create(String.to_charlist("#{directory}.zip"), files, [cwd: "#{path}/#{directory}"])
  end

  def delete_temp_dir(directory) do
    File.rm_rf("./temporary/#{directory}")
  end

  def create_temp_directory(items) do
    [prefix: prefix] = Application.get_env(:customizer, :setup)

    directory = "Wolfhound_#{:rand.uniform(1000)}"
    File.mkdir("./temporary/#{directory}")
    File.mkdir("./temporary/#{directory}/assets")
    File.mkdir("./temporary/#{directory}/assets/minecraft")
    File.mkdir("./temporary/#{directory}/assets/minecraft/textures")

    items
    |> Map.values
    |> Enum.each(
         fn (x) ->
           [path, name, _] = String.split(x, "/")
           move_file_to_temp(x, directory, FileManager.valid_params(x))
         end
       )

    copy_blockstates(directory)
    copy_mcmeta(directory)

    #we need the mcmeta file for the resourcepack to work
    File.cp("#{prefix}/pack.mcmeta", "./temporary/#{directory}/pack.mcmeta")

    {:ok, directory}
  end

  defp move_file_to_temp(source, directory, {path, name}) do
    [prefix: prefix] = Application.get_env(:customizer, :setup)

    %{subcat: subcat_path, item: item} = build_subcat(name)

    File.mkdir_p("./temporary/#{directory}/#{@full_path}/#{path}#{subcat_path}")
    File.cp("#{prefix}images/#{source}", "./temporary/#{directory}/#{@full_path}/#{path}#{subcat_path}/#{item}.png")
  end
  defp move_file_to_temp(source, directory, _), do: {:ok}

  defp copy_blockstates(directory) do
    [prefix: prefix] = Application.get_env(:customizer, :setup)

    File.mkdir("./temporary/#{directory}/assets/minecraft/blockstates")
    {:ok, blockstates} = File.ls("#{prefix}/blockstates")
    blockstates
    |> Enum.each(fn(file) -> File.cp("#{prefix}/blockstates/#{file}", "./temporary/#{directory}/assets/minecraft/blockstates/#{file}") end)
  end

  defp copy_mcmeta(directory) do
    [prefix: prefix] = Application.get_env(:customizer, :setup)

    {:ok, mcmeta} = File.ls("#{prefix}/mcmeta")
    mcmeta
    |> Enum.each(fn(file) -> File.cp("#{prefix}/mcmeta/#{file}", "./temporary/#{directory}/assets/minecraft/textures/blocks/#{file}") end)
  end

  defp build_subcat(item, subcat \\ "")
  defp build_subcat("sub_creative_inventory_" <> item, subcat) do
    %{subcat: "#{subcat}/creative_inventory", item: item}
  end
  defp build_subcat("sub_" <> item, subcat) do
    [subcat_dir | pieces] = String.split(item, "_")
    item_name = Enum.join(pieces, "_")
    build_subcat(item_name, "#{subcat}/#{subcat_dir}")
  end
  defp build_subcat(item, subcat) do
    %{subcat: subcat, item: item}
  end

  defp update_clock_files(item_params, full_list) do
    type_name = case item_params["clock_00"] do
      "items/clock_00/" <> suffix ->  suffix
      _ -> "default.png"
    end

    full_list
    |> Enum.reduce(%{}, fn({key, item}, acc) ->
      case key do
        "clock_" <> number -> Map.put(acc, key, "items/clock_#{number}/#{type_name}")
        _ -> Map.put(acc, key, item)
      end
    end)
  end
end