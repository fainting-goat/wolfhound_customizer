defmodule CustomizerWeb.ItemChannel do
  use Phoenix.Channel
  alias Phoenix.HTML.FormData
  alias Customizer.Textures.Item
  alias Customizer.SavedSelections

  @categories ["block", "colormap", "entity", "environment", "font", "gui", "item", "map", "models", "painting", "particle"]

  def join("item", _message, socket) do
    {:ok, socket}
  end

  def handle_in("images", %{"category" => category}, socket) do
    changeset = Item.changeset(%Item{})

    f =
      %Item{}
      |> Item.changeset()
      |> FormData.to_form([])

    CustomizerWeb.ItemView
    |> Phoenix.View.render_to_string("category.html", category: category, conn: socket, changeset: changeset, f: f)
    |> push_html("item_response", category, socket)
  end
  def handle_in("get_selections", %{"keyword" => keyword}, socket) do
    results = SavedSelections.get_selections(keyword)
    push_results_of_load(socket, results, keyword)

    {:noreply, socket}
  end
  def handle_in("set_selections", %{"keyword" => keyword, "selections" => selections}, socket) do
    results = SavedSelections.save_selections(keyword, selections)

    push_results_of_save(socket, results)

    {:noreply, socket}
  end

  defp push_html(html, channel, category, socket) do
    push(socket, channel, %{html: html, category: category})
    {:noreply, socket}
  end

  def push_results_of_load(socket, {:ok, selections}, keyword) do
    socket = assign(socket, :keyword, keyword) #only assign key if we're successful
    push(socket, "load_response", %{selections: selections, message: "Load successful!"})
  end
  def push_results_of_load(socket, {:error, "Invalid key."}, _) do
    push(socket, "load_response", %{selections: [], message: "Key does not exist."})
  end
  def push_results_of_load(socket, {:error, message}, _) do
    push(socket, "load_response", %{selections: [], message: "Something has gone horribly wrong. Please send this to Thistle: #{message}"})
  end

  def push_results_of_save(socket, {:ok, message}) do
    push(socket, "save_response", %{message: message})
  end
  def push_results_of_save(socket, {:error, message}) do
    push(socket, "save_response", %{message: "Something has gone horribly wrong. Please send this to Thistle: #{message}"})
  end
end
