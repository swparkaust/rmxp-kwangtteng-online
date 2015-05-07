#==============================================================================
# ■ Kwangtteng Online - Config (사용자 편집)
#==============================================================================

module Config
  #--------------------------------------------------------------------------
  # ● 기본 설정
  #     DEBUG                  : 디버그 모드  ※해킹의 가능성이 있기 때문에,
  #                                   수동으로 조작해야 한다 (true / false)
  #     FULL_SCREEN       : 풀 스크린 (전체 화면) 모드를 자동 전환할지 (true / false)
  #     CURSOR_ICON       : 마우스 커서 파일명
  #     ADMIN_PASSWORD : 관리자 모드 비밀 번호
  #--------------------------------------------------------------------------
  DEBUG = false
  FULL_SCREEN = false
  CURSOR_ICON = "001-Weapon01"
  ADMIN_PASSWORD = "5wSdJ8DR"
  #--------------------------------------------------------------------------
  # ● 폰트 설정
  #     FONT_DEFAULT_SIZE     : 기본 폰트 크기
  #     FONT_DEFAULT_NAME   : 기본 폰트 이름
  #     FONT_DEFAULT_COLOR : 기본 폰트 색 (RGB)
  #     FONT_DEFAULT_BOLD    : 기본 폰트 굵기 (true / false)
  #     FONT_DEFAULT_ITALIC   : 기본 폰트 기울기 (true / false)
  #--------------------------------------------------------------------------
  FONT_DEFAULT_SIZE = 12
  FONT_DEFAULT_NAME = ["돋움"]
  FONT_DEFAULT_COLOR = Color.new(0, 0, 0)
  FONT_DEFAULT_BOLD = false
  FONT_DEFAULT_ITALIC = false
  #--------------------------------------------------------------------------
  # ● 네트워크 설정
  #     NETWORK_SERVERS    : 서버의 IP 주소, 포트 번호와 이름
  #     NETWORK_GAMECODE : 게임코드 (서버의 설정값과 동일해야 한다)
  #     NETWORK_VERSION     : 클라이언트 버전 (서버의 설정값과 동일해야 한다)
  #--------------------------------------------------------------------------
  NETWORK_SERVERS =
  [
    ["70.81.172.44", 50000, "광땡 서버"],
    #["IP 주소", 포트 번호, "서버 이름"],
  ]
  NETWORK_GAMECODE = "5wSdJ8DR"
  NETWORK_VERSION = 0.07
end
