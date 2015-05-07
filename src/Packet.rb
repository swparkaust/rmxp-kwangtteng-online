#==============================================================================
# ■ Packet
#==============================================================================

#--------------------------------------------------------------------------
# ● 패킷 데이터의 취득
#--------------------------------------------------------------------------
def get_packet
  if ready?
    for line in recv(0xfff).split "\n"
      case line
      when /<(.*)>/
        array = $1.split ","
        # 프로토콜로 분기
        case array[0]
        when "myid"  # MyID (서버에서 연결 Accept 시에 전송)
          $myid = array[1].to_i
          #send sprintf("kwangon_auth,%s", Config::NETWORK_GAMECODE)
          
          load_save
        when "kwangon_auth"  # 서버 인증
          case array[1].to_i
          when 0  # 서버 인증 성공의 경우
            $kwangon_auth = true
            send sprintf("version,%s", Config::NETWORK_VERSION)
          when 1  # 잘못된 게임코드의 경우
            Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2, 200,
                 ["서버 인증에 실패했습니다.", "다음에 다시 시도해 주세요."],
                 ["확인"], ["Hwnd.dispose(self)"], "오류")
          end
        when "version"  # 버전 체크
          if $scene.is_a?(Scene_AutoUpdate)
            case array[1].to_i
            when 0  # 버전 체크 성공의 경우
              $scene = Scene_Login.new
            when 1  # 잘못된 버전의 경우
              Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2, 200,
                   ["업데이트가 필요합니다.", "새 버전을 다운로드해 주세요."],
                   ["확인"], ["Hwnd.dispose(self)"], "오류")
              # 아직 자동 업데이트는 미완성 이에요 ^^;;
            end
          end
        when "login"  # 로그인
          if $scene.is_a?(Scene_Login)
            case array[1].to_i
            when 0  # 로그인 성공의 경우
              $scene.status_console.writeline "유저 테스트에 성공했습니다. 잠시만 기다려 주세요."
              $username = $scene.login_window.type_username.result
              # 세이브 데이터를 요청
              $scene.status_console.writeline "세이브 데이터를 받는 중..."
              send sprintf("get_save,%s", $username)
              # 쪽지 데이터를 요청
              $scene.status_console.writeline "쪽지 데이터를 받는 중..."
              send sprintf("get_pm,%s", $username)
              # 넷 길드 데이터를 요청
              $scene.status_console.writeline "길드 데이터를 받는 중..."
              send "get_guild"
              load_save
            when 1  # 잘못된 아이디의 경우
              $scene.status_console.writeline "잘못된 아이디입니다."
              $scene.login_window.type_username.bluck = true
            when 2  # 잘못된 비밀 번호의 경우
              $scene.status_console.writeline "잘못된 비밀 번호입니다."
              $scene.login_window.type_password.bluck = true
            when 3  # 접속한 아이디의 경우
              $scene.status_console.writeline "이미 접속한 아이디입니다."
              $scene.login_window.type_username.bluck = true
            end
          end
        when "logout"  # 로그아웃
          if $scene.is_a?(Scene_Map)
            $game_map.netplayers[array[1].to_i].erase if $game_map.netplayers[array[1].to_i] != nil
            $netplayers_refresh = true
          end
        when "register"  # 가입
          if $scene.is_a?(Scene_Login)
            case array[1].to_i
            when 0  # 가입 성공의 경우
              $scene.status_console.writeline "가입에 성공했습니다."
              Hwnd.dispose("Register")
            when 1  # 존재하는 아이디의 경우
              $scene.status_console.writeline "이미 존재하는 아이디입니다."
              #$scene.register_window.type_username.bluck = true
            end
          end
        when "command"  # 스크립트 명령
          eval array[1]
        when "get_motd"  # 공지사항의 취득
          $motd = array[1]
        when "get_save"  # 세이브 데이터의 취득
          $game_party.actors[0].name = array[2]
          $game_player.set_graphic(array[3])
          $game_party.actors[0].level = array[4].to_i
          # 장소 이동 플래그를 세트
          $game_temp.player_transferring = true
          # 플레이어의 이동처를 설정
          $game_temp.player_new_map_id = array[1].to_i
          $game_temp.player_new_x = array[6].to_i
          $game_temp.player_new_y = array[7].to_i
          $game_temp.player_new_direction = array[5].to_i
        when "get_pm"  # 쪽지 데이터의 취득
          
        when "get_netguild"  # 넷 길드 데이터의 취득
          # 길드 ID, 길드 이름, 길드원의 ID, 길드원의 이름
          $netguild.push [[array[1].to_i, array[2]], [array[3], array[4]]]
          for netguild in $netguild
            if netguild[1][0] == $username
              $my_netguild_id = netguild[0][0]
            end
          end
        when "netplayer"  # 넷 플레이어
          if $scene.is_a?(Scene_Map)
            $netplayers[array[1].to_i] = NetPlayer.new(array[1].to_i, array[2].to_i,
                 array[3], array[4], array[5].to_i, array[6].to_i, array[8].to_i,
                 array[9].to_i, array[10].to_i) if $game_map.netplayers[array[1].to_i] == nil
            $netplayers[array[1].to_i].refresh(array[1].to_i, array[2].to_i,
                 array[9].to_i, array[10].to_i, array[6].to_i, array[7].to_i)
          end
        when "netevent"  # 넷 이벤트
          if $scene.is_a?(Scene_Map)
            case array[1].to_i
            when 0  # 이동
              # 이벤트 ID 가 유효의 경우
              if array[3].to_i > 0
                if array[2].to_i == $game_map.map_id
                  $game_map.events[array[3].to_i].x = array[4].to_i
                  $game_map.events[array[3].to_i].y = array[5].to_i
                  $game_map.events[array[3].to_i].direction = array[6].to_i
                end
              end
            when 1  # 일시 소거
              if array[2].to_i == $game_map.map_id
                # 이벤트 ID 가 유효의 경우
                if array[3].to_i > 0
                  # 이벤트를 소거
                  $game_map.events[array[3].to_i].erased = true
                end
              end
            when 2  # 리젠
              if array[2].to_i == $game_map.map_id
                # 이벤트 ID 가 유효의 경우
                if array[3].to_i > 0
                  # 이벤트를 리젠
                  $game_map.events[array[3].to_i].erased = false
                end
              end
            end
          end
        when "chat"  # 채팅
          if $scene.is_a?(Scene_Map)
            case array[1].to_i
            when 0  # 모두에게
              if array[2].to_i == 0  # 커스텀 메세지의 경우
                $map_console.writeline array[3]
              else
                $map_console.writeline "(" + array[2] + "). " + array[3] + ": " + array[4].to_s
                # 해당하는 넷 플레이어의 말풍선을 설정
                if $game_map.netplayers[array[2].to_i] != nil
                  $game_map.netplayers[array[2].to_i].balloon = array[4].to_s
                end
              end
            when 1  # 맵에게
              if array[2].to_i == $game_map.map_id
                $map_console.writeline "[맵] (" + array[3] + "). " +
                     array[4] + ": " + array[5].to_s
                # 해당하는 넷 플레이어의 말풍선을 설정
                if $game_map.netplayers[array[3].to_i] != nil
                  $game_map.netplayers[array[3].to_i].balloon = array[5].to_s
                end
              end
            when 2  # 귓속말
              $map_console.writeline "[귓속말] (" + array[3] + "). " + array[4] + ": " +
                   array[5].to_s if array[2] == $game_party.actors[0].name
            when 3  # 넷 파티에게
              for netparty in $netparty
                if array[2].to_i == netparty[0]
                  $map_console.writeline "[파티] (" + array[2] + "). " +
                       array[3] + ": " + array[4].to_s
                end
              end
            when 4  # 넷 길드에게
              $map_console.writeline "[길드] (" + array[3] + "). " + array[4] + ": " +
                   array[5].to_s if array[2].to_i == $my_netguild_id
            end
          end
        when "netparty_exp"  # 넷 파티 - EXP 분배
          if $scene.is_a?(Scene_Map)
            for netparty in $netparty
              if array[1].to_i == netparty[0]
                $game_party.actors[0].exp += array[2].to_i
                $map_console.writeline "◎ (파티): '" + netparty[1] +
                     "'님으로부터 " + array[2] + " EXP 획득!"
              end
            end
          end
        when "netparty_req"  # 넷 파티 - 요청
          if $scene.is_a?(Scene_Map)
            Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2, 200,
                 ["'" + array[3] + "'님이 파티를 요청했습니다.", "수락할까요?"], ["예", "아니오"],
                 ["$netparty.push [" + array[2] + ",\"" + array[3] + "\"]; send sprintf(\"netparty_req_result,%d,%d,%s,%d\", 0," + $myid.to_s + ",\"" + $game_party.actors[0].name + "\"," + array[2] + "); Hwnd.dispose(self)",
                 "send sprintf(\"netparty_req_result,%d,%s,%d\", 1, \"" + $game_party.actors[0].name + "\"," + array[2] + "); Hwnd.dispose(self)"],
                 "파티 요청") if array[1] == $game_party.actors[0].name
          end
        when "netparty_req_result"  # 넷 파티 - 요청 결과
          if $scene.is_a?(Scene_Map)
            case array[1].to_i
            when 0  # 수락
              if array[4].to_i == $myid
                $map_console.writeline "◎ (파티): '" + array[3] +
                     "'님이 파티 요청을 수락했습니다."
                $netparty.push [array[2].to_i, array[3]]
              end
            when 1  # 거부
              if array[3].to_i == $myid
                $map_console.writeline "◎ (파티): '" + array[2] +
                     "'님이 파티 요청을 거부했습니다."
              end
            end
          end
        when "trade"  # 교환
          if $scene.is_a?(Scene_Map)
            
          end
        when "trade_req"  # 교환 - 요청
          if $scene.is_a?(Scene_Map)
            Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2, 200,
                 ["'" + array[3] + "'님이 교환을 요청했습니다.", "수락할까요?"], ["예", "아니오"],
                 ["$trade.push [" + array[2] + ",\"" + array[3] + "\"]; Hwnd.dispose(self)", "Hwnd.dispose(self)"],
                 "교환 요청") if array[1] == $game_party.actors[0].name
          end
        when "trade_req_result"  # 교환 - 요청 결과
          if $scene.is_a?(Scene_Map)
            case array[1].to_i
            when 0  # 수락
              $map_console.writeline "◎ (교환): '" + array[3] +
                   "'님이 교환 요청를 수락했습니다."
              Jindow_Trade.new(array[2].to_i, array[3])
            when 1  # 거부
              $map_console.writeline "◎ (교환): '" + array[2] +
                   "'님이 교환 요청를 거부했습니다."
            end
          end
        when "event_spawn"  # 이벤트의 작성
          if $scene.is_a?(Scene_Map)
            event = RPG::Event.new(array[1].to_i, array[2].to_i)
            event.id = $game_map.events.size + 1
            event.name = array[3]
            event.pages[0].graphic.character_name = array[4]
            event.pages[0].graphic.direction = array[5].to_i
            events = Game_Event.new(array[6].to_i, event)
            events.move_speed = array[7].to_i
            $game_map.add_event(event.id, events)
            $scene = Scene_Map.new
          end
        when "event_delete"  # 이벤트의 삭제
          if $scene.is_a?(Scene_Map)
            $game_map.events[array[1].to_i].erase
          end
        when "kick"  # 강제 추방
          if array[1].to_i == $myid
            print "관리자로부터 강제 추방 당했습니다."
            exit
          end
        end
      end
    end
  end
end
#--------------------------------------------------------------------------
# ● 세이브 데이터의 로드
#--------------------------------------------------------------------------
def load_save
  $just_logged_in = true
  JS.game_new
end
