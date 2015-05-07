#==============================================================================
# ■ Client
#==============================================================================

# 클라이언트 데이터를 초기화
$myid = nil  # MyID
$kwangon_auth = false  # Kwangtteng Online 서버 인증 플래그
$permission = "standard"  # 유저 권한
$username = ""  # 아이디
$motd = ""  # 공지사항
$netplayers = {}  # 넷 플레이어
$netparty = []  # 넷 파티
$netguild = []  # 넷 길드
$my_netguild_id = nil  # 자신의 넷 길드 ID
$trade = []  # 교환

#==============================================================================
# ■ Win32
#------------------------------------------------------------------------------
# 　수치 기반 데이터를 처리합니다.
#==============================================================================

module Win32
  #--------------------------------------------------------------------------
  # ● 포인터로부터 데이터 취득
  #--------------------------------------------------------------------------
  def copymem(len)
    buf = '\0' * len
    Win32API.new('kernel32', 'RtlMoveMemory', 'ppl', '').call(buf, self, len)
    buf
  end
end

# 숫자 클래스를 확장한다
class Numeric
  include Win32
end

# 문자열 클래스를 확장한다
class String
  include Win32
end

$closesocket = Win32API.new('ws2_32.dll', 'closesocket', 'p', 'l')
$connect = Win32API.new('ws2_32.dll', 'connect', 'ppl', 'l')
$gethostbyname = Win32API.new('ws2_32.dll', 'gethostbyname', 'p', 'l')
$recv = Win32API.new('ws2_32.dll', 'recv', 'ppll', 'l')
$select = Win32API.new('ws2_32.dll', 'select', 'lpppp', 'l')
$send = Win32API.new('ws2_32.dll', 'send', 'ppll', 'l')
$socket = Win32API.new('ws2_32.dll', 'socket', 'lll', 'l')
$wsagetlasterror = Win32API.new('ws2_32.dll', 'WSAGetLastError', '', 'l')
#--------------------------------------------------------------------------
# ● 소켓을 닫는다
#--------------------------------------------------------------------------
def closesocket
  if $myid != nil and $game_party.actors[0] != nil
    send sprintf("logout,%d", $myid)
    send sprintf("chat,0,0,◎ '(%d). %s'님이 게임을 그만두셨습니다.",
         $myid, $game_party.actors[0].name)
  end
  ret = $closesocket.call($fd) rescue nil
  return ret
end
#--------------------------------------------------------------------------
# ● 연결
#     server_index : Config 모듈의 서버 인덱스
#--------------------------------------------------------------------------
def connect(server_index)
  check if ($fd = $socket.call(2, 1, 6)) == -1
  sockaddr = sockaddr_in(Config::NETWORK_SERVERS[server_index][1],
       Config::NETWORK_SERVERS[server_index][0])
  ret = $connect.call($fd, sockaddr, sockaddr.size)
  check if ret == -1
  return ret
end
#--------------------------------------------------------------------------
# ● 주어진 호스트 이름에 대한 정보 취득
#--------------------------------------------------------------------------
def gethostbyname(name)
  ptr = $gethostbyname.call(name)
  host = ptr.copymem(16).unpack('iissi')
  return [host[0].copymem(64).split('\0')[0], [], host[2], host[4].copymem(4).unpack('l')[0].copymem(4)]
end
#--------------------------------------------------------------------------
# ● 받은 데이터의 취득
#--------------------------------------------------------------------------
def recv(len, flags = 0)
  buf = '\0' * len
  check if $recv.call($fd, buf, buf.size, flags) == -1
  return buf
end
#--------------------------------------------------------------------------
# ● 대기 데이터 상태의 취득
#--------------------------------------------------------------------------
def select(timeout)
  ret = $select.call(1, [1, $fd].pack('ll'), 0, 0, [timeout, timeout * 1000000].pack('ll'))
  check if ret == -1
  return ret
end
#--------------------------------------------------------------------------
# ● 데이터의 전송
#--------------------------------------------------------------------------
def send(msg, flags = 0)
  msg.gsub!("<", "")
  msg.gsub!(">", "")
  data = "<" + msg.to_s + ">\n"
  ret = $send.call($fd, data, data.size, flags)
  check if ret == -1
  return ret
end
#--------------------------------------------------------------------------
# ● INET-sockaddr 구조체의 취득
#--------------------------------------------------------------------------
def sockaddr_in(port, host)
  return [2, port].pack('sn') + gethostbyname(host)[3] + [].pack('x8')
end
#--------------------------------------------------------------------------
# ● 데이터 대기 상태의 취득
#--------------------------------------------------------------------------
def ready?
  if select(0) != 0
    return true
  else
    return false
  end
end

def check
  errno = $wsagetlasterror.call
  Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2, 200,
       ["소켓 오류 - " + errno.to_s, Errno.const_get(Errno.constants.detect { |c| Errno.const_get(c).new.errno == errno }).to_s],
       ["확인"], ["Hwnd.dispose(self)"], "오류") if $fd != nil and not Hwnd.include?("오류")
end
