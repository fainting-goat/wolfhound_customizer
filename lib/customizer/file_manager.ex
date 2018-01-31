defmodule Customizer.FileManager do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: :file_manager)
  end

  def init(state) do
    [prefix: prefix] = Application.get_env(:customizer, :setup)

    default_items = build_default_list(prefix)
    category_list = get_categories(prefix)
    file_list = get_image_names(category_list, prefix)

    {:ok, %{default: default_items, categories: category_list, filenames: file_list}}
  end

  #API

  def default_list do
    GenServer.call(:file_manager, :default_list)
  end

  def categories do
    GenServer.call(:file_manager, :categories)
  end

  def file_list do
    GenServer.call(:file_manager, :file_list)
  end

  #CALLBACKS

  def handle_call(:default_list, _from, state) do
    {:reply, state.default, state}
  end

  def handle_call(:categories, _from, state) do
    {:reply, state.categories, state}
  end

  def handle_call(:file_list, _from, state) do
    {:reply, state.filenames, state}
  end

  #HELPERS

  defp build_default_list(prefix) do
    categories = File.ls("#{prefix}images/")
                 |> elem(1)
                 |> Enum.filter(fn (x) -> File.dir?("#{prefix}images/#{x}") && x != ".DS_Store" end)

    files = categories
            |> Enum.reduce(
                 %{},
                 fn (category, accum) ->
                   images = elem(File.ls("#{prefix}images/#{category}/"), 1)
                            |> Enum.filter(fn (x) -> x != ".DS_Store" end)
                   result = images
                            |> Enum.reduce(%{}, fn (x, accum) -> Map.put(accum, x, "#{category}/#{x}/default.png") end)
                   Map.merge(accum, result)
                 end
               )

    files
  end

  #["cat1", "cat2"]
  defp get_categories(prefix) do
    File.ls("#{prefix}images/")
    |> elem(1)
    |> Enum.filter(fn (x) -> File.dir?("#{prefix}images/#{x}") && x != ".DS_Store" end)
    |> Enum.sort
  end

  #[cat1: ["filename1", "filename2"], cat2: ["filename1", "filename2"]]
  defp get_image_names(categories, prefix) do
    categories
    |> Enum.map(fn (category) -> images = elem(File.ls("#{prefix}images/#{category}/"), 1)
                                          |> Enum.reject(fn(x) -> x == ".DS_Store" end)
                                          |> Enum.reject(fn(image_name) -> only_one_file(prefix, category, image_name) end)
                                          |> Enum.reject(fn(image_name) -> hide_clock_files(image_name) end)

                                 build_category_list(category, images, prefix)
    end)
  end

  defp build_category_list(category, images, prefix) do
    {String.to_atom(category), items = get_list_of_images(images, category, prefix)}
  end

  defp get_list_of_images(images, category, prefix) do
    images
    |> Enum.map(fn (image_name) -> files = elem(File.ls("#{prefix}images/#{category}/#{image_name}"), 1)
                                           |> Enum.filter(fn (x) -> x != ".DS_Store" end)
                                   {image_name, files}
    end)
  end

  defp only_one_file(prefix, category, image_name) do
    result = elem(File.ls("#{prefix}images/#{category}/#{image_name}"), 1)
             |> Enum.reject(fn(x) -> x == ".DS_Store" end)
             |> Enum.count

    result == 1
  end

  defp hide_clock_files("clock_00") do
    false
  end
  defp hide_clock_files("clock" <> number) do
    true
  end
  defp hide_clock_files(_) do
    false
  end
end
