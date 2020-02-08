class WelcomeController < ApplicationController
  def index
    Thread.new do
      CertainServer.instance.run unless CertainServer.instance.running?
    end
  end
end
