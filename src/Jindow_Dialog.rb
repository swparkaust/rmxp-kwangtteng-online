class Jindow_Dialog < Jindow
  def initialize(x, y, width, texts, commands, scripts, name = "대화 상자",
         head = true, mark = true, drag = true, close = true)
    $game_system.se_play($data_system.decision_se)
    super(0, 0, width, texts.size * 18 + 35)
    self.name = name
    @head = head
    @mark = mark
    @drag = drag
    @close = close
    self.refresh name
    self.x = x
    self.y = y
    @texts = texts
    @commands = commands
    @scripts = scripts
    @text = Sprite.new(self)
    @text.bitmap = Bitmap.new(self.width, @texts.size * 18 + 12)
    @text.bitmap.font.color.set(0, 0, 0, 255)
    for i in 0...@texts.size
      @text.bitmap.draw_text(0, i * 18, self.width, 32, @texts[i])
    end
    @buttons = []
    for i in 0...@commands.size
      @buttons[i] = J::Button.new(self).refresh(60, @commands[i])
      @buttons[i].x = i * 70
      @buttons[i].y = @texts.size * 18 + 14
    end
  end
  
  def update
    super
    for i in 0...@buttons.size
      @buttons[i].click ? eval(@scripts[i]) : 0
    end
  end
end
