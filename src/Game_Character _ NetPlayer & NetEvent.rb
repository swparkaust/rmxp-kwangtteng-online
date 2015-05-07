#==============================================================================
# ■ Game_Character > NetPlayer & NetEvent
#------------------------------------------------------------------------------
# 　캐릭터를 취급하는 클래스입니다.이 클래스는 Game_Player 클래스와 Game_Event
# 클래스의 슈퍼 클래스로서 사용됩니다.
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # ● 공개 인스턴스 변수
  #--------------------------------------------------------------------------
  attr_accessor :x                        # 맵 X 좌표 (논리 좌표)
  attr_accessor :y                        # 맵 Y 좌표 (논리 좌표)
  attr_accessor :direction             # 방향
  attr_accessor :move_speed       # 이동 속도
  
  alias kwangtteng_kwangttengonline_game_character_move_down move_down
  alias kwangtteng_kwangttengonline_game_character_move_left move_left
  alias kwangtteng_kwangttengonline_game_character_move_right move_right
  alias kwangtteng_kwangttengonline_game_character_move_up move_up
  #--------------------------------------------------------------------------
  # ● 아래에 이동
  #     turn_enabled : 그 자리로의 향해 변경을 허가하는 플래그
  #--------------------------------------------------------------------------
  def move_down(turn_enabled = true)
    kwangtteng_kwangttengonline_game_character_move_down
    # 자신이 플레이어의 경우
    if self.is_a?(Game_Player)
      # 넷 플레이어를 전송
      send_netplayer
    # 자신이 이벤트의 경우
    elsif self.is_a?(Game_Event)
      if self.netevent?
        # 넷 이벤트를 전송
        send_netevent
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 왼쪽으로 이동
  #     turn_enabled : 그 자리로의 향해 변경을 허가하는 플래그
  #--------------------------------------------------------------------------
  def move_left(turn_enabled = true)
    kwangtteng_kwangttengonline_game_character_move_left
    # 자신이 플레이어의 경우
    if self.is_a?(Game_Player)
      # 넷 플레이어를 전송
      send_netplayer
    # 자신이 이벤트의 경우
    elsif self.is_a?(Game_Event)
      if self.netevent?
        # 넷 이벤트를 전송
        send_netevent
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 오른쪽으로 이동
  #     turn_enabled : 그 자리로의 향해 변경을 허가하는 플래그
  #--------------------------------------------------------------------------
  def move_right(turn_enabled = true)
    kwangtteng_kwangttengonline_game_character_move_right
    # 자신이 플레이어의 경우
    if self.is_a?(Game_Player)
      # 넷 플레이어를 전송
      send_netplayer
    # 자신이 이벤트의 경우
    elsif self.is_a?(Game_Event)
      if self.netevent?
        # 넷 이벤트를 전송
        send_netevent
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 위에 이동
  #     turn_enabled : 그 자리로의 향해 변경을 허가하는 플래그
  #--------------------------------------------------------------------------
  def move_up(turn_enabled = true)
    kwangtteng_kwangttengonline_game_character_move_up
    # 자신이 플레이어의 경우
    if self.is_a?(Game_Player)
      # 넷 플레이어를 전송
      send_netplayer
    # 자신이 이벤트의 경우
    elsif self.is_a?(Game_Event)
      if self.netevent?
        # 넷 이벤트를 전송
        send_netevent
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 넷 플레이어의 전송
  #--------------------------------------------------------------------------
  def send_netplayer
    send sprintf("netplayer,%d,%d,%s,%s,%d,%d,%d,%d,%d,%d",
         $myid, $game_map.map_id, $game_party.actors[0].name, @character_name,
         $game_party.actors[0].level, @direction, @animation_id, @move_speed, @x, @y)
  end
  #--------------------------------------------------------------------------
  # ● 넷 이벤트의 전송
  #--------------------------------------------------------------------------
  def send_netevent
    send sprintf("netevent,0,%d,%d,%d,%d,%d", $game_map.map_id,
         @id, @x, @y, @direction)
  end
end
