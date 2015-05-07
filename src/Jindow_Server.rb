class Jindow_Server < Jindow
  def initialize
    super(0, 0, 120, Config::NETWORK_SERVERS.size * 30 + 35)
    self.name = "서버 선택"
    @head = true
    @mark = true
    @drag = true
    self.refresh "Server"
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2
    @buttons = []
    for i in 0...Config::NETWORK_SERVERS.size
      @buttons[i] = J::Button.new(self).refresh(120, Config::NETWORK_SERVERS[i][2])
      @buttons[i].y = i * 30 + 12
    end
    @a = J::Button.new(self).refresh(60, "취소")
    @a.x = self.width - 60
    @a.y = @buttons.size * 30 + 14
  end
  
  def update
    super
    for i in 0...@buttons.size
      @buttons[i].click ? connect(i) : 0
    end
    if @a.click  # 취소
      $game_system.se_play($data_system.decision_se)
      JS.game_end
    end
  end
end
