defmodule Scraper.Consumer do
  use GenStage
  require Logger

  def start_link(args \\ "") do
    GenStage.start_link(__MODULE__, args)
  end

  # callback for start_link function
  def init(state) do
    Logger.info("Init Consuming words")
    {:consumer, state, subscribe_to: [:producer]}
  end

  def handle_events(events, from, state) do
    Logger.info("Consumer State: #{state}")
    Process.sleep(5000)
    words = Enum.join(events)
    Process.sleep(5000)
    sentence = state <> words
    # Wait for a second.
    Logger.info("Final State: #{sentence}")
    {:noreply, [], sentence}
  end

end
