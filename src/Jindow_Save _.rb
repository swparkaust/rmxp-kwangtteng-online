class Jindow_Save < Jindow
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 200, 56)
    self.name = "저장하기"
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh "Save"
    @type = J::Type.new(self).refresh(0, 12, self.width, 12)
    @a = J::Button.new(self).refresh(100, "저장하기")
    @a.x = 50; @a.y = 34
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2
    @load_list = Jindow.new(0, 0, 200, 111)
    @load_list.refresh("Load_List")
    @load_list.x = self.x
    @load_list.y = self.y + self.height + self.side_height(1) + @load_list.side_height
    Hwnd.link(self, @load_list)
    @buttons = []
    @folder = Dir.entries "Save/"
    @folder.delete "."
    @folder.delete ".."
    for i in @folder
      num = @folder.index i
      @buttons[num] = J::Button.new(@load_list).refresh(@load_list.width,
           File.basename(i, ".*"))
      @buttons[num].y = num * 30
    end
  end
  
  def update
    super 
    @type.click ? (@a.click = true) : 0
    for i in @buttons
      i.click ? @type.set(i.command).view : next
    end
    if @a.click and not @type.result == ""  # 저장하기
      JS.game_save("Save/" + @type.result + ".rxdata")
      Hwnd.dispose(self)
    end
  end
end
