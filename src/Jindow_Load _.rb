class Jindow_Load < Jindow
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 200, 153)
    self.name = "불러오기"
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh "Load"
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2
    @buttons = []
    @folder = Dir.entries "Save/"
    @folder.delete "."
    @folder.delete ".."
    for i in @folder
      num = @folder.index i
      @buttons[num] = J::Button.new(self).refresh(self.width, File.basename(i, ".*"))
      @buttons[num].y = 12 + num * 30
    end
  end
  
  def update
    super 
    for i in @buttons
      i.click ? JS.game_load("Save/" + i.command + ".rxdata") : 0
    end
  end
end
