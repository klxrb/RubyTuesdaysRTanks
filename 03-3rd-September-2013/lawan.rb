class Lawan < RTanque::Bot::Brain
  NAME = 'lawan'
  include RTanque::Bot::BrainHelper

  def tick!
  	command.radar_heading = sensors.radar_heading + RTanque::Heading::ONE_DEGREE * 30
  	target = self.sensors.radar.min { |a,b| a.distance <=> b.distance }
    if target && target.name != "kawan"
        command.radar_heading = target.heading
		command.turret_heading = target.heading
        command.heading = target.heading
		command.fire(3)
        command.speed = 1000
    end
  end
  
end