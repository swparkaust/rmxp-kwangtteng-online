#==============================================================================
# ■ Gauge
#------------------------------------------------------------------------------
# 　게이지 표시용의 스프라이트입니다.
#------------------------------------------------------------------------------
# 　제작 : 광땡 (psw0107_2)
# 　버전 : 1.0
# 　날짜 : 2008/04/25 (yyyy/mm/dd)
#==============================================================================

class Gauge < Sprite
  #--------------------------------------------------------------------------
  # ● 오브젝트 초기화
  #     x           : 묘화처 X 좌표
  #     y            : 묘화처 Y 좌표
  #     width      : 묘화처의 폭
  #     height     : 묘화처의 높이
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    @gauge_viewport = Viewport.new(0, 0, 640, 480)
    @gauge_viewport.z = 999
    super(@gauge_viewport)
    self.bitmap = Bitmap.new(width, height)
    self.x = x
    self.y = y
    self.z = 999
    @width = width
    refresh
    hide
  end
  #--------------------------------------------------------------------------
  # ● 리프레쉬
  #--------------------------------------------------------------------------
  def refresh
    # 윈도우 내용을 클리어
    self.bitmap.clear
    @old_name = $game_party.actors[0].name
    @old_level = $game_party.actors[0].level
    @old_class_name = $game_party.actors[0].class_name
    @old_hp = $game_party.actors[0].hp
    @old_sp = $game_party.actors[0].sp
    @old_exp = $game_party.actors[0].exp
    log = []
    log.push "(" + $myid.to_s + "). " + @old_name
    log.push @old_level.to_s
    log.push @old_class_name
    log.push @old_hp.to_s + " / " + $game_party.actors[0].maxhp.to_s
    log.push @old_sp.to_s + " / " + $game_party.actors[0].maxsp.to_s
    log.push $game_party.actors[0].exp_s + " / " + $game_party.actors[0].next_exp_s
    # 게이지를 묘화
    self.bitmap.font.color.set(0, 0, 0, 255)
    for i in 0..log.size - 1
      self.bitmap.draw_text(0, i * 18, @width, 32, log[i])
    end
  end
  #--------------------------------------------------------------------------
  # ● 보인다
  #--------------------------------------------------------------------------
  def show
    self.opacity = 255
  end
  #--------------------------------------------------------------------------
  # ● 숨긴다
  #--------------------------------------------------------------------------
  def hide
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● 해방
  #--------------------------------------------------------------------------
  def dispose
    if self.bitmap != nil
      self.bitmap.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # ● 프레임 갱신
  #--------------------------------------------------------------------------
  def update
    if @old_name != $game_party.actors[0].name or
         @old_level != $game_party.actors[0].level or
         @old_class_name != $game_party.actors[0].class_name or
         @old_hp != $game_party.actors[0].hp or
         @old_sp != $game_party.actors[0].sp or
         @old_exp != $game_party.actors[0].exp
      refresh
    end
  end
end
