defmodule Customizer.SavedSelections do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: :saved_selections)
  end

  def init(state) do
    {:ok, %{}}
  end

  #API

  def save_selections(password, selections) do
    GenServer.cast(:saved_selections, {:save_selections, password, selections})
  end

  def get_selections(password) do
    GenServer.call(:saved_selections, {:get_selections, password})
  end

  #CALLBACKS

  def handle_cast({:save_selections, password, selections}, state) do
    new_state = Map.put(state, password, selections)
    {:noreply, new_state}
  end

  def handle_call({:get_selections, password}, _from, state) do
    {:reply, state[password], state}
  end
end
