class Jindow_Chat_Input < Jindow
  attr_reader :active
  
  def initialize
    super(0, 0, 640, 20)
    self.refresh "Chat_Input"
    self.y = 458
    self.opacity = 0
    @active = false
    @chat_type = "모두"
    @type = J::Type.new(self).refresh(64, 2, self.width - 108, 12)
    @type.set "(대화하려면 Enter 키를 누르세요)"
    @type.view
    @a = J::Button.new(self).refresh(40, @chat_type)
    @a.x = 2
    @b = J::Button.new(self).refresh(20, "▶")
    @b.x = 42
    @c = J::Button.new(self).refresh(40, "보내기")
    @c.x = 598
  end
  
  def send_chat
    text = @type.result
    # 명령어를 식별
    case text
    when /\/귓 (.*)/  # 귓속말 상대를 변경
      @whisper_name = $1
      $map_console.writeline "◎ (귓속말 상대 변경): " + @whisper_name
    when /\/이름 (.*)/  # 이름을 변경
      $game_party.actors[0].name = $1
      $map_console.writeline "◎ (이름 변경): " + $game_party.actors[0].name
      $game_player.send_netplayer
      $scene = Scene_Map.new
    when /\/파티 (.*)/  # 넷 파티를 요청
      if $1 != $game_party.actors[0].name
        send sprintf("netparty_req,%s,%d,%s", $1, $myid, $game_party.actors[0].name)
        $map_console.writeline "◎ (파티 요청): " + $1
      else
        $map_console.writeline "◎ (알림): 자기 자신에게 파티를 요청할 수 없습니다."
      end
    when /\/파티탈퇴/  # 넷 파티로부터 탈퇴
      if $netparty.size > 0
        $netparty.clear
        $map_console.writeline "◎ (파티 탈퇴): 파티로부터 탈퇴했습니다."
      else
        $map_console.writeline "◎ (알림): 가입한 파티가 없습니다."
      end
    when /\/교환 (.*)/  # 교환을 요청
      if $1 != $game_party.actors[0].name
        send sprintf("trade_req,%s,%d,%s", $1, $myid, $game_party.actors[0].name)
        $map_console.writeline "◎ (교환 요청): " + $1
      else
        $map_console.writeline "◎ (알림): 자기 자신에게 교환을 요청할 수 없습니다."
      end
    when /\/접속자수/  # 현재 총 접속자 수를 출력
      $map_console.writeline "◎ (현재 총 접속자 수): " + $netplayers.size.to_s + "명"
    when /\/지움/  # 콘솔을 클리어
      $map_console.clear
    when /\/관리 (.*)/  # 관리자 모드
      if $1 == Config::ADMIN_PASSWORD
        $permission = "admin"
        $map_console.writeline "◎ (관리자 모드): 관리자 모드가 가동되었습니다."
      else
        $map_console.writeline "◎ (알림): 관리자 비밀 번호가 틀렸습니다."
      end
    when /\/스크립트 (.*)/  # 스크립트 명령
      if $permission == "admin"
        $map_console.writeline "◎ (스크립트 명령): " + $1
        send sprintf("command,%s", $1)
      else
        $map_console.writeline "◎ (알림): 관리자 권한이 없습니다."
      end
    when /\/추방 (.*)/  # 유저를 강제 추방
      if $permission == "admin"
        send sprintf("kick,%d", $1)
        $map_console.writeline "◎ (유저 강제 추방): MyID (" + $1 + ") 에게 추방 요청을 보냈습니다."
      else
        $map_console.writeline "◎ (알림): 관리자 권한이 없습니다."
      end
    when /\/도움말/  # 도움말
      $map_console.writeline "/접속자수 - 현재 총 접속자 수, /지움 - 콘솔 지우기"
      $map_console.writeline "/파티 (이름) - 파티 요청, /파티탈퇴 - 파티로부터 탈퇴"
      $map_console.writeline "◎ (도움말): /귓 (이름) - 귓속말 상대 변경, /이름 (이름) - 이름 변경"
    else
      case @chat_type
      when "모두"
        send "chat,0," + $myid.to_s + "," + $game_party.actors[0].name + "," + text
      when "맵"
        send "chat,1," + $game_map.map_id.to_s + "," + $myid.to_s + "," +
             $game_party.actors[0].name + "," + text
      when "귓속말"
        if @whisper_name == nil
          $map_console.writeline "◎ (알림): 먼저 '/귓 (이름)' 명령어로 귓속말 상대를 설정해 주세요."
        else
          send "chat,2," + @whisper_name + "," + $myid.to_s + "," +
               $game_party.actors[0].name + "," + text
        end
      when "파티"
        if $netparty.size == 0
          $map_console.writeline "◎ (알림): 가입한 파티가 없습니다."
        else
          send "chat,3," + $myid.to_s + "," + $game_party.actors[0].name + "," + text
        end
      when "길드"
        send "chat,4," + $my_netguild_id.to_s + "," + $myid.to_s + "," +
             $game_party.actors[0].name + "," + text
      end
    end
  end
  
  def update
    super
    if @b.click or Key.trigger?(KEY_TAB)  # 채팅 모드를 변경
      case @chat_type
      when "모두"
        @chat_type = "맵"
      when "맵"
        @chat_type = "귓속말"
      when "귓속말"
        @chat_type = "파티"
      when "파티"
        @chat_type = "길드"
      when "길드"
        @chat_type = "모두"
      end
      @a.refresh(40, @chat_type)
      @type.bluck = true
    elsif @c.click or Key.trigger?(KEY_ENTER)  # 채팅 메세지를 전송
      if not @type.result == ""
        if @active == true
          send_chat
          @type.set "(대화하려면 Enter 키를 누르세요)"
          @type.view
          @type.bluck = false
          @active = false
        else
          @type.set ""
          @type.view
          @type.bluck = true
          @active = true
        end
      else
        @type.set "(대화하려면 Enter 키를 누르세요)"
        @type.view
        @type.bluck = false
        @active = false
      end
    end
  end
end
