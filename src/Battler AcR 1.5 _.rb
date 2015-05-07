#==============================================================================
# ■ Battler AcR 1.5
#------------------------------------------------------------------------------
# 　제작 : 패닉 (kcss)
# 　수정 : 광땡 (psw0107_2), Kwangtteng Online
#==============================================================================

#==============================================================================
# ■ Game_Character (분할 정의 1)
#------------------------------------------------------------------------------
# 　캐릭터를 취급하는 클래스입니다.이 클래스는 Game_Player 클래스와 Game_Event
# 클래스의 슈퍼 클래스로서 사용됩니다.
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # ● 공개 인스턴스 변수
  #--------------------------------------------------------------------------
  attr_accessor :battler
  attr_accessor :team
  
  alias kcss_battler_acr_game_character_initialize initialize
  #--------------------------------------------------------------------------
  # ● 오브젝트 초기화
  #--------------------------------------------------------------------------
  def initialize
    kcss_battler_acr_game_character_initialize
    @battler = Game_Battler.new
    @team = 1
  end
  #--------------------------------------------------------------------------
  # ● moveto(-10, -10) 이 안되는 것을 대신
  #--------------------------------------------------------------------------
  def moveto_outside
    @x = -10
    @y = -10
    @real_x = @x * 128
    @real_y = @y * 128
    @prelock_direction = 0
  end
end

#==============================================================================
# ■ Game_Event
#------------------------------------------------------------------------------
# 　이벤트를 취급하는 클래스입니다.조건 판정에 의한 이벤트 페이지 변환이나, 병렬처리
# 이벤트 실행등의 기능을 가지고 있어 Game_Map 클래스의 내부에서 사용됩니다.
#==============================================================================

class Game_Event
  alias kcss_battler_acr_agent_game_event_update update
  #--------------------------------------------------------------------------
  # ● 프레임 갱신
  #--------------------------------------------------------------------------
  def update
    kcss_battler_acr_agent_game_event_update
    agent_event
  end
end

def all_enemies
  array = []
  for target in $game_map.events.values
    if not target.battler.dead? and target.team != team
      array.push(target)
    end
  end
  target = $game_player
  if not target.battler.dead? and target.team != team
    array.push(target)
  end
  return array
end

#==============================================================================
# ■ Game_Map
#------------------------------------------------------------------------------
# 　맵을 취급하는 클래스입니다.스크롤이나 통행 가능 판정등의 기능을 가지고 있습니다.
# 이 클래스의 인스턴스는 $game_map 로 참조됩니다.
#==============================================================================

class Game_Map
  alias kcss_battler_acr_player_game_map_update update
  #--------------------------------------------------------------------------
  # ● 프레임 갱신
  #--------------------------------------------------------------------------
  def update
    kcss_battler_acr_player_game_map_update
    p = $game_player
    p.battler = $game_party.actors[0]
    p.team = 1
    p.agent_player
    if $game_party.actors[0].hp <= 0
      $game_temp.gameover = $game_party.actors[0].dead?
      return
    end
  end
end

#==============================================================================
# ■ Game_Player
#------------------------------------------------------------------------------
# 　플레이어를 취급하는 클래스입니다.이벤트의 기동 판정이나, 맵의 스크롤등의
# 기능을 가지고 있습니다.이 클래스의 인스턴스는 $game_player 로 참조됩니다.
#==============================================================================

class Game_Player
  #--------------------------------------------------------------------------
  # ● 공개 인스턴스 변수
  #--------------------------------------------------------------------------
  attr_accessor :gauge
  attr_accessor :damage
  
  def agent_player
    if Key.press?(KEY_CTRL)
      desc = $data_weapons[@battler.weapon_id].description
      desc.sub(/\[(.*), ([0-9]+)\]/) do
        @공격타입 = $1.to_s
        @딜레이 = $2.to_i
      end
      if @딜레이 == nil
        @딜레이 = 40
      end
      if @delay == nil or @delay == 0
        @delay = @딜레이
      else
        @delay -= 1
        return
      end
      if @공격타입 == "단거리"
        for target in all_enemies
          d = @direction
          new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
          new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
          if target.x == new_x and target.y == new_y
            ani_id = $data_weapons[@battler.weapon_id].animation2_id
            target.animation_id = ani_id
            target.battler.attack_effect(@battler)
            target.gauge = target.battler.hp.to_f / target.battler.maxhp.to_f
            target.damage = target.battler.damage
          end
        end
      elsif @공격타입 == "일직선"
        for target in all_enemies
          for i in 1..3
            d = @direction
            new_x = x + (d == 6 ? i : d == 4 ? -i : 0)
            new_y = y + (d == 2 ? i : d == 8 ? -i : 0)
            if target.x == new_x and target.y == new_y
              ani_id = $data_weapons[@battler.weapon_id].animation2_id
              target.animation_id = ani_id
              target.battler.attack_effect(@battler)
              target.gauge = target.battler.hp.to_f / target.battler.maxhp.to_f
              target.damage = target.battler.damage
            end
          end
        end
      elsif @공격타입 == "대각선"
        for target in all_enemies
          dist = (x - target.x).abs + (y - target.y).abs
          if dist <= 3
            ani_id = $data_weapons[@battler.weapon_id].animation2_id
            target.animation_id = ani_id
            target.battler.attack_effect(@battler)
            target.gauge = target.battler.hp.to_f / target.battler.maxhp.to_f
            target.damage = target.battler.damage
          end
        end
      elsif @공격타입 == "화살"
        tmpc_create
      end
    end
  end
end

#==============================================================================
# ■ Game_Event
#------------------------------------------------------------------------------
# 　이벤트를 취급하는 클래스입니다.조건 판정에 의한 이벤트 페이지 변환이나, 병렬처리
# 이벤트 실행등의 기능을 가지고 있어 Game_Map 클래스의 내부에서 사용됩니다.
#==============================================================================

class Game_Event
  #--------------------------------------------------------------------------
  # ● 공개 인스턴스 변수
  #--------------------------------------------------------------------------
  attr_accessor :gauge
  attr_accessor :damage
  #--------------------------------------------------------------------------
  # ● [Kwangtteng Online] 리젠 판정
  #--------------------------------------------------------------------------
  def regen?
    return (@regen_time != nil)
  end
  #--------------------------------------------------------------------------
  # ● [Kwangtteng Online] 일시 소거의 해제
  #--------------------------------------------------------------------------
  def unerase
    if self.netevent?
      send sprintf("netevent,2,%d,%d", $game_map.map_id, @id)
    else
      @erased = false
    end
  end
  #--------------------------------------------------------------------------
  # ● [Kwangtteng Online] 리젠
  #--------------------------------------------------------------------------
  def regen!
    return if not regen?
    if @regen_count < @regen_time * 40
      @regen_count += 1
      return
    end
    moveto(@event.x, @event.y)
    @battler.hp = @battler.maxhp
    @regen_count = 0
    unerase
  end
  #--------------------------------------------------------------------------
  # ● 인공 지능
  #--------------------------------------------------------------------------
  def agent_event
    if @battler.dead?
      if @erase_if_dead
        erase
        moveto_outside
        drop
        스위치_조작
      end
      # [Kwangtteng Online] 리젠한다
      regen! if regen?
      return
    end
    if not @battler.dead?
      if @wait_count == 0
        case @agent
        when "단거리"
          agent_simple
        when "대각선"
          agent_range_atk
        when "일직선"
          agent_line_atk
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● [단거리용] 간단한 인공지능
  #--------------------------------------------------------------------------
  def agent_simple
    unless moving?
      move_toward_nearest_enemy
    end
    unless moving?
      weapon_melee
    end
  end
  #--------------------------------------------------------------------------
  # ● [대각선용] 간단한 인공지능
  #--------------------------------------------------------------------------
  def agent_range_atk
    unless moving?
      move_aim_target
      turn_toward_target
    end
    unless moving?
      weapon_range
    end
  end
  #--------------------------------------------------------------------------
  # ● [일직선용] 간단한 인공지능
  #--------------------------------------------------------------------------
  def agent_line_atk
    unless moving?
      move_aim_target
      turn_toward_target
    end
    unless moving?
      weapon_range
    end
  end
  #--------------------------------------------------------------------------
  # ● 아이템 드롭
  #--------------------------------------------------------------------------
  def drop
    if not @drop == nil
      if rand(100) < @battler.treasure_prob
        # [Kwangtteng Online] 넷 파티 - EXP 분배
        if $netparty.size > 0
          exp = @battler.exp / ($netparty.size + 1)
          send sprintf("netparty_exp,%d,%d", $myid, exp)
          for netparty in $netparty
            $map_console.writeline(sprintf("◎ (파티): '%s'님에게 %d EXP 를 분배했습니다.",
                 netparty[1], exp))
          end
        else
          exp = @battler.exp
        end
        if @battler.item_id > 0
          $game_party.gain_item(@battler.item_id, 1)
          $map_console.writeline(sprintf("%d Gold, %d EXP, 아이템: %s 획득!",
               @battler.gold, exp, $data_items[@battler.item_id].name))
        end
        if @battler.weapon_id > 0
          $game_party.gain_item(@battler.weapon_id, 1)
          $map_console.writeline(sprintf("%d Gold, %d EXP, 무기: %s 획득!",
               @battler.gold, exp, $data_items[@battler.weapon_id].name))
        end
        if @battler.armor_id > 0
          $game_party.gain_item(@battler.armor_id, 1)
          $map_console.writeline(sprintf("%d Gold, %d EXP, 방어구: %s 획득!",
               @battler.gold, exp, $data_items[@battler.armor_id].name))
        end
        if not @battler.item_id > 0 and not @battler.weapon_id > 0 and
             not @battler.armor_id > 0
          $map_console.writeline(sprintf("%d Gold, %d EXP 획득!", @battler.gold, exp))
        end
        $game_party.actors[0].exp += exp
        $game_party.gain_gold(@battler.gold)
        @drop = nil
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 스위치 조작
  #--------------------------------------------------------------------------
  def 스위치_조작
    unless @스위치_id == nil
      if @스위치_조작 == "on"
        $game_switches[@스위치_id] = true
        $game_map.need_refresh = true
      elsif @스위치_조작 == "off"
        $game_switches[@스위치_id] = false
        $game_map.need_refresh = true
      end
      @스위치_id = nil
      @스위치_조작 = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● 대각선 공격
  #--------------------------------------------------------------------------
  def weapon_range
    for target in all_enemies
      dist = (x - target.x).abs + (y - target.y).abs
      if dist <= 3
        target.animation_id = @attack_ani
        @wait_count = @attack_delay
        target.battler.attack_effect(@battler)
        target.gauge = target.battler.hp.to_f / target.battler.maxhp.to_f
        target.damage = target.battler.damage
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 일직선 공격
  #--------------------------------------------------------------------------
  def weapon_line
    for i in 1..3
      d = @direction
      new_x = x + (d == 6 ? i : d == 4 ? -i : 0)
      new_y = y + (d == 2 ? i : d == 8 ? -i : 0)
      for target in all_enemies
        if target.x == new_x and target.y == new_y
          target.animation_id = @attack_ani
          @wait_count = @attack_delay
          target.battler.attack_effect(@battler)
          target.gauge = target.battler.hp.to_f / target.battler.maxhp.to_f
          target.damage = target.battler.damage
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 근접 공격
  #--------------------------------------------------------------------------
  def weapon_melee
    d = @direction
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    for target in all_enemies
      if target.x == new_x and target.y == new_y
        target.animation_id = @attack_ani
        @wait_count = @attack_delay
        target.battler.attack_effect(@battler)
        target.gauge = target.battler.hp.to_f / target.battler.maxhp.to_f
        target.damage = target.battler.damage
      end
    end
  end
end

#==============================================================================
# ■ Game_Character (분할 정의 1)
#------------------------------------------------------------------------------
# 　캐릭터를 취급하는 클래스입니다.이 클래스는 Game_Player 클래스와 Game_Event
# 클래스의 슈퍼 클래스로서 사용됩니다.
#==============================================================================

class Game_Character
  def bullet_attack
    ani = $data_weapons[$game_player.battler.weapon_id].animation2_id
    for target in all_enemies
      new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
      new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
      if target.x == self.x and target.y == self.y or target.x == new_x and target.y == new_y
        target.animation_id = ani
        target.battler.attack_effect($game_player.battler)
        target.gauge = target.battler.hp.to_f / target.battler.maxhp.to_f
        target.damage = target.battler.damage
        self.erase
        self.moveto_outside
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 플레이어에 가까워진다
  #--------------------------------------------------------------------------
  def move_toward_nearest_enemy
    target = nil
    nearest_distance = 999999
    for enemy in all_enemies
      distance = (x - enemy.x).abs + (y - enemy.y).abs
      if distance < nearest_distance
        nearest_distance = distance
        target = enemy
      end
    end
    if target == nil
      return
    end
    sx = @x - target.x
    sy = @y - target.y
    if sx == 0 and sy == 0
      return
    end
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      sx > 0 ? move_left : move_right
      if not moving? and sy != 0
        sy > 0 ? move_up : move_down
      end
    else
      sy > 0 ? move_up : move_down
      if not moving? and sx != 0
        sx > 0 ? move_left : move_right
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 타겟을 바라본다
  #--------------------------------------------------------------------------
  def turn_toward_target
    target = nil
    nearest_distance = 999999
    for enemy in all_enemies
      distance = (x - enemy.x).abs + (y - enemy.y).abs
      if distance < nearest_distance
        nearest_distance = distance
        target = enemy
      end
    end
    if target == nil
      return
    end
    sx = @x - target.x
    sy = @y - target.y
    if sx == 0 and sy == 0
      return
    end
    if sx.abs > sy.abs
      sx > 0 ? turn_left : turn_right
    else
      sy > 0 ? turn_up : turn_down
    end
  end
  #--------------------------------------------------------------------------
  # ● 타겟을 조준하여 이동한다
  #--------------------------------------------------------------------------
  def move_aim_target
    target = nil
    nearest_distance = 999999
    for enemy in all_enemies
      distance = (x - enemy.x).abs + (y - enemy.y).abs
      if distance < nearest_distance
        nearest_distance = distance
        target = enemy
      end
    end
    if target == nil
      return
    end
    sx = @x - target.x
    sy = @y - target.y
    if sx == 0 or sy == 0
      return
    end
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx < abs_sy
      sx > 0 ? move_left : move_right
      if not moving? and sy != 0
        sy > 0 ? move_up : move_down
      end
    else
      sy > 0 ? move_up : move_down
      if not moving? and sx != 0
        sx > 0 ? move_left : move_right
      end
    end
  end
end

#==============================================================================
# ■ Spriteset_Map
#------------------------------------------------------------------------------
# 　맵 화면의 스프라이트나 타일 맵등을 정리한 클래스입니다.이 클래스는
# Scene_Map 클래스의 내부에서 사용됩니다.
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● 공개 인스턴스 변수
  #--------------------------------------------------------------------------
  attr_accessor :character_sprites
end

#==============================================================================
# ■ Scene_Map
#------------------------------------------------------------------------------
# 　맵 화면의 처리를 실시하는 클래스입니다.
#==============================================================================

class Scene_Map
  #--------------------------------------------------------------------------
  # ● 공개 인스턴스 변수
  #--------------------------------------------------------------------------
  attr_accessor :spriteset
end

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
  attr_accessor :map
end

def read_spriteset_map
  if $scene.instance_of?(Scene_Map)
    return $scene.spriteset.character_sprites
  else
    return nil
  end
end

def remove_sprite(c)
  if $scene.is_a?(Scene_Map)
    $scene.instance_eval do
      @spriteset.instance_eval do
        delv = nil
        @character_sprites.each do |v|
          if v.character == c
            delv = v
          end
        end
        if delv
          delv.dispose
          @character_sprites.delete delv
        end
      end
    end
  end
  return nil
end

def tmpc_create
  for i in 1000..1100
    if $game_map.events[i] == nil
      return tmpc_arrow(i)
    end
  end
  return nil
end

def tmpc_arrow(id)
  #return if not $game_map.events.size <= 100
  c = RPG::Event.new($game_player.x, $game_player.y)
  c.pages[0].graphic.character_name = "Arrow"
  c.id = id
  $game_map.map.events[c.id] = c
  $game_map.events[c.id] = Game_Event.new(@map_id, c)
  sprite = Sprite_Character.new(@viewport1, $game_map.events[c.id])
  read_spriteset_map.push(sprite)
  $game_map.events[c.id].instance_eval{ @direction = $game_player.direction
       @through = true, @move_speed = 5 }
  $game_map.events[c.id].화살(c.id)
  return $game_map.events[c.id]
end

def 화살(id)
  script_1 = "erase"
  script_2 = "bullet_attack"
  script_3 = "remove_sprite(self)"
  move_route = RPG::MoveRoute.new
  move_route.list =
  [
    RPG::MoveCommand.new(12),
    RPG::MoveCommand.new(45, [script_2]),
    RPG::MoveCommand.new(12),
    RPG::MoveCommand.new(45, [script_2]),
    RPG::MoveCommand.new(12),
    RPG::MoveCommand.new(45, [script_2]),
    RPG::MoveCommand.new(12),
    RPG::MoveCommand.new(45, [script_2]),
    RPG::MoveCommand.new(12),
    RPG::MoveCommand.new(45, [script_2]),
    RPG::MoveCommand.new(45, [script_3]),
    RPG::MoveCommand.new(45, [script_1]),
    RPG::MoveCommand.new,
  ]
  move_route.repeat = false
  move_route.skippable = true
  $game_map.events[id].force_move_route(move_route)
end

#==============================================================================
# ■ Comment Command
#------------------------------------------------------------------------------
# 　주석으로 이벤트를 초기화시킵니다.
#------------------------------------------------------------------------------
# 　제작 : 비밀소년 (Bimilist)
#==============================================================================

#==============================================================================
# ■ Comment Command 1 / 1
#==============================================================================

class Game_Event
  alias bimilist_comment_command_game_event_refresh refresh
  #--------------------------------------------------------------------------
  # ● 커멘드 실행
  #--------------------------------------------------------------------------
  def read_comment(command)
    case command
    when /액터: ([0-9]+)/
      @battler = $game_actors[$1.to_i]
      @erase_if_dead = true
    when /에너미: ([0-9]+)/
      @battler = Game_SingleEnemy.new($1.to_i)
      @erase_if_dead = true
    when /방식: (.*)/
      @agent = $1
    when /팀: (.*)/
      @팀 = $1
      if @팀 == "아군"
        @team = 1
      elsif @팀 == "적군"
        @team = 2
        @drop = true
      end
    when /딜레이: ([0-9]+)/
      @attack_delay = $1.to_i
    when /애니: ([0-9]+)/
      @attack_ani = $1.to_i
    when /리젠: ([0-9]+)/  # [Kwangtteng Online] 리젠 시간의 설정
      @regen_time = $1.to_i
      @regen_count = 0
    when /상금: ([0-9]+), 경험치: ([0-9]+)/
      @drop_gold = $1.to_i
      @drop_exp = $2.to_i
    when /아이템: ([0-9]+), 확률: ([0-9]+)/
      @drop_item = $1.to_i
      @drop_rate = $2.to_i
    when /스위치: ([0-9]+), (.*)/
      @스위치_id = $1.to_i
      @스위치_조작 = $2
    end
  end
  #--------------------------------------------------------------------------
  # ● 페이지 전환시 주석 분석
  #--------------------------------------------------------------------------
  def refresh
    bimilist_comment_command_game_event_refresh
    unless @erased or @page == nil
      unless @my_comment_read_page == @page
        @my_comment_read_page = @page
        for v in @page.list
          if (v.code == 108 or v.code == 408)
            read_comment(v.parameters[0].dup)
          end
        end
      end
    end
  end
end

#==============================================================================
# ■ Sprite_Character
#------------------------------------------------------------------------------
# 　캐릭터 표시용의 스프라이트입니다.Game_Character 클래스의 인스턴스를
# 감시해, 스프라이트 상태를 자동적으로 변화시킵니다.
#==============================================================================

class Sprite_Character
  alias kcss_battler_acr_gauge_sprite_character_update update
  alias kcss_battler_acr_gauge_sprite_character_dispose dispose
  #--------------------------------------------------------------------------
  # ● 프레임 갱신
  #--------------------------------------------------------------------------
  def update
    kcss_battler_acr_gauge_sprite_character_update
    # [Kwangtteng Online] 넷 플레이어를 제외
    return if @character.is_a?(NetPlayers)
    if @character.gauge != nil
      gauge(@character.gauge)
      @character.gauge = nil
    end
    if @_gauge_setup then
      @_gauge_duration = [@_gauge_duration - 5, 0].max
      @_gauge_sprite_b.x = self.x
      @_gauge_sprite_b.y = self.y - 6
      @_gauge_sprite_b.opacity = @_gauge_duration
      @_gauge_sprite.x = self.x
      @_gauge_sprite.y = self.y - 6
      @_gauge_sprite.opacity = @_gauge_duration
    end
  end
  
  def gauge(p)
    setup_gauge if not @_gauge_setup
    @_gauge_sprite.src_rect = Rect.new(0, 0, p * 30, 2)
    @_gauge_duration = 255
  end
  
  def setup_gauge
    dispose_gauge
    @_gauge_setup = true
    @_gauge_sprite = Sprite.new(self.viewport)
    @_gauge_sprite.bitmap = Bitmap.new(30, 2)
    @_gauge_sprite.bitmap.fill_rect(0, 0, 30, 2, Color.new(2, 126, 0))
    @_gauge_sprite.ox = 15
    @_gauge_sprite.oy = -1
    @_gauge_sprite.z = 1000
    @_gauge_sprite_b = Sprite.new(self.viewport)
    @_gauge_sprite_b.bitmap = Bitmap.new(32, 4)
    @_gauge_sprite_b.bitmap.fill_rect(0, 0, 32, 4, Color.new(2, 126, 0))
    @_gauge_sprite_b.bitmap.fill_rect(1, 1, 30, 2, Color.new(255, 255, 255))
    @_gauge_sprite_b.ox = 16
    @_gauge_sprite_b.oy = 0
    @_gauge_sprite_b.z = 999
  end
  
  def dispose_gauge
    return if not @_gauge_setup
    @_gauge_setup = false
    @_gauge_sprite.dispose
    @_gauge_sprite_b.dispose
  end
  #--------------------------------------------------------------------------
  # ● 해방
  #--------------------------------------------------------------------------
  def dispose
    kcss_battler_acr_gauge_sprite_character_dispose
    dispose_gauge
  end
end

#==============================================================================
# ■ Sprite_Character
#------------------------------------------------------------------------------
# 　캐릭터 표시용의 스프라이트입니다.Game_Character 클래스의 인스턴스를
# 감시해, 스프라이트 상태를 자동적으로 변화시킵니다.
#==============================================================================

class Sprite_Character
  alias kcss_battler_acr_damage_sprite_character_update update
  #--------------------------------------------------------------------------
  # ● 프레임 갱신
  #--------------------------------------------------------------------------
  def update
    kcss_battler_acr_damage_sprite_character_update
    # [Kwangtteng Online] 넷 플레이어를 제외
    return if @character.is_a?(NetPlayers)
    if @character.damage != nil
      damage(@character.damage)
      @character.damage = nil
    end
  end
  
  def damage(value)
    dispose_damage
    if value.is_a?(Numeric)
      damage_string = value.abs.to_s
    else
      damage_string = value.to_s
    end
    bitmap = Bitmap.new(160, 48)
    bitmap.font.name = "돋움"
    bitmap.font.size = 11
    bitmap.font.color.set(0, 0, 0)
    bitmap.draw_text(-1, 12-1, 160, 36, damage_string, 1)
    bitmap.draw_text(+1, 12-1, 160, 36, damage_string, 1)
    bitmap.draw_text(-1, 12+1, 160, 36, damage_string, 1)
    bitmap.draw_text(+1, 12+1, 160, 36, damage_string, 1)
    bitmap.font.color.set(255, 0, 0)
    bitmap.draw_text(0, 12, 160, 36, damage_string, 1)
    @_damage_sprite = ::Sprite.new(self.viewport)
    @_damage_sprite.bitmap = bitmap
    @_damage_sprite.ox = 80
    @_damage_sprite.oy = 20
    @_damage_sprite.x = self.x
    @_damage_sprite.y = self.y - self.oy / 2
    @_damage_sprite.z = 3000
    @_damage_duration = 40
  end
end

#==============================================================================
# ■ Game_SingleEnemy
#------------------------------------------------------------------------------
# 　Game_Troop 클래스와 관계없이 에너미를 초기화시킵니다.
#------------------------------------------------------------------------------
# 　제작 : 비밀소년 (Bimilist)
#==============================================================================

class Game_SingleEnemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● 공개 인스턴스 변수
  #--------------------------------------------------------------------------
  attr_accessor   :gold
  #--------------------------------------------------------------------------
  # ● 오브젝트 초기화
  #--------------------------------------------------------------------------
  def initialize(enemy_id)
    super()
    @enemy_id = enemy_id
    enemy = $data_enemies[@enemy_id]
    @battler_name = enemy.battler_name
    @battler_hue = enemy.battler_hue
    @hp = maxhp
    @sp = maxsp
  end
  #--------------------------------------------------------------------------
  # ● 에너미 ID 취득
  #--------------------------------------------------------------------------
  def id
    return @enemy_id
  end
  #--------------------------------------------------------------------------
  # ● 이름의 취득
  #--------------------------------------------------------------------------
  def name
    return $data_enemies[@enemy_id].name
  end
  #--------------------------------------------------------------------------
  # ● 기본 MaxHP 의 취득
  #--------------------------------------------------------------------------
  def base_maxhp
    return $data_enemies[@enemy_id].maxhp
  end
  #--------------------------------------------------------------------------
  # ● 기본 MaxSP 의 취득
  #--------------------------------------------------------------------------
  def base_maxsp
    return $data_enemies[@enemy_id].maxsp
  end
  #--------------------------------------------------------------------------
  # ● 기본 완력의 취득
  #--------------------------------------------------------------------------
  def base_str
    return $data_enemies[@enemy_id].str
  end
  #--------------------------------------------------------------------------
  # ● 기본 손재주가 있음의 취득
  #--------------------------------------------------------------------------
  def base_dex
    return $data_enemies[@enemy_id].dex
  end
  #--------------------------------------------------------------------------
  # ● 기본 민첩함의 취득
  #--------------------------------------------------------------------------
  def base_agi
    return $data_enemies[@enemy_id].agi
  end
  #--------------------------------------------------------------------------
  # ● 기본 마력의 취득
  #--------------------------------------------------------------------------
  def base_int
    return $data_enemies[@enemy_id].int
  end
  #--------------------------------------------------------------------------
  # ● 기본 공격력의 취득
  #--------------------------------------------------------------------------
  def base_atk
    return $data_enemies[@enemy_id].atk
  end
  #--------------------------------------------------------------------------
  # ● 기본 물리 방어의 취득
  #--------------------------------------------------------------------------
  def base_pdef
    return $data_enemies[@enemy_id].pdef
  end
  #--------------------------------------------------------------------------
  # ● 기본 마법 방어의 취득
  #--------------------------------------------------------------------------
  def base_mdef
    return $data_enemies[@enemy_id].mdef
  end
  #--------------------------------------------------------------------------
  # ● 기본 회피 수정의 취득
  #--------------------------------------------------------------------------
  def base_eva
    return $data_enemies[@enemy_id].eva
  end
  #--------------------------------------------------------------------------
  # ● 통상 공격 공격측 애니메이션 ID 의 취득
  #--------------------------------------------------------------------------
  def animation1_id
    return $data_enemies[@enemy_id].animation1_id
  end
  #--------------------------------------------------------------------------
  # ● 통상 공격 대상측 애니메이션 ID 의 취득
  #--------------------------------------------------------------------------
  def animation2_id
    return $data_enemies[@enemy_id].animation2_id
  end
  #--------------------------------------------------------------------------
  # ● 속성 보정치의 취득
  #     element_id : 속성 ID
  #--------------------------------------------------------------------------
  def element_rate(element_id)
    # 속성 유효도에 대응하는 수치를 취득
    table = [0,200,150,100,50,0,-100]
    result = table[$data_enemies[@enemy_id].element_ranks[element_id]]
    # 스테이트에서 이 속성이 방어되고 있는 경우는 반감
    for i in @states
      if $data_states[i].guard_element_set.include?(element_id)
        result /= 2
      end
    end
    # 메소드 종료
    return result
  end
  #--------------------------------------------------------------------------
  # ● 스테이트 유효도의 취득
  #--------------------------------------------------------------------------
  def state_ranks
    return $data_enemies[@enemy_id].state_ranks
  end
  #--------------------------------------------------------------------------
  # ● 스테이트 방어 판정
  #     state_id : 스테이트 ID
  #--------------------------------------------------------------------------
  def state_guard?(state_id)
    return false
  end
  #--------------------------------------------------------------------------
  # ● 통상 공격의 속성 취득
  #--------------------------------------------------------------------------
  def element_set
    return []
  end
  #--------------------------------------------------------------------------
  # ● 통상 공격의 스테이트 변화 (+) 취득
  #--------------------------------------------------------------------------
  def plus_state_set
    return []
  end
  #--------------------------------------------------------------------------
  # ● 통상 공격의 스테이트 변화 (-) 취득
  #--------------------------------------------------------------------------
  def minus_state_set
    return []
  end
  #--------------------------------------------------------------------------
  # ● 액션의 취득
  #--------------------------------------------------------------------------
  def actions
    return $data_enemies[@enemy_id].actions
  end
  #--------------------------------------------------------------------------
  # ● EXP 의 취득
  #--------------------------------------------------------------------------
  def exp
    return $data_enemies[@enemy_id].exp
  end
  #--------------------------------------------------------------------------
  # ● 골드의 취득
  #--------------------------------------------------------------------------
  def gold
    return $data_enemies[@enemy_id].gold
  end
  #--------------------------------------------------------------------------
  # ● 아이템 ID 의 취득
  #--------------------------------------------------------------------------
  def item_id
    return $data_enemies[@enemy_id].item_id
  end
  #--------------------------------------------------------------------------
  # ● 무기 ID 의 취득
  #--------------------------------------------------------------------------
  def weapon_id
    return $data_enemies[@enemy_id].weapon_id
  end
  #--------------------------------------------------------------------------
  # ● 방어구 ID 의 취득
  #--------------------------------------------------------------------------
  def armor_id
    return $data_enemies[@enemy_id].armor_id
  end
  #--------------------------------------------------------------------------
  # ● 아이템 이름 취득
  #--------------------------------------------------------------------------
  def item_name
    return $data_enemies[@enemy_id].item_name
  end
  #--------------------------------------------------------------------------
  # ● 무기 이름 취득
  #--------------------------------------------------------------------------
  def weapon_name
    return $data_enemies[@enemy_id].weapon_name
  end
  #--------------------------------------------------------------------------
  # ● 방어구 이름 취득
  #--------------------------------------------------------------------------
  def armor_name
    return $data_enemies[@enemy_id].armor_name
  end  
  #--------------------------------------------------------------------------
  # ● 트레이닝 전기밥통 출현율의 취득
  #--------------------------------------------------------------------------
  def treasure_prob
    return $data_enemies[@enemy_id].treasure_prob
  end
  #--------------------------------------------------------------------------
  # ● 배틀 화면 Z 좌표의 취득
  #--------------------------------------------------------------------------
  def screen_z
    return screen_y
  end
  #--------------------------------------------------------------------------
  # ● 도망친다
  #--------------------------------------------------------------------------
  def escape
    # 히두후라그를 세트
    @hidden = true
    # 경향 액션을 클리어
    self.current_action.clear
  end
  #--------------------------------------------------------------------------
  # ● 변신
  #     enemy_id : 변신처의 에너미 ID
  #--------------------------------------------------------------------------
  def transform(enemy_id)
    # 에너미 ID 를 변경
    @enemy_id = enemy_id
    # 버틀러 그래픽을 변경
    @battler_name = $data_enemies[@enemy_id].battler_name
    @battler_hue = $data_enemies[@enemy_id].battler_hue
    # 액션재작성
    make_action
  end
  #--------------------------------------------------------------------------
  # ● 액션 작성
  #--------------------------------------------------------------------------
  def make_action
    # 경향 액션을 클리어
    self.current_action.clear
    # 움직일 수 없는 경우
    unless self.movable?
      # 메소드 종료
      return
    end
    # 현재 유효한 액션을 추출
    available_actions = []
    rating_max = 0
    for action in self.actions
      # 턴 조건 확인
      n = $game_temp.battle_turn
      a = action.condition_turn_a
      b = action.condition_turn_b
      if (b == 0 and n != a) or
         (b > 0 and (n < 1 or n < a or n % b != a % b))
        next
      end
      # HP 조건 확인
      if self.hp * 100.0 / self.maxhp > action.condition_hp
        next
      end
      # 레벨 조건 확인
      if $game_party.max_level < action.condition_level
        next
      end
      # 스윗치 조건 확인
      switch_id = action.condition_switch_id
      if switch_id > 0 and $game_switches[switch_id] == false
        next
      end
      # 조건에 해당 : 이 액션을 추가
      available_actions.push(action)
      if action.rating > rating_max
        rating_max = action.rating
      end
    end
    # 최대의 레이팅치를 3 으로서 합계를 계산 (0 이하는 제외)
    ratings_total = 0
    for action in available_actions
      if action.rating > rating_max - 3
        ratings_total += action.rating - (rating_max - 3)
      end
    end
    # 레이팅의 합계가 0 이 아닌 경우
    if ratings_total > 0
      # 난수를 작성
      value = rand(ratings_total)
      # 작성한 난수에 대응하는 것을 경향 액션으로 설정
      for action in available_actions
        if action.rating > rating_max - 3
          if value < action.rating - (rating_max - 3)
            self.current_action.kind = action.kind
            self.current_action.basic = action.basic
            self.current_action.skill_id = action.skill_id
            self.current_action.decide_random_target_for_enemy
            return
          else
            value -= action.rating - (rating_max - 3)
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 트룹의 흔적을 없애버린다
  #--------------------------------------------------------------------------
  def index
    return 0
  end
  
  def screen_x
    return 0
  end
  
  def screen_y
    return 0
  end
end
