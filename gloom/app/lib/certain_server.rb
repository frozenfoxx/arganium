require 'singleton'
require 'open3'

class CertainServer
  include Singleton

  def initialize(*args)

    # All normal enemy types supported for spawning
    @enemy_type = [
      1,
      2,
      3,
      4,
      5,
      6,
      8,
      9,
      19,
      20,
      110,
      112,
      113,
      115,
      116
    ]

    # All boss enemy types supported for spawning
    @boss_type = [
      7,
      111,
      114
    ]

    asset_package        = File.join(Rails.root, "../assets/arganium.pk3")
    certain_bin          = File.join(Rails.root, "../certain/bin/certain.rb")
    map_file             = File.join(Rails.root, "../levels/#{Level.first.file.gsub(".wad", "")}/#{Level.first.file}")
    map_name             = Level.first.name
    @numareas            = Challenge.select(:area).distinct.count - 1
    gamewad              = Option.where(:name => "gamewad").pluck(:value)[0]
    @curmarines          = 0
    @finishscript        = Option.where(:name => "finishscript").pluck(:value)[0]
    @maxmarines          = Integer(Option.where(:name => "marines").pluck(:value)[0])
    @launch_command      = "#{certain_bin} --iwad #{gamewad} --wadfiles #{map_file} --assets #{asset_package} --level #{map_name} --marines #{@maxmarines}"
    @par_time_bonus      = 500
    @spawn_boss_loop     = ''
    @spawn_enemy_loop    = ''
    @spawn_timer         = 15
    @boss_spawn_timer    = 1
    @running             = false

    super(*args)
  end

  def run
    (puts "Server already running" && return) if running?

    @certain_server_in_pipe, @out_pipe = Open3.popen2 "#{@launch_command}"
    @running = true

    while certain_output = @out_pipe.gets
      data_string = certain_output.chomp
      GameLog.create!(content: data_string)

      case data_string

      # Players activated a Hackswitch
      when /\AArea [0-9]+ Hackswitch activated!\z/
        area = get_area(data_string)
        unlock(area)

        @spawn_enemy_loop = Thread.new do
          loop do
            spawn_enemies(area)
            sleep(@spawn_timer)
          end
        end

      # Players unlocked a secret area
      when /\ASecret found!\z/
        push_secret
        unlock(0)

      # Check for players reconnecting after death
      when /\A.+ has entered the game\.\z/
        push_marines
        if check_marines
          puts "Marines are cheating!"
          @spawn_boss_loop = Thread.new do
            loop do
              (1..@numareas).each do |n|
                spawn_bosses(n)
                sleep(@boss_spawn_timer)
              end
            end
          end
        end

      # Kick player when dead
      when /\A.+ has died\.\z/
        playername = data_string.split(" ").first
        kick_player(playername)

      # Update score
      when /\ALevel\ stat:.*\z/
        if data_string.split(" ").slice(2) == "end"
          puts "Game Over"
          calculate_score
        elsif data_string.split(" ").count > 2
          update_score( data_string.split(" ").slice(2), data_string.split(" ").slice(3) )
        else
          puts "Marines are cheating!"
          @spawn_boss_loop = Thread.new do
            loop do
              (1..@numareas).each do |n|
                spawn_bosses(n)
                sleep(@boss_spawn_timer)
              end
            end
          end
        end

      else
        puts "Unhandled Certain command: #{data_string}."
      end
    end
  end

  def calculate_score
    time_taken       = Score.where(:name => "time").pluck(:value)[0]
    par_time         = Level.first.par
    kill_score       = Score.where(:name => "kills").pluck(:value)[0]
    secret_score     = Score.where(:name => "secrets").pluck(:value)[0]
    challenge_score  = Score.where(:name => "challenges").pluck(:value)[0]

    # Check if the players were under the par time
    if time_taken <= par_time
      total_score    = @par_time_bonus + kill_score + challenge_score
    else
      total_score    = kill_score + challenge_score
    end

    update_score("total", total_score)

    # If a finish script has been specified, execute it
    if @finishscript != ''
      execute_finish_script(total_score, time_taken, par_time, kill_score, secret_score, challenge_score)
    end
  end

  def check_marines
    @curmarines > @maxmarines
  end

  def execute_finish_script(total, time, par, kills, secrets, challenges)
    `#{@finishscript} --total #{total} --time #{time} --par #{par} --kills #{kills} --secrets #{secrets} --challenges #{challenges}`
  end

  def push_marines
    @curmarines+=1
  end

  def push_secret
    s = Secret.first
    s.increment_found_count
    puts "Secrets found:  #{s.found}"
  end

  def unlock(area_num)
    Challenge.where(area: area_num).find_each { |a| a.unlock }
  end

  def update_score(key, value)
    Score.where(name: key).find_each { |a| a.update_value(value) }
  end

  def running?
    @running
  end

  def spawn_bosses(area_num)
    puts "Spawning bosses in Area #{area_num}."
    update("spawnenemy #{area_num}1 #{@boss_type.to_a.sample}")
  end

  def spawn_enemies(area_num)
    puts "Spawning enemies in Area #{area_num}."
    update("spawnenemy #{area_num}1 #{@enemy_type.to_a.sample}")
  end

  def stop_spawn_enemies
    @spawn_enemy_loop.kill
  end

  def kick_player(playername)
    update("kick #{playername}")
  end

  def update(message)
    @certain_server_in_pipe.puts("#{message}")
  end

  private

  def get_area(data_string)
    data_arr = data_string.split(" ")
    i = data_arr.each_index.select{ |j| data_arr[j] == 'Area' }
    data_arr[i.first + 1]
  end
end
