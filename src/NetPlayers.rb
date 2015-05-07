#==============================================================================
# ■ NetPlayers
#------------------------------------------------------------------------------
# 　넷 플레이어를 취급하는 클래스입니다.
#==============================================================================

class NetPlayers < Game_Character
  #--------------------------------------------------------------------------
  # ● 공개 인스턴스 변수
  #--------------------------------------------------------------------------
  attr_reader   :myid                       # MyID
  attr_reader   :name                      # 이름
  attr_reader   :level                       # 레벨
  attr_reader   :trigger                  # 트리거
  attr_reader   :list                     # 실행 내용
  attr_reader   :starting                 # 기동중 플래그
  attr_accessor :balloon               # 말풍선
  #--------------------------------------------------------------------------
  # ● 오브젝트 초기화
  #     map_id    : 맵 ID
  #     netplayer : 넷 플레이어 (RPG::Event)
  #--------------------------------------------------------------------------
  def initialize(map_id, netplayer)
    super()
    @map_id = map_id
    @netplayer = netplayer
    @myid = @netplayer.id
    @name = @netplayer.name
    @level = @netplayer.level
    @erased = false
    @starting = false
    @through = true
    # 초기 위치에 이동
    moveto(@netplayer.x, @netplayer.y)
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 기동중 플래그의 클리어
  #--------------------------------------------------------------------------
  def clear_starting
    @starting = false
  end
  #--------------------------------------------------------------------------
  # ● 오버 트리거 판정 (동위치를 기동 조건으로 하는지 아닌지)
  #--------------------------------------------------------------------------
  def over_trigger?
    # 그래픽이 캐릭터로, 빠져나가 상태가 아닌 경우
    if @character_name != "" and not @through
      # 기동 판정은 정면
      return false
    end
    # 맵상에서 이 정도치가 통행 불가능한 경우
    unless $game_map.passable?(@x, @y, 0)
      # 기동 판정은 정면
      return false
    end
    # 기동 판정은 동위치
    return true
  end
  #--------------------------------------------------------------------------
  # ● 이벤트 기동
  #--------------------------------------------------------------------------
  def start
    # 실행 내용이 하늘이 아닌 경우
    if @list.size > 1
      @starting = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 일시 소거
  #--------------------------------------------------------------------------
  def erase
    @erased = true
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 리프레쉬
  #--------------------------------------------------------------------------
  def refresh
    # 로컬 변수 new_page 를 초기화
    new_page = nil
    # 일시 소거되어 있지 않은 경우
    unless @erased
      # 번호가 큰 이벤트 페이지로부터 순서에 조사한다
      for page in @netplayer.pages.reverse
        # 이벤트 조건을 c 로 참조 가능하게
        c = page.condition
        # 스윗치 1 조건 확인
        if c.switch1_valid
          if $game_switches[c.switch1_id] == false
            next
          end
        end
        # 스윗치 2 조건 확인
        if c.switch2_valid
          if $game_switches[c.switch2_id] == false
            next
          end
        end
        # 변수 조건 확인
        if c.variable_valid
          if $game_variables[c.variable_id] < c.variable_value
            next
          end
        end
        # 셀프 스윗치 조건 확인
        if c.self_switch_valid
          key = [@map_id, @netplayer.id, c.self_switch_ch]
          if $game_self_switches[key] != true
            next
          end
        end
        # 로컬 변수 new_page 를 설정
        new_page = page
        # 루프를 빠진다
        break
      end
    end
    # 전회와 같은 이벤트 페이지의 경우
    if new_page == @page
      # 메소드 종료
      return
    end
    # @page 에 현재의 이벤트 페이지를 설정
    @page = new_page
    # 기동중 플래그를 클리어
    clear_starting
    # 조건을 채우는 페이지가 없는 경우
    if @page == nil
      # 각 인스턴스 변수를 설정
      @tile_id = 0
      @character_name = ""
      @character_hue = 0
      @move_type = 0
      @through = true
      @trigger = nil
      @list = nil
      @interpreter = nil
      # 메소드 종료
      return
    end
    # 각 인스턴스 변수를 설정
    @tile_id = @page.graphic.tile_id
    @character_name = @page.graphic.character_name
    @character_hue = @page.graphic.character_hue
    if @original_direction != @page.graphic.direction
      @direction = @page.graphic.direction
      @original_direction = @direction
      @prelock_direction = 0
    end
    if @original_pattern != @page.graphic.pattern
      @pattern = @page.graphic.pattern
      @original_pattern = @pattern
    end
    @opacity = @page.graphic.opacity
    @blend_type = @page.graphic.blend_type
    @move_type = @page.move_type
    @move_speed = @page.move_speed
    @move_frequency = @page.move_frequency
    @move_route = @page.move_route
    @move_route_index = 0
    @move_route_forcing = false
    @walk_anime = @page.walk_anime
    @step_anime = @page.step_anime
    @direction_fix = @page.direction_fix
    @through = @page.through
    @always_on_top = @page.always_on_top
    @trigger = @page.trigger
    @list = @page.list
    @interpreter = nil
    # 트리거가 [병렬처리] 의 경우
    if @trigger == 4
      # 병렬처리용 interpreter를 작성
      @interpreter = Interpreter.new
    end
    # 자동 이벤트의 기동 판정
    check_event_trigger_auto
  end
  #--------------------------------------------------------------------------
  # ● 접촉 이벤트의 기동 판정
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    # 이벤트 실행중의 경우
    if $game_system.map_interpreter.running?
      return
    end
    # 트리거가 [이벤트로부터 접촉] 한편 플레이어의 좌표와 일치했을 경우
    if @trigger == 2 and x == $game_player.x and y == $game_player.y
      # 점프중 이외로, 기동 판정이 정면의 이벤트라면
      if not jumping? and not over_trigger?
        start
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 자동 이벤트의 기동 판정
  #--------------------------------------------------------------------------
  def check_event_trigger_auto
    # 트리거가 [이벤트로부터 접촉] 한편 플레이어의 좌표와 일치했을 경우
    if @trigger == 2 and @x == $game_player.x and @y == $game_player.y
      # 점프중 이외로, 기동 판정이 동위치의 이벤트라면
      if not jumping? and over_trigger?
        start
      end
    end
    # 트리거가 [자동 실행] 의 경우
    if @trigger == 3
      start
    end
  end
  #--------------------------------------------------------------------------
  # ● 프레임 갱신
  #--------------------------------------------------------------------------
  def update
    super
    # 자동 이벤트의 기동 판정
    check_event_trigger_auto
    # 병렬처리가 유효의 경우
    if @interpreter != nil
      # 실행중이 아닌 경우
      unless @interpreter.running?
        # 이벤트를 셋업
        @interpreter.setup(@list, @netplayer.id)
      end
      # interpreter를 갱신
      @interpreter.update
    end
  end
end
