defmodule ScheduleDeliverWeb.Router do
  use ScheduleDeliverWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ScheduleDeliverWeb do
    pipe_through :api
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:schedule_deliver, :dev_routes) do

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
