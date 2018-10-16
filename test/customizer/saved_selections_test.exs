defmodule Customizer.SavedSelectionsTest do
  use ExUnit.Case
  alias Customizer.SavedSelections

  setup do
    test_selections = ["colormap/foliage/autumn.png", "colormap/grass/default.png", "painting/paintings_kristoffer_zetterstrand/fantasy.png"]
    chunked_selections = %{
      "colormap" => %{"foliage" => "autumn.png", "grass" => "default.png"},
      "painting" => %{"paintings_kristoffer_zetterstrand" => "fantasy.png"}
    }
    {:ok, pid} = GenServer.start_link(SavedSelections, test_selections)

    %{
      pid: pid,
      test_selections: test_selections,
      chunked_selections: chunked_selections
    }
  end

  describe "init" do
    test "divides up the selections by category", %{pid: pid, test_selections: test_selections, chunked_selections: chunked_selections} do
      assert {:ok, {test_selections, chunked_selections}} == SavedSelections.get_state(pid)
    end
  end

  describe "handle_call - get_original_list puts it back into a list" do
    test "returns the state", %{test_selections: test_selections, chunked_selections: chunked_selections} do
      assert {:reply, {:ok, test_selections}, {test_selections, chunked_selections}} == SavedSelections.handle_call(
               {:get_original_list}, nil, {test_selections, chunked_selections}
             )
    end
  end

  describe "handle_call - verify_file" do
    test "returns true if value is in state", %{chunked_selections: chunked_selections} do
      assert {:reply, {:ok, true}, chunked_selections} = SavedSelections.handle_call(
               {:verify_file, "colormap/foliage/autumn.png"}, nil, {[], chunked_selections}
             )
    end

    test "returns false if value is not in state", %{chunked_selections: chunked_selections} do
      assert {:reply, {:ok, false}, chunked_selections} = SavedSelections.handle_call(
               {:verify_file, "colormap/foliage/summer.png"}, nil, {[], chunked_selections}
             )
    end

    test "returns false if key value is not in state", %{chunked_selections: chunked_selections} do
      assert {:reply, {:ok, false}, chunked_selections} = SavedSelections.handle_call(
               {:verify_file, "blocks/foliage/autumn.png"}, nil, {[], chunked_selections}
             )
    end
  end
end
