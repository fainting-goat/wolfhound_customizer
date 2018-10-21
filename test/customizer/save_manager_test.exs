defmodule Customizer.SaveManagerTest do
  use ExUnit.Case
  alias Customizer.SaveManager

  import Double

  setup do
    SaveManager.start_link()

    saved_selections_stub = Customizer.SavedSelections
                       |> double()
                       |> allow(:init, fn(_data) -> {:ok, "pid"}  end)
    datetime_stub = DateTime
                            |> double()
                            |> allow(:utc_now, fn() -> "time"  end)

    %{
      saved_selections_stub: saved_selections_stub,
      datetime_stub: datetime_stub
    }
  end

  describe "handle_call - save_selections" do
    test "registers the selections and stores the pid", %{datetime_stub: datetime_stub} do
      assert {:reply, {:ok, "Your selections have been saved!"}, state} = SaveManager.handle_call(
               {:save_selections, "keyword", "junk", datetime_stub}, nil, %{}
             )
      assert Map.has_key?(state, "keyword")
    end

    test "returns an error when the key already exists", %{saved_selections_stub: saved_selections_stub, datetime_stub: datetime_stub} do
      assert {:reply, {:ok, "Keyword already exists, please use a different key."}, state} = SaveManager.handle_call(
               {:save_selections, "keyword", "junk", datetime_stub}, nil, %{"keyword" => "junk"}
             )
      assert Map.has_key?(state, "keyword")
    end

    test "returns an error when the key has invalid characters", %{saved_selections_stub: saved_selections_stub, datetime_stub: datetime_stub} do
      assert {:reply, {:error, "Letters and numbers only, please."}, state} = SaveManager.handle_call(
               {:save_selections, "!@1#$a!3#^&a3", "junk", datetime_stub}, nil, %{}
             )
    end

    test "accepts letters and numbers", %{saved_selections_stub: saved_selections_stub, datetime_stub: datetime_stub} do
      assert {:reply, {:ok, "Your selections have been saved!"}, state} = SaveManager.handle_call(
               {:save_selections, "junk123", "junk", datetime_stub}, nil, %{}
             )
      assert Map.has_key?(state, "junk123")

      assert {:reply, {:ok, "Your selections have been saved!"}, state} = SaveManager.handle_call(
               {:save_selections, "123", "junk", datetime_stub}, nil, %{}
             )

      assert Map.has_key?(state, "123")
    end
  end

  describe "handle_call - get_selections" do
    test "returns the state for the keyword" do
      SaveManager.save_selections("keyword", [1, 2])
      assert {:ok, [1,2]} = SaveManager.get_selections("keyword")
    end

    test "returns error when key doesn't exist" do
      SaveManager.save_selections("keyword", [1, 2])
      assert {:error, "Keyword does not exist."} = SaveManager.get_selections("fake")
    end

    test "returns error when key contains invalid characters" do
      assert {:error, "Letters and numbers only, please."} = SaveManager.get_selections("!@1#$a!3#^&a3")
    end

    test "accepts letters and numbers" do
      SaveManager.save_selections("junk123", [1, 2])
      assert {:ok, [1,2]} = SaveManager.get_selections("junk123")

      SaveManager.save_selections("123", [1, 2])
      assert {:ok, [1,2]} = SaveManager.get_selections("123")
    end
  end

  describe "handle_call - verify_selection" do
    test "confirms if an element exists for a keyword" do
      SaveManager.save_selections("keyword", [1, 2])
      assert SaveManager.verify_selection("keyword", 1)
    end

    test "confirms if an element does not exist for a keyword" do
      SaveManager.save_selections("keyword", [1, 2])
      assert !SaveManager.verify_selection("keyword", 3)
    end
  end
end
