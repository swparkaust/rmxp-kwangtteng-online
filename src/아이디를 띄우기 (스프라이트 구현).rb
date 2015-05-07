#==============================================================================
# ■ 아이디를 띄우기 (스프라이트 구현)
#------------------------------------------------------------------------------
# 　머리 위에 아이디를 띄웁니다.
#------------------------------------------------------------------------------
# 　제작 : 비밀소년 (Bimilist)
# 　수정 : 광땡 (psw0107_2), Kwangtteng Online
#==============================================================================

#==============================================================================
# ■ Game_Character (분할 정의 1)
#------------------------------------------------------------------------------
# 　캐릭터를 취급하는 클래스입니다.이 클래스는 Game_Player 클래스와 Game_Event
# 클래스의 슈퍼 클래스로서 사용됩니다.
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # ● 공개 인스턴스 변수
  #--------------------------------------------------------------------------
  attr_accessor :sprite_id
end

#==============================================================================
# ■ Sprite_Character
#------------------------------------------------------------------------------
# 　캐릭터 표시용의 스프라이트입니다.Game_Character 클래스의 인스턴스를
# 감시해, 스프라이트 상태를 자동적으로 변화시킵니다.
#==============================================================================

class Sprite_Character
  alias bimilist_sprite_id_sprite_character_update update
  #--------------------------------------------------------------------------
  # ● 아이디 스프라이트 작성
  #--------------------------------------------------------------------------
  def create_id_sprite(text)
    bitmap = Bitmap.new(160, 16)
    bitmap.font.name = Config::FONT_DEFAULT_NAME
    bitmap.font.size = 11
    bitmap.font.color.set(0, 0, 0)
    bitmap.draw_text(-1, -1, 160, 16, text, 1)
    bitmap.draw_text(-1, 0, 160, 16, text, 1)
    bitmap.draw_text(-1, 1, 160, 16, text, 1)
    bitmap.draw_text(0, -1, 160, 16, text, 1)
    bitmap.draw_text(0, 1, 160, 16, text, 1)
    bitmap.draw_text(1, -1, 160, 16, text, 1)
    bitmap.draw_text(1, 0, 160, 16, text, 1)
    bitmap.draw_text(1, 1, 160, 16, text, 1)
    if @character.is_a?(Game_Event)
      bitmap.font.color.set(0, 128, 255)
    elsif @character.is_a?(NetPlayers)
      bitmap.font.color.set(255, 255, 255)
    else
      bitmap.font.color.set(255, 255, 255)
    end
    bitmap.draw_text(0, 0, 160, 16, text, 1)
    @_id_sprite = Sprite.new(self.viewport)
    @_id_sprite.bitmap = bitmap
    @_id_sprite.ox = 80
    @_id_sprite.oy = 14
    @_id_sprite.x = self.x
    @_id_sprite.y = self.y - self.oy / 2
    @_id_sprite.z = 3000
    @_id_sprite_visible = true
  end
  #--------------------------------------------------------------------------
  # ● 아이디 스프라이트 해방
  #--------------------------------------------------------------------------
  def dispose_id_sprite
    @_id_sprite.dispose
    @_id_sprite_visible = false
  end
  #--------------------------------------------------------------------------
  # ● 아이디 스프라이트 갱신
  #--------------------------------------------------------------------------
  def update_id_sprite
    if @character.sprite_id != nil
      if not @_id_sprite_visible
        create_id_sprite(@character.sprite_id)
      end
      @_id_sprite.x = self.x
      @_id_sprite.y = self.y - self.oy
    else
      dispose_id_sprite if @_id_sprite_visible
    end
  end
  #--------------------------------------------------------------------------
  # ● 프레임 갱신
  #--------------------------------------------------------------------------
  def update
    bimilist_sprite_id_sprite_character_update
    update_id_sprite
  end
end
