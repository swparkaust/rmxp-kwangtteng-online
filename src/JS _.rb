module JS
  module_function
  
  Key.install
  
  def update
    @cursor == nil ? @cursor = Cursor.new : 0
    Key.update
    Mouse.update
    Hwnd.update
    @cursor.update
  end
  
  def dispose
    Hwnd.dispose
  end
  
  def get_bitmap(file = "")
    if file.string?
      test = Sprite.new
      test.bitmap = Bitmap.new(file)
      c = []
      for x in 0..test.bitmap.width
        c[x] = []
        for y in 0..test.bitmap.height
          c[x][y] = test.bitmap.get_pixel(x, y)
        end
      end
      w = test.bitmap.width
      h = test.bitmap.height
      test.dispose
      return GB.new(c, w, h)
    elsif file.sprite?
      c = []
      for x in 0..file.bitmap.width
        c[x] = []
        for y in 0..file.bitmap.height
          c[x][y] = file.bitmap.get_pixel(x, y)
        end
      end
      w = file.bitmap.width
      h = file.bitmap.height
      return GB.new(c, w, h)
    elsif file.bitmap?
      c = []
      for x in 0..file.width
        c[x] = []
        for y in 0..file.height
          c[x][y] = file.get_pixel(x, y)
        end
      end
      w = file.width
      h = file.height
      return GB.new(c, w, h)
    end
  end
  
  def game_new
    $game_system.se_play($data_system.decision_se)
    Audio.bgm_stop
    Graphics.frame_count = 0
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_screen        = Game_Screen.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
    $jindow_temp          = Jindow_Temp.new
    $game_party.setup_starting_members
    $game_map.setup($data_system.start_map_id)
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    $game_player.refresh
    $game_map.autoplay
    $game_map.update
    $scene = Scene_Map.new
  end
  
  def game_save(filename)
    $game_system.se_play($data_system.save_se)
    file = File.open(filename, "wb")
    characters = []
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      characters.push([actor.character_name, actor.character_hue])
    end
    Marshal.dump(characters, file)
    Marshal.dump(Graphics.frame_count, file)
    $game_system.save_count += 1
    $game_system.magic_number = $data_system.magic_number
    Marshal.dump($game_system, file)
    Marshal.dump($game_switches, file)
    Marshal.dump($game_variables, file)
    Marshal.dump($game_self_switches, file)
    Marshal.dump($game_screen, file)
    Marshal.dump($game_actors, file)
    Marshal.dump($game_party, file)
    Marshal.dump($game_troop, file)
    Marshal.dump($game_map, file)
    Marshal.dump($game_player, file)
    file.close
  end
  
  def game_load(filename)
    $game_system.se_play($data_system.load_se)
    file = File.open(filename, "rb")
    characters = Marshal.load(file)
    Graphics.frame_count = Marshal.load(file)
    $game_system        = Marshal.load(file)
    $game_switches      = Marshal.load(file)
    $game_variables     = Marshal.load(file)
    $game_self_switches = Marshal.load(file)
    $game_screen        = Marshal.load(file)
    $game_actors        = Marshal.load(file)
    $game_party         = Marshal.load(file)
    $game_troop         = Marshal.load(file)
    $game_map           = Marshal.load(file)
    $game_player        = Marshal.load(file)
    if $game_system.magic_number != $data_system.magic_number
      $game_map.setup($game_map.map_id)
      $game_player.center($game_player.x, $game_player.y)
    end
    $game_party.refresh
    file.close
    $game_system.bgm_play($game_system.playing_bgm)
    $game_system.bgs_play($game_system.playing_bgs)
    $game_map.update
    $scene = Scene_Map.new
  end
  
  def game_title
    $game_system.se_play($data_system.decision_se)
    Audio.bgm_fade(800)
    Audio.bgs_fade(800)
    Audio.me_fade(800)
    $scene = Scene_Title.new
  end
  
  def game_end
    Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 82 / 2, 200,
         ["정말로 게임을 끝낼까요?"], ["예", "아니오"],
         ["$game_system.se_play($data_system.decision_se); JS.dispose; Audio.bgm_fade(800); Audio.bgs_fade(800); Audio.me_fade(800); $scene = nil",
         "Hwnd.dispose(self)"], "알림")
  end
end
