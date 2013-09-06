class Rubymeetup < RTanque::Bot::Brain
  NAME = 'rubymeetup'
  include RTanque::Bot::BrainHelper

  def tick!
    ## main logic goes here
    # use self.sensors to detect things
    # use self.command to control tank
    # self.arena contains the dimensions of the arena
    target =  sensors.radar.first
    @_heading ||= 0
    if target.nil?
    	if @_heading > sensors.radar_heading
    		command.radar_heading = sensors.radar_heading+(Math::PI/2)
    	else
    		command.radar_heading = sensors.radar_heading-(Math::PI/2)
    	end
    else
    	@_heading =  target[:heading] 

    	if sensors.turret_heading  >= target[:heading]+0.1 || sensors.turret_heading  <= target[:heading]-0.1 
    		command.fire(1)
    	else
			command.turret_heading  = target[:heading]
    	end
    end
   
  end
end