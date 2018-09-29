defmodule Customizer.SavedSelections do
  use GenServer

  def start_link(selections) do
    GenServer.start_link(__MODULE__, selections)
  end

  def init(state) do
    {:ok, state}
  end

  #API

  def get_state(pid) do
    GenServer.call(pid, {:get_state})
  end

  def verify_file(pid, file) do
    GenServer.call(pid, {:verify_file, file})
  end

  #CALLBACKS

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:verify_file, file}, _from, state) do
    {:reply, {:ok, Enum.member?(state, file)}, state}
  end
end
