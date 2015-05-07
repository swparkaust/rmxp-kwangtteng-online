class Jindow_AutoUpdate < Jindow
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 100, 100)
    self.name = "자동 업데이트"
    @head = true
    @mark = true
    @drag = true
    self.refresh "AutoUpdate"
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2
    
  end
  
  def update
    super
    
  end
end
