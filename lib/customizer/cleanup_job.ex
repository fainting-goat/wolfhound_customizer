defmodule Customizer.CleanupJob do
  use GenServer

  def start_link(_params) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    {:ok, dir_contents} = File.ls("./")

    dir_contents
    |> Enum.filter(fn(x) -> String.match?(x, ~r/.zip$/) end)
    |> Enum.each(fn(x) -> File.rm(x) end)

    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 2 * 60 * 60 * 1000) # In 2 hours
  end
end
