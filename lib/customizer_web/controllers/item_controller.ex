defmodule CustomizerWeb.ItemController do
  use CustomizerWeb, :controller

  import Customizer.TiledItems

  alias Customizer.Textures.Item
  alias Customizer.Textures
  alias Customizer.ZipBuilder

  @full_path "assets/minecraft/textures"

  def index(conn, params) do
    %{categories: categories, items: images, changeset: changeset} = do_all_things()

    render conn, "index.html", categories: categories, items: images, changeset: changeset
  end

  def create(conn, %{"item" => item_params}) do
    sanitized_list = item_params
    |> Map.drop(["password"])
    |> create_tiled_files()

    complete_list = Map.merge(Textures.default_list, sanitized_list)
    |> update_clock_files(item_params)

    {:ok, temp_dir} = ZipBuilder.create_temp_directory(complete_list)
    {:ok, zip} = ZipBuilder.create_zip(temp_dir)

    ZipBuilder.delete_temp_dir(temp_dir)

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

  defp do_all_things do
    [prefix: prefix] = Application.get_env(:customizer, :setup)

    changeset = Item.changeset(%Item{})

    categories = Textures.categories()
    filenames = Textures.file_list()

    %{categories: categories, items: filenames, changeset: changeset}
  end

  defp update_clock_files(full_list, item_params) do
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

  defp create_tiled_files(item_params) do
    item_params
    |> Enum.reduce(%{}, fn({key, item}, acc) ->
      if top_file?(String.replace(key, "block_", "")) do
        acc = Map.put(acc, key, item)
        Map.put(acc, lower_equiv(key), lower_equiv(item))
      else
        Map.put(acc, key, item)
      end
    end)
  end
end
