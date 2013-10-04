class TestBot < RTanque::Bot::Brain
  NAME = 'test_bot'
  include RTanque::Bot::BrainHelper

  def tick!
    ## main logic goes here
    
    # use self.sensors to detect things
    # See http://rubydoc.info/github/awilliams/RTanque/master/RTanque/Bot/Sensors
    
    # use self.command to control tank
    # See http://rubydoc.info/github/awilliams/RTanque/master/RTanque/Bot/Command
    
    # self.arena contains the dimensions of the arena
    # See http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Arena
    command.speed = MAX_BOT_SPEED
    command.heading = sensors.heading - 1
    @target ||= nil
    @target = scan_target(@target)
  end
  
  def scan_target(target)
    target = sensors.radar.find { |reflection| reflection.name == target }
    if not target
      target = sensors.radar.min { |a,b| a.distance <=> b.distance }
    end
    if not target
      command.turret_heading = sensors.turret_heading + MAX_TURRET_ROTATION
      command.radar_heading = sensors.turret_heading + MAX_TURRET_ROTATION
    else
      command.turret_heading = target.heading
      command.radar_heading = target.heading
      command.fire(10)
    end
    target
  end


end
