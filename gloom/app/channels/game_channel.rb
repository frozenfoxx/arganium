# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.

class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def relay(data)
    # Process the input from game_channel
    datastring = data['message']
  end
end
