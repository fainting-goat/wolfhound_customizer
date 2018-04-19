defmodule ArrangeFiles do
  def varients do
    {:ok, varients} = File.ls("priv/static/files/")
    varients
  end

  def create_folder(filename, category) do
    if String.match?(filename, ~r/.png$/) do
      File.mkdir("priv/static/images/#{category}/#{String.replace(filename, ".png", "")}")
    end
  end

  def copy_files(source_path, filename, category) do
    Enum.each(varients(), fn(varient) ->
      if String.match?(filename, ~r/.png$/) do
        File.rename(String.replace(source_path, "default", varient), "priv/static/images/#{category}/#{String.replace(filename, ".png", "")}/#{varient}.png")
      end
    end)
  end

  def enumerate_files(folder, path, target_name, category) do
    {:ok, folders} = File.ls(path <> folder)
    folders
    |> Enum.each(fn(file) ->
      manage_files(file, "#{path}#{folder}/", target_name, category)
    end)
  end

  def manage_files(filename, path, target_name, category) do
    case File.dir?(path <> filename) do
      true -> enumerate_files(filename, path, target_name <> "sub_#{filename}_", category)
      _ -> create_folder("#{target_name}#{filename}", category)
           copy_files(path <> filename, "#{target_name}#{filename}", category)
    end
  end
end


prefix = "assets/minecraft"

{:ok, categories} = File.ls("priv/static/files/default/#{prefix}/textures")

categories = Enum.filter(categories, fn(x) -> File.dir?("priv/static/files/default/#{prefix}/textures/#{x}") end)

Enum.each(categories, fn(x) -> File.mkdir("priv/static/images/#{x}") end)
Enum.each(categories, fn(x) -> ArrangeFiles.enumerate_files(x, "priv/static/files/default/#{prefix}/textures/", "", x) end)
