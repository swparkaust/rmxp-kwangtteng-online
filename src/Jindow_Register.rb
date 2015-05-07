class Jindow_Register < Jindow
  attr_reader :type_username
  attr_reader :type_password
  
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 120, 73)
    self.name = "가입하기"
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh "Register"
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2
    @username_s = Sprite.new(self)
    @username_s.y = 0
    @username_s.bitmap = Bitmap.new(40, 32)
    @username_s.bitmap.font.color.set(0, 0, 0, 255)
    @username_s.bitmap.draw_text(0, 0, 40, 32, "아이디")
    @password_s = Sprite.new(self)
    @password_s.y = 16
    @password_s.bitmap = Bitmap.new(40, 32)
    @password_s.bitmap.font.color.set(0, 0, 0, 255)
    @password_s.bitmap.draw_text(0, 0, 40, 32, "비번")
    @type_username = J::Type.new(self).refresh(40, 12, self.width - 40, 12)
    @type_password = J::Type.new(self).refresh(40, 30, self.width - 40, 12)
    @type_password.hide = true
    @a = J::Button.new(self).refresh(60, "확인")
    @b = J::Button.new(self).refresh(60, "취소")
    @a.y = 52
    @b.x = 60
    @b.y = 52
  end
  
  def update
    super
    if @a.click  # 확인
      $game_system.se_play($data_system.decision_se)
      @type_username.bluck = false
      @type_password.bluck = false
      send sprintf("register,%s,%s", @type_username.result, @type_password.result)
    elsif @b.click  # 취소
      $game_system.se_play($data_system.decision_se)
      Hwnd.dispose(self)
    end
  end
end
