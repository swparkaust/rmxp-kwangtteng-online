class Game_Actor
  def jindow_equip_c(item1, item2, type)
    jindow = Hwnd.include?("Inventory", 1)
    jindow ? 0 : return
    if $game_party.jindow_item_include?(item2.id, type) and item2 != 0
      for i in jindow.item
        i.item? ? 0 : next
        i.item == item2 ? 0 : next
        i.num <= 0 ? 0 : break
        id = i.id
        jindow.item[id] = nil
        i.dispose
        break
      end
    end
    if item1 != 0 and not $game_party.jindow_item_include?(item1.id, type)
      id = 0
      loop do
        if jindow.item[id] == nil
          jindow.item[id] = J::Item.new(jindow, false).set(true).refresh(item1.id, type)
          jindow.item[id].x = (id % 7) * 30
          jindow.item[id].y = (id / 7) * 30 + 12
          jindow.item[id].id_set
          break
        end
        id += 1
      end
    end
  end
  
  def equip(equip_type, id)
    case equip_type
    when 0  # 무기
      if $game_party.weapon_number(id) > 0
        $game_party.gain_weapon(@weapon_id, 1, true)
        $game_party.lose_weapon(id, 1)
        jindow_equip_c((@weapon_id != 0 ? $data_weapons[@weapon_id] : 0), $data_weapons[id], 1)
        @weapon_id = id
      elsif id == 0
        $game_party.gain_weapon(@weapon_id, 1, true)
        jindow_equip_c($data_weapons[@weapon_id], 0, 1)
        @weapon_id = id
      end
    when 1  # 방패
      if $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor1_id], $data_armors[id])
        $game_party.gain_armor(@armor1_id, 1, true)        
        $game_party.lose_armor(id, 1)
        jindow_equip_c((@armor1_id != 0 ? $data_armors[@armor1_id] : 0), $data_armors[id], 2)
        @armor1_id = id
      elsif id == 0
        update_auto_state($data_armors[@armor1_id], nil)
        $game_party.gain_armor(@armor1_id, 1, true)
        jindow_equip_c($data_armors[@armor1_id], 0, 2)
        @armor1_id = id
      end
    when 2  # 투구
      if $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor2_id], $data_armors[id])
        $game_party.gain_armor(@armor2_id, 1, true)
        $game_party.lose_armor(id, 1)
        jindow_equip_c((@armor2_id != 0 ? $data_armors[@armor2_id] : 0), $data_armors[id], 2)
        @armor2_id = id
      elsif id == 0
        update_auto_state($data_armors[@armor2_id], nil)
        $game_party.gain_armor(@armor2_id, 1, true)
        jindow_equip_c($data_armors[@armor2_id], 0, 2)
        @armor2_id = id
      end
    when 3  # 갑옷
      if $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor3_id], $data_armors[id])
        $game_party.gain_armor(@armor3_id, 1, true)
        $game_party.lose_armor(id, 1)
        jindow_equip_c((@armor3_id != 0 ? $data_armors[@armor3_id] : 0), $data_armors[id], 2)
        @armor3_id = id
      elsif id == 0
        update_auto_state($data_armors[@armor3_id], nil)
        $game_party.gain_armor(@armor3_id, 1, true)
        jindow_equip_c($data_armors[@armor3_id], 0, 2)
        @armor3_id = id
      end
    when 4  # 장식품
      if $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor4_id], $data_armors[id])
        $game_party.gain_armor(@armor4_id, 1, true)
        $game_party.lose_armor(id, 1)
        jindow_equip_c((@armor4_id != 0 ? $data_armors[@armor4_id] : 0), $data_armors[id], 2)
        @armor4_id = id
      elsif id == 0
        update_auto_state($data_armors[@armor4_id], nil)
        $game_party.gain_armor(@armor4_id, 1, true)
        jindow_equip_c($data_armors[@armor4_id], 0, 2)
        @armor4_id = id
      end
    end
  end
  
  def lv_str
    n = $data_actors[@actor_id].parameters[2, @level]
    return [[n, 1].max, 999].min
  end
  
  def lv_dex
    n = $data_actors[@actor_id].parameters[3, @level]
    return [[n, 1].max, 999].min
  end
  
  def lv_agi
    n = $data_actors[@actor_id].parameters[4, @level]
    return [[n, 1].max, 999].min
  end
  
  def lv_int
    n = $data_actors[@actor_id].parameters[5, @level]
    return [[n, 1].max, 999].min
  end
end
