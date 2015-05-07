class Jindow_NetParty < Jindow
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 120, 150)
    self.name = "파티원 목록"
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh "NetParty"
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2
    @buttons = {}
    i = 0
    for netparty in $netparty
      @buttons[netparty[0]] = J::Button.new(self).refresh(120,
           "(" + netparty[0].to_s + "). " + netparty[1])
      @buttons[netparty[0]].y = i * 30 + 12
      i += 1
    end
    @a = J::Button.new(self).refresh(60, "취소")
    @a.x = self.width - 60
    @a.y = @buttons.size * 30 + 14
  end
  
  def update
    super
    for netparty in $netparty
      if @buttons[netparty[0]] != nil
        @buttons[netparty[0]].click ?
             Jindow_NetPlayer_Info.new(netparty[0], netparty[1]) : 0
      end
    end
    if @a.click  # 취소
      $game_system.se_play($data_system.decision_se)
      Hwnd.dispose(self)
    end
  end
end
