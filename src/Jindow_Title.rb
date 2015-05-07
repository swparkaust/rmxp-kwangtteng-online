class Jindow_Title < Jindow
  def initialize
    super(0, 0, 100, 93)
    self.name = "메인 메뉴\정렬 : 1"
    @head = true
    @mark = true
    @drag = true
    self.refresh "Title"
    self.x = 640 / 2 - self.width / 2
    self.y = 480 - self.height - 50
    @a = J::Button.new(self).refresh(100, "새로하기")
    @b = J::Button.new(self).refresh(100, "불러오기")
    @c = J::Button.new(self).refresh(100, "끝내기")
    @a.y = 12
    @b.y = 42
    @c.y = 72
  end
  
  def update
    super
    if @a.click  # 새로하기
      JS.game_new
    elsif @b.click and not Hwnd.include?("Load")  # 불러오기
      Jindow_Load.new
    elsif @c.click  # 끝내기
      JS.game_end
    end
  end
end
