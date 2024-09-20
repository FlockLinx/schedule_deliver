defmodule ScheduleDeliverWeb.Router do
  use ScheduleDeliverWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ScheduleDeliverWeb do
    pipe_through :api
    post "/deliver_dates", ScheduleController, :deliver_dates
  end
end
