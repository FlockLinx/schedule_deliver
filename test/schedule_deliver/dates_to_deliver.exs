defmodule ScheduleDeliver.DatesToDeliverTest do
  use ExUnit.Case
  alias ScheduleDeliver.DatesToDeliver

  describe "delivery_window/1" do
    test "returns {invalid_date} for empty list" do
      assert DatesToDeliver.delivery_window([]) == "{invalid_date}"
    end

    test "returns {invalid_date} for empty string" do
      assert DatesToDeliver.delivery_window("") == "{invalid_date}"
    end

    test "returns correct window for a single day within working hours" do
      start_date = "2024-05-02T09:00:00Z"
      end_date = "2024-05-02T18:00:00Z"

      expected =
        %{
          "pickingAndDelivery" => %{
            "deliveryWindow" => [
              ["2024-05-02T09:00:00Z", "2024-05-02T18:00:00Z"]
            ]
          }
        }
        |> Jason.encode!()

      assert DatesToDeliver.delivery_window([start_date, end_date]) == expected
    end

    test "returns correct windows for multi-day range" do
      start_date = "2024-05-02T09:00:00Z"
      end_date = "2024-05-04T18:00:00Z"

      expected =
        %{
          "pickingAndDelivery" => %{
            "deliveryWindow" => [
              ["2024-05-02T09:00:00Z", "2024-05-02T20:00:00Z"],
              ["2024-05-03T08:00:00Z", "2024-05-03T20:00:00Z"],
              ["2024-05-04T08:00:00Z", "2024-05-04T18:00:00Z"]
            ]
          }
        }
        |> Jason.encode!()

      assert DatesToDeliver.delivery_window([start_date, end_date]) == expected
    end

    test "adjusts window when start is before operating hours" do
      start_date = "2024-05-02T07:00:00Z"
      end_date = "2024-05-02T18:00:00Z"

      expected =
        %{
          "pickingAndDelivery" => %{
            "deliveryWindow" => [
              ["2024-05-02T08:00:00Z", "2024-05-02T18:00:00Z"]
            ]
          }
        }
        |> Jason.encode!()

      assert DatesToDeliver.delivery_window([start_date, end_date]) == expected
    end

    test "adjusts window when end is after final working hour" do
      start_date = "2024-05-02T09:00:00Z"
      end_date = "2024-05-02T19:00:00Z"

      expected =
        %{
          "pickingAndDelivery" => %{
            "deliveryWindow" => [
              ["2024-05-02T09:00:00Z", "2024-05-02T18:00:00Z"]
            ]
          }
        }
        |> Jason.encode!()

      assert DatesToDeliver.delivery_window([start_date, end_date]) == expected
    end

    test "returns correct window across two days" do
      start_date = "2024-05-02T10:00:00Z"
      end_date = "2024-05-03T16:00:00Z"

      expected =
        %{
          "pickingAndDelivery" => %{
            "deliveryWindow" => [
              ["2024-05-02T10:00:00Z", "2024-05-02T20:00:00Z"],
              ["2024-05-03T08:00:00Z", "2024-05-03T16:00:00Z"]
            ]
          }
        }
        |> Jason.encode!()

      assert DatesToDeliver.delivery_window([start_date, end_date]) == expected
    end
  end
end
