#==============================================================================
# ■ NetPlayer
#------------------------------------------------------------------------------
# 　넷 플레이어를 취급하는 클래스입니다.
#==============================================================================

class NetPlayer < RPG::Event
  #--------------------------------------------------------------------------
  # ● 공개 인스턴스 변수
  #--------------------------------------------------------------------------
  attr_reader :level                         # 레벨
  #--------------------------------------------------------------------------
  # ● 오브젝트 초기화
  #     myid                  : MyID
  #     map_id               : 맵 ID
  #     name                 : 이름
  #     character_name : 캐릭터 파일명
  #     level                  : 레벨
  #     direction            : 방향
  #     move_speed      : 이동 속도
  #     x                       : X 좌표
  #     y                       : Y 좌표
  #--------------------------------------------------------------------------
  def initialize(myid, map_id, name, character_name, level, direction, move_speed, x, y)
    @level = level
    super(x, y)
    self.id = myid
    self.name = name
    self.pages[0].graphic.character_name = character_name
    self.pages[0].graphic.direction = direction
    @netplayer = NetPlayers.new(map_id, self)
    @netplayer.move_speed = move_speed
    $game_map.add_netplayer(self.id, @netplayer)
    $netplayers_refresh = true
  end
  #--------------------------------------------------------------------------
  # ● 리프레쉬
  #     myid            : MyID
  #     map_id         : 맵 ID
  #     x                 : X 좌표
  #     y                 : Y 좌표
  #     direction      : 방향
  #     animation_id : 애니메이션 ID
  #--------------------------------------------------------------------------
  def refresh(myid, map_id, x, y, direction, animation_id)
    $game_map.netplayers[myid].x = x
    $game_map.netplayers[myid].y = y
    $game_map.netplayers[myid].direction = direction
    $game_map.netplayers[myid].erase if map_id != $game_map.map_id
    @netplayer.animation_id = animation_id
  end
end
