defmodule ScheduleDeliverWeb.ScheduleController do
  use ScheduleDeliverWeb, :controller

  alias ScheduleDeliver.DatesToDeliver

  def deliver_dates(conn, %{"pickingAndDelivery" => %{"deliveryWindow" => window}})
      when is_list(window) do
    json(conn, DatesToDeliver.delivery_window(window))
  end
end
