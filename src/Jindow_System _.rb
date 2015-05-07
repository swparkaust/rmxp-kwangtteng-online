class Jindow_System < Jindow
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 100, 155)
    self.name = "시스템\정렬 : 1"
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh "System"
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2
    @a = J::Button.new(self).refresh(100, "저장하기")
    @b = J::Button.new(self).refresh(100, "불러오기")
    @c = J::Button.new(self).refresh(100, "메인 화면")
    @d = J::Button.new(self).refresh(100, "끝내기")
    @e = J::Button.new(self).refresh(60, "취소")
    @a.y = 12
    @b.y = 42
    @c.y = 72
    @d.y = 102
    @e.x = self.width - 60
    @e.y = 134
  end
  
  def update
    super
    if @a.click and not Hwnd.include?("Save")  # 저장하기
      Jindow_Save.new
    elsif @b.click and not Hwnd.include?("Load")  # 불러오기
      Jindow_Load.new
    elsif @c.click  # 메인 화면
      JS.dispose
      JS.game_title
    elsif @d.click  # 끝내기
      $game_system.se_play($data_system.decision_se)
      JS.game_end
    elsif @e.click  # 취소
      $game_system.se_play($data_system.decision_se)
      Hwnd.dispose(self)
    end
  end
end
