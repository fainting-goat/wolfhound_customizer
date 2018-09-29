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
    GenServer.call(:saved_selections, {:save_selections, password, selections})
  end

  def get_selections(password) do
    GenServer.call(:saved_selections, {:get_selections, password})
  end

  def verify_selection(password, file) do
    GenServer.call(:saved_selections, {:verify_selection, password, file})
  end

  #CALLBACKS

  def handle_call({:save_selections, password, selections}, _from, state) do
    if Map.has_key?(state, password) do
      {:reply, {:ok, "Keyword already exists, please use a different key."}, state}
    else
      new_state = Map.put(state, password, selections)
      {:reply, {:ok, "Your selections have been saved!"}, new_state}
    end
  end

  def handle_call({:get_selections, password}, _from, state) do
    if Map.has_key?(state, password) do
      {:reply, {:ok, state[password]}, state}
    else
      {:reply, {:error, "Invalid key."}, state}
    end
  end

  def handle_call({:verify_selection, password, file}, _from, state) do
    {:reply, Enum.member?(state[password], file), state}
  end
end
