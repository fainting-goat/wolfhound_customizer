defmodule Customizer.Textures do
  use GenServer

  alias Customizer.Textures.SubCategory

  import Customizer.CustomCategoryHelper

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: :file_manager)
  end

  def init(_) do
    [prefix: prefix] = Application.get_env(:customizer, :setup)

    default_items = build_default_list(prefix)
    category_list = get_categories(prefix)
    file_list = get_image_names(prefix)
    custom_categories = custom_category_names()

    {:ok, %{default: default_items, categories: category_list, filenames: file_list, custom_categories: custom_categories}}
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

  def custom_categories(category) do
    GenServer.call(:file_manager, {:custom_categories, category})
  end

  def valid_params(params) do
    GenServer.call(:file_manager, {:valid_params, params})
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

  def handle_call({:custom_categories, category}, _from, state) do
    if Map.has_key?(state.custom_categories, category) do
      {:reply, state.custom_categories[category], state}
    else
      {:reply, [], state}
    end
  end

  def handle_call({:valid_params, params}, _from, state) do
    [path, name, _] = String.split(params, "/")

    {:reply, {valid_path(path, state.categories), valid_name(name, path, state.default)}, state}
  end

  #HELPERS

  def valid_path(path, categories) do
    case Enum.member?(categories, path) do
      true -> path
      _ -> {:error, "invalid path"}
    end
  end

  def valid_name(name, path, default) do
    case Map.has_key?(default, "#{path}_#{name}") do
      true -> name
      _ -> {:error, "invalid filename"}
    end
  end

  #different format because this is used to fill in the defaults during zip creation
  defp build_default_list(prefix) do
    Enum.reduce(get_categories(prefix), %{}, fn (category, accum) ->
      File.ls("#{prefix}images/#{category}/")
      |> elem(1)
      |> remove_system_files
      |> Enum.reduce(%{}, fn (x, accum) -> Map.put(accum, "#{category}_#{x}", "#{category}/#{x}/default.png") end)
      |> Map.merge(accum)
     end)
  end

  defp get_image_names(prefix) do
    File.ls("#{prefix}images/")
    |> elem(1)
    |> remove_system_files
    |> Enum.filter(fn (x) -> File.dir?("#{prefix}images/#{x}") end)
    |> Enum.reduce(%{}, fn(category, accum) -> Map.put(accum, category, collect_sub_categories("#{prefix}images/#{category}")) end)
  end

  defp collect_sub_categories(path) do
    File.ls(path)
    |> elem(1)
    |> remove_system_files
    |> Enum.reject(fn(image_name) -> hide_clock_files(image_name) end)
    |> Enum.reject(fn(image_name) -> only_one_file("#{path}/#{image_name}") end)
    |> Enum.reduce([], fn(sub_cat, accum) ->
      [%SubCategory{name: sub_cat, custom_category: sub_category_name(sub_cat), files: collect_files("#{path}/#{sub_cat}")} | accum]
    end)
  end

  defp collect_files(path) do
    File.ls(path)
    |> elem(1)
    |> remove_system_files
  end

  #["cat1", "cat2"]
  defp get_categories(prefix) do
    File.ls("#{prefix}images/")
    |> elem(1)
    |> remove_system_files
    |> Enum.filter(fn (x) -> File.dir?("#{prefix}images/#{x}") end)
    |> Enum.sort
  end

  defp remove_system_files(file_list) do
    Enum.reject(file_list, fn(x) -> x == ".DS_Store" end)
  end

  defp only_one_file(path) do
    result = File.ls(path)
    |> elem(1)
    |> remove_system_files
    |> Enum.count

    result == 1
  end

  defp hide_clock_files("clock_00"), do: false
  defp hide_clock_files("clock" <> _), do: true
  defp hide_clock_files(_), do: false

  defp sub_category_name(sub_cat) do
    if Map.has_key?(custom_category_map(), sub_cat) do
      custom_category_map()[sub_cat]
    else
      ""
    end
  end
end
