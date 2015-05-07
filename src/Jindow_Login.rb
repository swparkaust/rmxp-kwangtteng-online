class Jindow_Login < Jindow
  attr_reader :type_username
  attr_reader :type_password
  
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 120, 95)
    self.name = "로그인"
    @head = true
    @mark = true
    @drag = true
    self.refresh "Login"
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
    @c = J::Button.new(self).refresh(60, "가입하기")
    @d = J::Button.new(self).refresh(60, "홈페이지")
    @a.y = 52
    @b.x = 60
    @b.y = 52
    @c.y = 74
    @d.x = 60
    @d.y = 74
  end
  
  def update
    super
    if @a.click  # 확인
      $game_system.se_play($data_system.decision_se)
      @type_username.bluck = false
      @type_password.bluck = false
      send sprintf("login,%s,%s", @type_username.result, @type_password.result)
    elsif @b.click  # 취소
      $game_system.se_play($data_system.decision_se)
      destroy
      $scene = Scene_Server.new
    elsif @c.click and not Hwnd.include?("Register")  # 가입하기
      Jindow_Register.new
    elsif @d.click  # 홈페이지
      url = "http://singon2.ohpy.com"  # 홈페이지 URL
      exec("C:\\Program Files\\Internet Explorer\\iexplore.exe " + url)
    end
  end
end
