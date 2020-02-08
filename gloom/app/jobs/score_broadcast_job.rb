class ScoreBroadcastJob < ApplicationJob
  queue_as :default

  def perform(type, score)
    case type
      when 'time'
        ActionCable.server.broadcast 'score_channel', time: score
      when 'kills'
        ActionCable.server.broadcast 'score_channel', kills: score
      when 'secrets'
        ActionCable.server.broadcast 'score_channel', secrets: score
      when 'challenges'
        ActionCable.server.broadcast 'score_channel', challenges: score
      when 'total'
        ActionCable.server.broadcast 'score_channel', total: score
      else
	puts 'Unhandled type'
      end
  end
end
