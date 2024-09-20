defmodule ScheduleDeliverWeb.ScheduleControllerTest do
  use ScheduleDeliverWeb.ConnCase

  alias ScheduleDeliver.DatesToDeliver

  describe "deliver_dates/2" do
    test "returns the correct delivery window when given valid input", %{conn: conn} do
      valid_window = [
        "2024-05-02T09:00:00Z",
        "2024-05-03T18:00:00Z"
      ]

      conn =
        post(conn, "/api/deliver_dates", %{
          "pickingAndDelivery" => %{"deliveryWindow" => valid_window}
        })

      expected_response = 
        "{\"pickingAndDelivery\":{\"deliveryWindow\":[[\"2024-05-02T09:00:00Z\",\"2024-05-02T20:00:00Z\"],[\"2024-05-03T08:00:00Z\",\"2024-05-03T18:00:00Z\"]]}}"


      assert json_response(conn, 200) == expected_response
    end
  end
end
