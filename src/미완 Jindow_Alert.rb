class Jindow_Alert < Jindow
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 100, 100)
    @head = true
    @mark = true
    @close = true
    self.refresh "Alert"
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2
    
  end
  
  def update
    super
    
  end
end
