class JimmyBot < RTanque::Bot::Brain
  NAME = 'border_patrol_bot'
  include RTanque::Bot::BrainHelper
  require 'pry'


  def tick!
    ## main logic goes here
    
    # use self.sensors to detect things
    # See http://rubydoc.info/github/awilliams/RTanque/master/RTanque/Bot/Sensors
    
    # use self.command to control tank
    # See http://rubydoc.info/github/awilliams/RTanque/master/RTanque/Bot/Command
    
    # self.arena contains the dimensions of the arena
    # See http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Arena

    # binding.pry
    # puts is_wall? 
    uturn if is_wall? 
    
    @direction ||= 1
    @health ||= sensors.health
    @random_angle ||= 0
    @target_heading ||= sensors.heading

    if @health > sensors.health #getting hit
      @direction *= -1
      @random_angle = 180 * rand
      @target_heading = sensors.heading + RTanque::Heading.new_from_degrees(@random_angle)
      @health = sensors.health
    end
    command.speed = @direction * 10
    command.heading = @target_heading

    if !find_first_enemy.nil?
      command.radar_heading = find_first_enemy.heading
      command.turret_heading = find_first_enemy.heading

      if find_first_enemy.distance < 100
        command.fire(2)
      elsif find_first_enemy.distance < 300
        command.fire(5)
      else
        command.fire(10)
      end
    else
      command.radar_heading = sensors.radar_heading + Math::PI / 2.0
    end
  end

  def find_first_enemy
    sensors.radar.first if sensors.radar.count > 0
  end

  def uturn
    @target_heading = sensors.heading + Math::PI / 2.0
  end

  def is_wall?
    return true if sensors.position.x == 0 || 
            sensors.position.x == sensors.position.arena.width ||
            sensors.position.y == 0 || 
            sensors.position.y == sensors.position.arena.height 

    false
  end

end
