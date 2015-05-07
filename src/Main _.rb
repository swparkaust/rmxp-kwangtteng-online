#==============================================================================
# ■ Main
#------------------------------------------------------------------------------
# 　각 클래스의 정의가 끝난 후, 여기로부터 실제의 처리가 시작됩니다.
#==============================================================================

begin
# ────────────────────────
  $DEBUG = Config::DEBUG
  if Config::FULL_SCREEN
    $showm = Win32API.new 'user32', 'keybd_event', %w(l l l l), ''
    $showm.call(18, 0, 0, 0)
    $showm.call(13, 0, 0, 0)
    $showm.call(13, 0, 2, 0)
    $showm.call(18, 0, 2, 0)
  end
  Font.default_size = Config::FONT_DEFAULT_SIZE
  Font.default_name = Config::FONT_DEFAULT_NAME
  Font.default_bold = Config::FONT_DEFAULT_BOLD
  Font.default_italic = Config::FONT_DEFAULT_ITALIC
# ────────────────────────
  # 트란지션 준비
  Graphics.freeze
# ────────────────────────
  # 씬 오브젝트 (서버 선택 화면)를 작성
  $scene = Scene_Server.new
# ────────────────────────
  # $scene 가 유효한 한계 main 메소드를 호출한다
  while $scene != nil
    $scene.main
  end
  # 페이드아웃
  Graphics.transition(20)
rescue Errno::ENOENT
  # 예외 Errno::ENOENT 를 보충
  # 파일을 오픈할 수 없었던 경우, 메세지를 표시해 종료한다
  filename = $!.message.sub("No such file or directory - ", "")
  print("오류: '#{filename}' 파일을 찾을 수 없습니다.")
# ────────────────────────
ensure
  # 클라이언트 소켓을 닫는다
  closesocket
# ────────────────────────
end
