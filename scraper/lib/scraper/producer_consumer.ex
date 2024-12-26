defmodule Scraper.ProducerConsumer do
  use GenStage
  require Integer
  require Logger

  @name :producer_consumer

  def start_link(initial \\ "") do
    GenStage.start_link(__MODULE__, initial, name: @name)
  end

  #callback for start_link() function
  def init(state) do
    {:producer_consumer, state, subscribe_to: [{:producer, max_demand: 2}]}
  end

  def handle_events(events, from, state) do
    IO.puts("the events are from producerconsumer - #{inspect state}")


    {:noreply, events, state}

  end

end
