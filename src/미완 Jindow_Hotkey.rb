class Jindow_Hotkey < Jindow
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 560, 300)
    self.name = "단축키"
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh "Hotkey"
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2
    
  end
  
  def update
    super
    
  end
end
