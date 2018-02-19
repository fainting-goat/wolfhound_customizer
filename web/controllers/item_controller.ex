defmodule Customizer.ItemController do
  use Customizer.Web, :controller
  alias Customizer.Item
  alias Customizer.FileManager

  @full_path "assets/minecraft/textures"

  def index(conn, params) do
    %{categories: categories, items: images, changeset: changeset} = do_all_things()

    render conn, "index.html", categories: categories, items: images, changeset: changeset
  end

  def create(conn, %{"item" => item_params}) do
    full_list = Map.merge(FileManager.default_list, item_params)
    complete_list = update_clock_files(item_params, full_list)

    {:ok, temp_dir} = create_temp_directory(complete_list)
    {:ok, zip} = create_zip(temp_dir)

    delete_temp_dir(temp_dir)

    conn
    |> put_resp_header("content-disposition", ~s(attachment; filename="#{to_string(zip)}"))
    |> send_file(200, to_string(zip))
  end
  def create(conn, %{}) do
    %{categories: categories, items: images, changeset: changeset} = do_all_things()

    conn
    |> put_flash(:error, "Please make some selections before creating a texture pack.")
    |> render "index.html", categories: categories, items: images, changeset: changeset
  end

  def create(conn) do
    render("index.html")
  end

  defp delete_temp_dir(directory) do
    File.rm_rf("./temporary/#{directory}")
  end

  defp create_temp_directory(items) do
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
           move_file_to_temp(x, directory, FileManager.valid_path(path), FileManager.valid_name(name))
         end
       )

    copy_blockstates(directory)

    {:ok, directory}
  end

  defp create_zip(directory) do
    path = "./temporary"
    categories = FileManager.categories()

    items = categories
            |> Enum.reduce([], fn (category, accum) ->
              {:ok, items} = File.ls("#{path}/#{directory}/#{@full_path}/#{category}")
              correct_items = items
              |> Enum.reduce([], fn (item, item_accum) ->
                %{subcat: subcat_path, item: item} = build_subcat(item)
                item_accum ++ ["#{directory}/#{@full_path}/#{category}#{subcat_path}/#{item}"]
              end)
              accum ++ correct_items
            end)

    blockstates = elem(File.ls("#{path}/#{directory}/assets/minecraft/blockstates"), 1)
    |> Enum.reduce([], fn(file, file_accum) -> file_accum ++ ["#{directory}/assets/minecraft/blockstates/#{file}"] end)

    include_meta = items ++ ["#{directory}/pack.mcmeta"]
    include_blockstates = include_meta ++ blockstates

    files = include_blockstates
    |> Enum.map(fn (x) -> String.to_charlist(x) end)

    :zip.create(String.to_charlist("#{directory}.zip"), files, [cwd: path])
  end

  defp move_file_to_temp(source, directory, {:ok, path}, {:ok, name}) do
    [prefix: prefix] = Application.get_env(:customizer, :setup)

    %{subcat: subcat_path, item: item} = build_subcat(name)

    File.mkdir("./temporary/#{directory}/#{@full_path}/#{path}")
    File.mkdir("./temporary/#{directory}/#{@full_path}/#{path}#{subcat_path}")
    File.cp("#{prefix}/images/#{source}", "./temporary/#{directory}/#{@full_path}/#{path}#{subcat_path}/#{item}.png")

    #we need the mcmeta file for the resourcepack to work
    File.cp("#{prefix}/pack.mcmeta", "./temporary/#{directory}/pack.mcmeta")
  end

  defp move_file_to_temp(source, directory, {:ok, _}, {:error, _}), do: {:ok}
  defp move_file_to_temp(source, directory, {:error, _}, {:ok, _}), do: {:ok}
  defp move_file_to_temp(source, directory, {:error, _}, {:error, _}), do: {:ok}

  defp copy_blockstates(directory) do
    [prefix: prefix] = Application.get_env(:customizer, :setup)

    File.mkdir("./temporary/#{directory}/assets/minecraft/blockstates")
    {:ok, blockstates} = File.ls("#{prefix}/blockstates")
    blockstates
    |> Enum.each(fn(file) -> File.cp("#{prefix}/blockstates/#{file}", "./temporary/#{directory}/assets/minecraft/blockstates/#{file}") end)
  end

  defp build_subcat("subcat_" <> item) do
    [subcat_dir | pieces] = String.split(item, "_")
    item_name = Enum.join(pieces, "_")
    %{subcat: "/#{subcat_dir}", item: item_name}
  end
  defp build_subcat(item) do
    %{subcat: "", item: item}
  end

  defp do_all_things do
    [prefix: prefix] = Application.get_env(:customizer, :setup)

    changeset = Item.changeset(%Item{})

    categories = FileManager.categories()
    filenames = FileManager.file_list()

    %{categories: categories, items: filenames, changeset: changeset}
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
