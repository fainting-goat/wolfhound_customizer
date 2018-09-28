defmodule CustomizerWeb.ItemChannel do
  use Phoenix.Channel
  alias Phoenix.HTML.FormData
  alias Customizer.Textures.Item
  alias Customizer.SavedSelections

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
    |> Phoenix.View.render_to_string("category.html", category: category, conn: socket, changeset: changeset, f: f, reload: false)
    |> push_html("item_response", category, socket)
  end
  def handle_in("get_selections", %{"keyword" => keyword}, socket) do
    changeset = Item.changeset(%Item{})

    socket = assign(socket, :keyword, keyword)

    f =
      %Item{}
      |> Item.changeset()
      |> FormData.to_form([])

    CustomizerWeb.ItemView
    |> Phoenix.View.render_to_string("category.html", category: "colormap", conn: socket, changeset: changeset, f: f, reload: true)
    |> push_html("load_response", "colormap", socket)
  end
  def handle_in("set_selections", %{"keyword" => keyword, "selections" => selections}, socket) do
    SavedSelections.save_selections(keyword, selections)
    socket = assign(socket, :keyword, keyword)
    {:noreply, socket}
  end

  defp push_html(html, channel, category, socket) do
    push(socket, channel, %{html: html, category: category})
    {:noreply, socket}
  end
end
