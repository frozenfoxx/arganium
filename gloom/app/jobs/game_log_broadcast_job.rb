class GameLogBroadcastJob < ApplicationJob
  queue_as :default

  def perform(logmessage)
    ActionCable.server.broadcast 'game_channel', gamelog: render_logmessage(logmessage)
  end

  private
    def render_logmessage(logmessage)
      ApplicationController.renderer.render(partial: 'gamelogs/gamelog-raw', locals: { gamelog: logmessage })
    end
end
