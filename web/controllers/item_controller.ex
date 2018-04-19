defmodule Customizer.ItemController do
  use Customizer.Web, :controller
  alias Customizer.Item
  alias Customizer.FileManager
  alias Customizer.ZipBuilder

  @full_path "assets/minecraft/textures"

  def index(conn, params) do
    %{categories: categories, items: images, changeset: changeset} = do_all_things()

    render conn, "index.html", categories: categories, items: images, changeset: changeset
  end

  def create(conn, %{"item" => item_params}) do
    full_list = Map.merge(FileManager.default_list, item_params)
    complete_list = update_clock_files(item_params, full_list)

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
