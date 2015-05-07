class Jindow_Trade < Jindow
  def initialize(myid, name)
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 100, 100)
    self.name = "교환 - " + name
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh "Trade"
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2
    
  end
  
  def update
    super
    
  end
end
