#==============================================================================
# ■ Spriteset_Map
#------------------------------------------------------------------------------
# 　맵 화면의 스프라이트나 타일 맵등을 정리한 클래스입니다.이 클래스는
# Scene_Map 클래스의 내부에서 사용됩니다.
#==============================================================================

class Spriteset_Map
  alias kwangtteng_kwangttengonline_spriteset_map_initialize initialize
  alias kwangtteng_kwangttengonline_spriteset_map_update update
  #--------------------------------------------------------------------------
  # ● 오브젝트 초기화
  #--------------------------------------------------------------------------
  def initialize
    kwangtteng_kwangttengonline_spriteset_map_initialize
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 리프레쉬
  #--------------------------------------------------------------------------
  def refresh
    # 넷 플레이어의 데이터를 설정
    for netplayer in $game_map.netplayers.values
      @character_sprites.push(Sprite_Character.new(@viewport1, netplayer))
    end
    $netplayers_refresh = false
  end
  #--------------------------------------------------------------------------
  # ● 프레임 갱신
  #--------------------------------------------------------------------------
  def update
    kwangtteng_kwangttengonline_spriteset_map_update
    refresh if $netplayers_refresh
  end
end
