class GameLog < ApplicationRecord
  after_create_commit { GameLogBroadcastJob.perform_later self }
end
