class Secret < ApplicationRecord

  # Increment the number of redeemed Secrets
  def incredeemed
    increment(:redeemed)
    save!
  end

  def increment_found_count
    increment(:found)
    save!
  end
end
