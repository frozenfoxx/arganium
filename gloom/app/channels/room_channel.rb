# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel
  def initialize(*args)

    # All powerup types supported for spawning
    @poweruptype = {
      "soulsphere"       => 25,
      "shotgun"          => 27,
      "chaingun"         => 28,
      "rocketlauncher"   => 29,
      "plasmagun"        => 30,
      "biofiregun"       => 31,
      "chainsaw"         => 32,
      "supershotgun"     => 33,
      "greenarmor"       => 68,
      "berserk"          => 134,
      "invisibility"     => 135,
      "radsuit"          => 136,
      "computermap"      => 137,
      "lightamp"         => 138,
      "backpack"         => 144,
    }

    super(*args)
  end

  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # Activate cheat mode
  def activatecheat()
    puts "Cheat activated"
    for area in 1..(Challenge.select(:area).distinct.count - 1)
      CertainServer.instance.update("spawnpowerup #{area}0 #{@poweruptype['biofiregun']}")
    end
  end

  # Submit flag
  def subflag(data)
    # Check if challenge is unlocked
    if !Challenge.find(data['id']).locked?

      # Check if challenge is unsolved
      if !Challenge.find(data['id']).solved?

        # Check if submission matches the flag
        if data['message'] == Challenge.find(data['id']).flag then

          Message.create! content: "Flag accepted."

          # Score flag
          # Mark challenge as solved
          Challenge.find(data['id']).solve
	        newScore = Challenge.find(data['id']).points + Score.where(:name => "challenges").pluck(:value)[0]
	        Score.where(name: "challenges").find_each { |a| a.update_value(newScore) }

          # Core Challenge?
          currentArea = Challenge.find(data['id']).area.to_i
          if currentArea > 0 then
            # Mark all area challenges as locked
            lock(currentArea)

            # Disable area enemy spawning
            CertainServer.instance.stop_spawn_enemies

            # Open Area hackdoor
            CertainServer.instance.update("openhackdoor #{currentArea}")

          # Edge Challenge
          else
            # If secrets found == secrets solved, lock all Edge Challenges
            secretsSolved = Challenge.where(:area => currentArea, :solved => true).count
            puts "Secrets solved:  #{secretsSolved}"
            if Secret.first.found == secretsSolved
              lock(0)
            end
          end

        # Flag is not correct, spawn a monster
        else

          # If solving an Edge Challenge choose a random Area
          spawnarea = Challenge.find(data['id']).area.to_i
          if spawnarea == 0
            spawnarea = rand(1..(Challenge.select(:area).distinct.count - 1))
          end

          CertainServer.instance.spawn_enemies(spawnarea)
        end

      # Player is trying to submit an already-solved flag, spawn a monster
      else
        puts "Challenge #{data['id']} already solved."
        Message.create! content: "Challenge #{data['id']} is already solved, spawning monster."

        # If solving an Edge Challenge choose a random Area
        spawnarea = Challenge.find(data['id']).area.to_i
        if spawnarea == 0
          spawnarea = rand(1..(Challenge.select(:area).distinct.count - 1))
        end

        CertainServer.instance.spawn_enemies(spawnarea)
      end

    # Challenge is locked
    else
      puts "Challenge #{data['id']} is locked."
      Message.create! content: "Challenge #{data['id']} is locked."
    end

    # Message.create! content: data['message']
    # Message.create! content: data['id']
  end

  # Redeem an Edge Challenge and spawn a PowerUp
  def subpowerup(data)
    secretsSolved = Challenge.where(:area => 0, :solved => true).count
    s = Secret.first

    # Check to make sure there are unredeemed, solved Edge Challenges
    if secretsSolved > s.redeemed
      CertainServer.instance.update("spawnpowerup #{data['area']}0 #{@poweruptype[ data['powerup'] ]}")
      popsecret
    end
  end

  # Change the map
  def loadmap(data)
    CertainServer.instance.update("map #{data['message']}")
  end

  # Lock all Challenges for an Area
  def lock(areanum)
    Challenge.where(area: areanum).find_each do |a|
      a.lock
    end
  end

  # Redeem an Edge Challenge
  def popsecret
    s = Secret.first
    # if s.redeemed < s.total then
    s.incredeemed
    puts "Secrets redeemed: #{s.redeemed}"
    # end
  end

  # Lower Hacklift
  def lowerhacklift(data)
    CertainServer.instance.update("lowerhacklift #{data['message']}")
  end

  # Raise Hacklift
  def raisehacklift(data)
    CertainServer.instance.update("raisehacklift #{data['message']}")
  end
end
