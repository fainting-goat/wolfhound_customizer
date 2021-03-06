defmodule CustomizerWeb.ItemChannel do
  use Phoenix.Channel
  alias Phoenix.HTML.FormData
  alias Customizer.SaveManager

  def join("item", _message, socket) do
    {:ok, socket}
  end

  def handle_in("images", %{"category" => category}, socket) do
    CustomizerWeb.ItemView
    |> Phoenix.View.render_to_string("category.html", category: category, conn: socket)
    |> push_html("item_response", category, socket)
  end
  def handle_in("get_selections", %{"keyword" => keyword}, socket) do
    results = SaveManager.get_selections(keyword)
    socket = push_results_of_load(socket, keyword, results)

    {:noreply, socket}
  end
  def handle_in("set_selections", %{"keyword" => keyword, "selections" => selections}, socket) do
    results = SaveManager.save_selections(keyword, selections)
    push_results_of_save(socket, results)

    {:noreply, socket}
  end

  defp push_html(html, channel, category, socket) do
    push(socket, channel, %{html: html, category: category})
    {:noreply, socket}
  end

  def push_results_of_load(socket, keyword, {:ok, selections}) do
    #only assign this if we're successful, otherwise bad things happen later
    socket = assign(socket, :keyword, keyword)

    push(socket, "load_response", %{selections: selections, message: "Load successful!"})
    socket
  end
  def push_results_of_load(socket, _, {:error, message}) do
    push(socket, "load_response", %{selections: [], message: message})
    socket
  end

  def push_results_of_save(socket, {:ok, message}) do
    push(socket, "save_response", %{message: message})
  end
  def push_results_of_save(socket, {:error, message}) do
    push(socket, "save_response", %{message: message})
  end
end
