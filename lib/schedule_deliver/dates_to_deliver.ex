defmodule ScheduleDeliver.DatesToDeliver do
  @moduledoc false
  use Timex
  def delivery_window([]), do: "{invalid_date}"
  def delivery_window(""), do: "{invalid_date}"

  def delivery_window([start_date, end_date]) do
    start_dt = Timex.parse!(start_date, "{ISO:Extended:Z}")
    end_dt = Timex.parse!(end_date, "{ISO:Extended:Z}")

    windows_list = Enum.reverse(adjust_window(start_dt, end_dt, []))

    delivery_response(windows_list)
  end

  defp adjust_window(start_dt, end_dt, acc) do
    start_date = Timex.to_date(start_dt)
    end_date = Timex.to_date(end_dt)

    if start_date == end_date do
      adjusted_start_dt = adjust_day_start(start_dt)
      adjusted_end_dt = adjust_day_end(end_dt)
      [%{start: adjusted_start_dt, end: adjusted_end_dt} | acc]
    else
      adjusted_start_dt = adjust_day_start(start_dt)

      next_day_start = Timex.shift(start_dt, days: 1) |> Timex.set(hour: 8, minute: 0, second: 0)

      adjusted_end_of_day =
        Timex.format!(Timex.set(start_dt, hour: 20, minute: 0, second: 0), "{ISO:Extended}")
        |> String.replace("+00:00", "Z")

      adjust_window(next_day_start, end_dt, [
        %{start: adjusted_start_dt, end: adjusted_end_of_day} | acc
      ])
    end
  end

  defp adjust_day_start(start_dt) do
    if start_dt.hour < 8 do
      Timex.set(start_dt, hour: 8, minute: 0, second: 0)
    else
      start_dt
    end
    |> Timex.format!("{ISO:Extended}")
    |> String.replace("+00:00", "Z")
  end

  defp adjust_day_end(end_dt) do
    if end_dt.hour > 18 do
      Timex.set(end_dt, hour: 18, minute: 0, second: 0)
    else
      end_dt
    end
    |> Timex.format!("{ISO:Extended}")
    |> String.replace("+00:00", "Z")
  end

  defp delivery_response(adjusted_windows) do
    %{
      "pickingAndDelivery" => %{
        "deliveryWindow" => format_windows(adjusted_windows)
      }
    }
    |> Jason.encode!()
  end

  defp format_windows(windows) do
    windows
    |> Enum.map(fn %{start: start, end: end_time} ->
      [start, end_time]
    end)
  end
end
