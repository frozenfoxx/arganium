class Challenge < ApplicationRecord
  after_update_commit :send_channel_update

  # Broadcast Challenge update
  def send_channel_update
    ChallengeBroadcastJob.perform_later(self.id, self.locked?, self.solved?)
  end

  # Check if a Challenge is locked
  def self.locked?
    self.locked
  end

  # Lock a Challenge
  def lock
    self.locked = true
    self.save!
  end

  # Unlock a Challenge
  def unlock
    self.locked = false
    self.save!
  end

  # Check if a Challenge is solved
  def solved?
    self.solved
  end

  # Solve a Challenge
  def solve
   self.solved = true
   self.save!
  end
end
