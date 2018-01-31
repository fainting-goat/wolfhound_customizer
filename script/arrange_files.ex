require IEx

#this was the first elixir I wrote please don't judge

prefix = "assets/minecraft"
{:ok, varients} = File.ls("priv/static/files/")
{:ok, categories} = File.ls("priv/static/files/default/#{prefix}/textures")

categories = Enum.filter(categories, fn(x) -> File.dir?("priv/static/files/default/#{prefix}/textures/#{x}") end)

Enum.each(categories, fn(x) -> File.mkdir("priv/static/images/#{x}") end)

#subcategories
Enum.map(categories, fn(x) ->
  {:ok, folders} = File.ls("priv/static/files/default/#{prefix}/textures/#{x}")

  folders
  |> Enum.filter(fn(s) -> File.dir?("priv/static/files/default/#{prefix}/textures/#{x}/#{s}") end)
  |> Enum.each(fn(category) ->
    {:ok, images} = File.ls("priv/static/files/default/#{prefix}/textures/#{x}/#{category}")

    #create folders
    images
    |> Enum.filter(fn(n) -> String.match?(n, ~r/.png$/) end)
    |> Enum.map(fn(n) -> String.replace(n, ".png", "") end)
    |> Enum.each(fn(n) -> File.mkdir("priv/static/images/#{x}/subcat_#{category}_#{n}") end)

    #copy files
    Enum.each(varients, fn(varient) ->
      images
      |> Enum.filter(fn(n) -> String.match?(n, ~r/.png$/) end)
      |> Enum.map(fn(n) -> String.replace(n, ".png", "") end)
      |> Enum.each(fn(n) -> File.rename("priv/static/files/#{varient}/#{prefix}/textures/#{x}/#{category}/#{n}.png", "priv/static/images/#{x}/subcat_#{category}_#{n}/#{varient}.png") end)
    end)
  end)
end)

Enum.each(categories, fn(category) ->
  {:ok, files} = File.ls("priv/static/files/default/#{prefix}/textures/#{category}")

#create folders
  files
  |> Enum.filter(fn(x) -> String.match?(x, ~r/.png$/) end)
  |> Enum.map(fn(x) -> String.replace(x, ".png", "") end)
  |> Enum.each(fn(x) -> File.mkdir("priv/static/images/#{category}/#{x}") end)

#copy files
  Enum.each(varients, fn(varient) ->
    files
    |> Enum.filter(fn(x) -> String.match?(x, ~r/.png$/) end)
    |> Enum.map(fn(x) -> String.replace(x, ".png", "") end)
    |> Enum.each(fn(x) -> File.rename("priv/static/files/#{varient}/#{prefix}/textures/#{category}/#{x}.png", "priv/static/images/#{category}/#{x}/#{varient}.png") end)
  end)
end)
