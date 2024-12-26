defmodule Scraper.Producer do
  use GenStage

  @name :producer

  def start_link(init \\ "") do
    GenStage.start_link(__MODULE__, init, name: @name)
  end

  #callback for start_link
  def init(counter) do
    {:producer, counter}
  end

  def handle_demand(demand, state) when demand > 0 do
    IO.inspect("Demand: #{demand}, state: #{state}", label: "STATE")
    letters =
      state
      |> String.graphemes()
    letters_to_consume = Enum.take(letters, demand)
    sentence_left = String.slice(state, demand, length(letters))
    {:noreply, letters_to_consume, sentence_left}
  end


end
