# ScheduleDeliver

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

This application receives and response JSON parameters, to validate start the application and curl the command


```elixir
curl --location --request POST 'http://localhost:4000/api/deliver_dates' \
--header 'Content-Type: application/json' \
--data '{
  "pickingAndDelivery": {
    "deliveryWindow": [
      "2024-05-02 09:00:00Z",
      "2024-05-03 18:00:00Z"
    ]
  }
}'
```

Its possible to play with differents range of dates.

[]
