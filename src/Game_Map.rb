#==============================================================================
# ■ Game_Map
#------------------------------------------------------------------------------
# 　맵을 취급하는 클래스입니다.스크롤이나 통행 가능 판정등의 기능을 가지고 있습니다.
# 이 클래스의 인스턴스는 $game_map 로 참조됩니다.
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # ● 공개 인스턴스 변수
  #--------------------------------------------------------------------------
  attr_reader   :netplayers              # 넷 플레이어
  
  alias kwangtteng_kwangttengonline_game_map_setup setup
  alias kwangtteng_kwangttengonline_game_map_refresh refresh
  alias kwangtteng_kwangttengonline_game_map_update update
  #--------------------------------------------------------------------------
  # ● 셋업
  #     map_id : 맵 ID
  #--------------------------------------------------------------------------
  def setup(map_id)
    kwangtteng_kwangttengonline_game_map_setup(map_id)
    # 넷 플레이어의 데이터를 설정
    @netplayers = {}
    for i in $netplayers.values
      @netplayers[i] = NetPlayers.new(@map_id, $netplayers[i]) if $netplayers[i] != nil
    end
  end
  #--------------------------------------------------------------------------
  # ● 넷 플레이어의 추가
  #     myid       : MyID
  #     netplayer : 넷 플레이어
  #--------------------------------------------------------------------------
  def add_netplayer(myid, netplayer)
    @netplayers[myid] = netplayer
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 이벤트의 추가
  #     event_id : 이벤트 ID
  #     event     : 이벤트
  #--------------------------------------------------------------------------
  def add_event(event_id, event)
    @events[event_id] = event
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 리프레쉬
  #--------------------------------------------------------------------------
  def refresh
    kwangtteng_kwangttengonline_game_map_refresh
    # 맵 ID 가 유효하면
    if @map_id > 0
      # 모든 넷 플레이어를 리프레쉬
      for netplayer in @netplayers.values
        netplayer.refresh
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 프레임 갱신
  #--------------------------------------------------------------------------
  def update
    kwangtteng_kwangttengonline_game_map_update
    # 넷 플레이어를 갱신
    for netplayer in @netplayers.values
      netplayer.update
    end
  end
end
