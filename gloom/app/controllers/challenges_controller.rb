class ChallengesController < ApplicationController
  def initialize(*args)
    @challengepath = Rails.root.join("..", "challenges").to_s

    super(*args)
  end

  def index
    @diritems = Array.new

    Dir.foreach("#{@challengepath}/#{params['id']}/content") do |d|
      @diritems.push("#{params['id']}/#{d}") unless d =~/^\.\.?$/
    end

    render "challenges/index"
  end

  def show
    if params['format'] == "html" then
      render :file => "#{@challengepath}/#{params['id']}/content/#{params['component']}"
    else
      send_file "#{@challengepath}/#{params['id']}/content/#{params['component']}.#{params['format']}"
    end
  end
end
