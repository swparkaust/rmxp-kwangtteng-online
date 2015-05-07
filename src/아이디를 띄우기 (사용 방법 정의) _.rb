#==============================================================================
# ■ 아이디를 띄우기 (사용 방법 정의)
#------------------------------------------------------------------------------
# 　머리 위에 아이디를 띄웁니다.
#------------------------------------------------------------------------------
# 　제작 : 비밀소년 (Bimilist)
# 　수정 : 광땡 (psw0107_2), Kwangtteng Online
#------------------------------------------------------------------------------
# 사용 방법
#
# 아이디를 띄울 이벤트의 실행 내용에
# ◆주석 : /이름표시
# 를 삽입한 후, 이벤트의 이름에 띄울 아이디를 입력합니다.
#==============================================================================

#==============================================================================
# ■ Game_Event
#------------------------------------------------------------------------------
# 　이벤트를 취급하는 클래스입니다.조건 판정에 의한 이벤트 페이지 변환이나, 병렬처리
# 이벤트 실행등의 기능을 가지고 있어 Game_Map 클래스의 내부에서 사용됩니다.
#==============================================================================

class Game_Event
  alias bimilist_sprite_id_game_event_refresh refresh
  #--------------------------------------------------------------------------
  # ● 리프레쉬
  #--------------------------------------------------------------------------
  def refresh
    bimilist_sprite_id_game_event_refresh
    if comment_include(self, "/이름표시", false) != nil
      @sprite_id = @event.name
    end
    @sprite_id = nil if @erased or @character_name == ""
  end
end

#==============================================================================
# ■ NetPlayers
#------------------------------------------------------------------------------
# 　넷 플레이어를 취급하는 클래스입니다.
#==============================================================================

class NetPlayers
  alias kwangtteng_sprite_id_netplayers_refresh refresh
  #--------------------------------------------------------------------------
  # ● 리프레쉬
  #--------------------------------------------------------------------------
  def refresh
    kwangtteng_sprite_id_netplayers_refresh
    @sprite_id = "(" + @myid.to_s + "). " + @name + " (Lv " + @level.to_s + ")"
    @sprite_id = nil if @erased or @character_name == ""
  end
end
