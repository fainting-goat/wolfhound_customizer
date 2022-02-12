defmodule Customizer.SaveManager do
  use GenServer

  alias Customizer.SavedSelections

  def start_link(_params) do
    GenServer.start_link(__MODULE__, %{}, name: :saved_selections)
  end

  def init(_state) do
    state = load_state_from_file()
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  def handle_info({:EXIT, _from, reason}, state) do
    save_state(state)
    {:stop, reason, state}
  end

  def terminate(_reason, state) do
    save_state(state)
    state
  end

  def load_state_from_file() do
    File.ls("./temporary")
    |> elem(1)
    |> Enum.reject(fn(x) -> !String.contains?(x, ".txt") end)
    |> Enum.reduce(%{}, fn(file,acc) ->
      {keyword, pid} = load_file_to_process(file)
      acc = Map.put(acc, keyword, {pid, DateTime.utc_now()})
      File.rm("./temporary/#{file}")

      acc
    end)
  end

  def save_state(state) do
    Enum.each(state, fn({key, {pid, _}}) ->
      selections = SavedSelections.get_original_list(pid)
      |> elem(1)
      |> Enum.join(",")

      File.write("./temporary/#{key}.txt", selections)
    end)
  end

  def load_file_to_process(file) do
    selections = File.read("./temporary/#{file}")
    |> elem(1)
    |> String.split(",")

    keyword = file
    |> String.split(".")
    |> List.first()

    {keyword, start_child_process(selections)}
  end

  #API

  def save_selections(password, selections, datetime_stub \\ DateTime) do
    GenServer.call(:saved_selections, {:save_selections, password, selections, datetime_stub})
  end

  def get_selections(password) do
    GenServer.call(:saved_selections, {:get_selections, password})
  end

  def verify_selection(password, file) do
    GenServer.call(:saved_selections, {:verify_selection, password, file})
  end

  #CALLBACKS

  def handle_call({:save_selections, password, selections, datetime_stub}, _from, state) do
    cond do
      !valid_key?(password) -> {:reply, {:error, "Letters and numbers only, please."}, state}
      Map.has_key?(state, password) -> {:reply, {:ok, "Keyword already exists, please use a different key."}, state}
      true ->
        pid = start_child_process(selections)
        new_state = Map.put(state, password, {pid, datetime_stub.utc_now()})

        {:reply, {:ok, "Your selections have been saved!"}, new_state}
    end
  end

  def handle_call({:get_selections, password}, _from, state) do
    cond do
      !valid_key?(password) -> {:reply, {:error, "Letters and numbers only, please."}, state}
      Map.has_key?(state, password) ->
        pid = get_pid(password, state)
        {:ok, selections} = SavedSelections.get_original_list(pid)
        {:reply, {:ok, selections}, state}
      true -> {:reply, {:error, "Keyword does not exist."}, state}
    end
  end

  def handle_call({:verify_selection, password, file}, _from, state) do
    pid = get_pid(password, state)
    {:ok, verification} = SavedSelections.verify_file(pid, file)

    {:reply, verification, state}
  end

  def get_pid(password, state) do
    {pid, _} = state[password]
    pid
  end

  def valid_key?(password) do
    String.split(password, "")
    |> Enum.drop(1)
    |> Enum.drop(-1)
    |> Enum.all?(fn(x) -> Regex.match?(~r/[A-Za-z0-9]/, x) end)
  end

  def start_child_process(selections) do
    {:ok, pid} = GenServer.start_link(SavedSelections, selections)
    pid
  end
end
