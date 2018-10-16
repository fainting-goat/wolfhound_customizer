defmodule Customizer.SavedSelections do
  use GenServer

  def start_link(selections) do
    GenServer.start_link(__MODULE__, selections)
  end

  def init(state) do
    {:ok, {state, chunk_selections(state)}}
  end

  #API

  def get_state(pid) do
    GenServer.call(pid, {:get_state})
  end

  def get_original_list(pid) do
    GenServer.call(pid, {:get_original_list})
  end

  def verify_file(pid, file) do
    GenServer.call(pid, {:verify_file, file})
  end

  #CALLBACKS

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:get_original_list}, _from, {original_list, _} = state) do
    {:reply, {:ok, original_list}, state}
  end

  def handle_call({:verify_file, file}, _from, {_, parsed_map} = state) do
    [group_key, item_key, item_value] = String.split(file, "/")

    case parsed_map[group_key][item_key] do
      ^item_value -> {:reply, {:ok, true}, state}
      _ -> {:reply, {:ok, false}, state}
    end
  end

  defp chunk_selections(selections) do
    selections
    |> Enum.reduce(%{}, fn(item, acc) ->
      [group_key, item_key, item_value] = String.split(item, "/")

      if Map.has_key?(acc, group_key) do
        put_in(acc, [group_key, item_key], item_value)
      else
        Map.put(acc, group_key, %{item_key => item_value})
      end
    end)
  end
end
