class Dalek < RTanque::Bot::Brain
  NAME = 'dalek'
  include RTanque::Bot::BrainHelper

  TURRET_FIRE_RANGE = RTanque::Heading::ONE_DEGREE * 1.5

  def tick!
    self.move
    if self.target
      target = self.target
      self.command.radar_heading = target.heading
      self.command.turret_heading = target.heading
      command.fire(MAX_FIRE_POWER)
    else
      self.find_target
      command.fire(1)
    end
  end

  def move
    command.speed = 3
    command.heading = sensors.heading +  2
  end

  def target
    self.sensors.radar.min { |a,b| a.distance <=> b.distance }
  end

  def find_target
    self.command.radar_heading = self.sensors.radar_heading + MAX_RADAR_ROTATION
  end
end