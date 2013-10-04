class TwerkBot < RTanque::Bot::Brain
  NAME = 'twerk_bot'
  include RTanque::Bot::BrainHelper

  def tick!
    ## main logic goes here
    @tick_count ||= 0
    @tick_count+=1
    command.speed = MAX_BOT_SPEED if command.speed == nil
  
    if @tick_count == 50
      command.speed = Random.rand(MAX_BOT_SPEED)
      @tick_count = 0
    end

    rand = Random.rand(1000)
    if @tick_count % 10 == 0 or rand > 500
      command.heading = sensors.heading - (RTanque::Heading::ONE_DEGREE * 10) if rand < 900
      command.heading = sensors.heading + (RTanque::Heading::ONE_DEGREE * 10) if rand >= 900
    end
  
    if (target = self.nearest_target)
      self.fire_upon(target)
    else
      self.detect_targets
    end

    # use self.sensors to detect things
    # See http://rubydoc.info/github/awilliams/RTanque/master/RTanque/Bot/Sensors
    
    # use self.command to control tank
    # See http://rubydoc.info/github/awilliams/RTanque/master/RTanque/Bot/Command
    
    # self.arena contains the dimensions of the arena
    # See http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Arena
  end

  def nearest_target
    self.sensors.radar.min do |a,b|
      bla = a.distance
      if a.name == "ShitA2" 
        a = 9999999999999999
      end
      bla <=> b.distance 
      
    end
  end
  
  def fire_upon(target)
    if target.distance / self.arena.width * 100 < 20
      @my_power = MIN_FIRE_POWER
    elsif target.distance / self.arena.width * 100 <  50
      @my_power = MAX_FIRE_POWER / 2
    else
      @my_power = MAX_FIRE_POWER
    end
    self.command.radar_heading = target.heading
    self.command.turret_heading = target.heading
    if self.sensors.turret_heading.delta(target.heading).abs < RTanque::Heading::ONE_DEGREE * 2.0
      self.command.fire(@my_power)
    end
  end
  
  def detect_targets
    self.command.radar_heading = self.sensors.radar_heading + MAX_RADAR_ROTATION
    self.command.turret_heading = self.sensors.heading + RTanque::Heading::HALF_ANGLE
  end

end
