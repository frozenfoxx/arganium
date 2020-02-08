class ChallengeBroadcastJob < ApplicationJob
  queue_as :default

  def perform(challengeid, locked, solved)
    ActionCable.server.broadcast 'room_channel', challengeid: challengeid, locked: locked, solved: solved
  end
end
