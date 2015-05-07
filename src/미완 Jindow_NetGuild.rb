class Jindow_NetGuild < Jindow
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 120, 150)
    self.name = "길드 목록"
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh "NetGuild"
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2
    @buttons = {}
    i = 0
    for netguild in $netguild
      @buttons[netguild[0][0]] = J::Button.new(self).refresh(120, netguild[0][1])
      @buttons[netguild[0][0]].y = i * 30 + 12
      i += 1
    end
    @a = J::Button.new(self).refresh(60, "취소")
    @a.x = self.width - 60
    @a.y = @buttons.size * 30 + 14
  end
  
  def update
    super
    for netguild in $netguild
      if @buttons[netguild[0][0]] != nil
        @buttons[netguild[0][0]].click ?
             Jindow_NetGuild_Info.new(netguild[0][0], netguild[0][1]) : 0
      end
    end
    if @a.click  # 취소
      $game_system.se_play($data_system.decision_se)
      Hwnd.dispose(self)
    end
  end
end
