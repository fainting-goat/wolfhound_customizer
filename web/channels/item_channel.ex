defmodule Customizer.ItemChannel do
  use Phoenix.Channel
  alias Phoenix.HTML.FormData
  alias Customizer.Item

  def join("item", _message, socket) do
    {:ok, socket}
  end

  def handle_in("images", %{"category" => category}, socket) do
    changeset = Item.changeset(%Item{})

    f =
      %Item{}
      |> Item.changeset()
      |> FormData.to_form([])

    Customizer.ItemView
    |> Phoenix.View.render_to_string("category.html", category: category, conn: socket, changeset: changeset, f: f)
    |> broadcast_html(category, socket)
  end

  defp broadcast_html(html, category, socket) do
    broadcast!(socket, "item_response", %{html: html, category: category})
    {:noreply, socket}
  end
end
