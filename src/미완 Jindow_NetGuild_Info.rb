class Jindow_NetGuild_Info < Jindow
  def initialize(id, name)
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 120, 100)
    self.name = "길드 정보 - " + name
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh "NetGuild_Info"
    self.x = Mouse.x + self.side_width + 5
    self.y = Mouse.y + self.side_height + 5
    if self.x + self.max_width > 640
      self.x = 640 - self.max_width
    elsif self.x < 0
      self.x = self.side_width
    end
    if self.y + self.max_height > 480
      self.y = 480 - self.max_height
    elsif self.y < 0
      self.y = self.side_height
    end
    
    @a = J::Button.new(self).refresh(60, "취소")
    @a.x = self.width - 60
    @a.y = 12
  end
  
  def update
    super
    
    if @a.click  # 취소
      $game_system.se_play($data_system.decision_se)
      Hwnd.dispose(self)
    end
  end
end
