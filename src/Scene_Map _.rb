class Scene_Map
  alias kwangtteng_kwangttengonline_scene_map_main main
  alias kwangtteng_kwangttengonline_scene_map_update update
  alias kwangtteng_kwangttengonline_scene_map_transfer_player transfer_player
  def main
    $game_system.menu_disabled = true
    # 맵 콘솔을 작성
    $map_console = Console.new(164, 316, 640, 200, 8)
    $map_console.show
    $map_chat_input = Jindow_Chat_Input.new
    # 맵 게이지를 작성
    $map_gauge = Gauge.new(50, 316, 640, 200)
    $map_gauge.show
    # 플레이어를 반투명으로 한다
    $game_player.instance_eval { @opacity = 100 }
    # 넷 플레이어를 리프레쉬
    $netplayers_refresh = true
    if $just_logged_in
      $map_console.writeline sprintf("맵 ID: %d / X 좌표: %d / Y 좌표: %d",
           $game_map.map_id, $game_player.x, $game_player.y)
      $map_console.writeline sprintf("MyID: %d / 클라이언트 버전: %s",
           $myid, Config::NETWORK_VERSION)
      $map_console.writeline "게임에 접속합니다."
      # 넷 플레이어를 전송
      $game_player.send_netplayer
      send sprintf("chat,0,0,◎ '(%d). %s'님이 접속했습니다.",
           $myid, $game_party.actors[0].name)
      $just_logged_in = false
    end
    kwangtteng_kwangttengonline_scene_map_main
    # 맵 콘솔을 해방
    $map_console.dispose
    # 맵 게이지를 해방
    $map_gauge.dispose
    JS.dispose
  end
  
  def update
    # 패킷 데이터를 취득
    get_packet
    # 맵 게이지를 갱신
    $map_gauge.update
    kwangtteng_kwangttengonline_scene_map_update
    JS.update
    if not $map_chat_input.active
      if Key.trigger?(KEY_W) and not Hwnd.include?("System")  # 시스템
        Jindow_System.new
      elsif Key.trigger?(KEY_I) and not Hwnd.include?("Inventory")  # 인벤토리
        Jindow_Inventory.new
      elsif Key.trigger?(KEY_K) and not Hwnd.include?("Skill")  # 스킬
        Jindow_Skill.new
      elsif Key.trigger?(KEY_S) and not Hwnd.include?("Status")  # 상태
        Jindow_Status.new
      elsif Key.trigger?(KEY_H) and not Hwnd.include?("Hotkey")  # 단축키
        Jindow_Hotkey.new
      elsif Key.trigger?(KEY_L) and not Hwnd.include?("NetPlayer")  # 접속자 목록
        Jindow_NetPlayer.new
      elsif Key.trigger?(KEY_P) and not Hwnd.include?("NetParty")  # 넷 파티원 목록
        Jindow_NetParty.new
      elsif Key.trigger?(KEY_G) and not Hwnd.include?("NetGuild")  # 넷 길드 목록
        Jindow_NetGuild.new
      end
      if Key.press?(KEY_CTRL)
        if Key.trigger?(KEY_R)  # 맵 화면 리프레쉬
          $scene = Scene_Map.new
          $map_console.writeline "◎ (알림): 맵 화면이 리프레쉬 되었습니다."
        end
      end
    end
  end
  
  def transfer_player
    kwangtteng_kwangttengonline_scene_map_transfer_player
    # 넷 플레이어를 전송
    $game_player.send_netplayer
  end
end
