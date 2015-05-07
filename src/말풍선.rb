#==============================================================================
# ■ 말풍선
#------------------------------------------------------------------------------
# 　넷 플레이어의 머리 위에 말풍선을 띄웁니다.
#------------------------------------------------------------------------------
# 　제작 : 광땡 (psw0107_2)
#==============================================================================

#==============================================================================
# ■ Sprite_Character
#------------------------------------------------------------------------------
# 　캐릭터 표시용의 스프라이트입니다.Game_Character 클래스의 인스턴스를
# 감시해, 스프라이트 상태를 자동적으로 변화시킵니다.
#==============================================================================

class Sprite_Character
  alias kwangtteng_sprite_balloon_sprite_character_update update
  #--------------------------------------------------------------------------
  # ● 말풍선 스프라이트 작성
  #--------------------------------------------------------------------------
  def create_balloon_sprite(text)
    bitmap = Bitmap.new(640, 16)
    bitmap.font.name = Config::FONT_DEFAULT_NAME
    bitmap.font.size = 11
    bitmap.font.color.set(192, 0, 192)
    bitmap.draw_text(-1, -1, 640, 16, text, 1)
    bitmap.draw_text(-1, 0, 640, 16, text, 1)
    bitmap.draw_text(-1, 1, 640, 16, text, 1)
    bitmap.draw_text(0, -1, 640, 16, text, 1)
    bitmap.draw_text(0, 1, 640, 16, text, 1)
    bitmap.draw_text(1, -1, 640, 16, text, 1)
    bitmap.draw_text(1, 0, 640, 16, text, 1)
    bitmap.draw_text(1, 1, 640, 16, text, 1)
    bitmap.font.color.set(255, 255, 255)
    bitmap.draw_text(0, 0, 640, 16, text, 1)
    @_balloon_sprite = Sprite.new(self.viewport)
    @_balloon_sprite.bitmap = bitmap
    @_balloon_sprite.ox = 320
    @_balloon_sprite.oy = 36
    @_balloon_sprite.x = self.x
    @_balloon_sprite.y = self.y - self.oy / 2
    @_balloon_sprite.z = 3000
    @_balloon_sprite_visible = true
  end
  #--------------------------------------------------------------------------
  # ● 말풍선 스프라이트 해방
  #--------------------------------------------------------------------------
  def dispose_balloon_sprite
    @_balloon_sprite.dispose
    @_balloon_sprite_visible = false
  end
  #--------------------------------------------------------------------------
  # ● 말풍선 스프라이트 갱신
  #--------------------------------------------------------------------------
  def update_balloon_sprite
    if @character.balloon != nil
      if not @_balloon_sprite_visible
        @old_balloon = @character.balloon
        create_balloon_sprite(@old_balloon)
      end
      @_balloon_sprite.x = self.x
      @_balloon_sprite.y = self.y - self.oy
    else
      dispose_balloon_sprite if @_balloon_sprite_visible
    end
    dispose_balloon_sprite if @_balloon_sprite_visible and
         @old_balloon != @character.balloon
  end
  #--------------------------------------------------------------------------
  # ● 프레임 갱신
  #--------------------------------------------------------------------------
  def update
    kwangtteng_sprite_balloon_sprite_character_update
    update_balloon_sprite if @character.is_a?(NetPlayers)
  end
end
