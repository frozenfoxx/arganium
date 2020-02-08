class RoomsController < ApplicationController
  def show
    @areas = Challenge.select(:area).distinct.count - 1
    @corechallenges = Challenge.where("area > 0")
    @gamelogs = GameLog.all
    @edgechallenges = Challenge.where(area: '0')
    @hackdoors = Hackdoor.all
    @hacklifts = Hacklift.all
    @messages = Message.all
    @secrets = Secret.all
  end
end
