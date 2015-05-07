class Game_Party
  alias jingukang_jindow_game_party_gain_item gain_item
  def jindow_item_include?(id, type)
    jindow = Hwnd.include?("Inventory", 1)
    jindow ? 0 : (return true)
    for i in jindow.item
      i.item? ? 0 : next
      case type
      when 0
        i.item == $data_items[id] ? (return true) : 0
      when 1
        i.item == $data_weapons[id] ? (return true) : 0
      when 2
        i.item == $data_armors[id] ? (return true) : 0
      end
    end
    return false
  end
  
  def jindow_push_item(item_id, type)
    id = 0
    jindow = Hwnd.include?("Inventory", 1)
    loop do
      if jindow.item[id] == nil
        jindow.item[id] = J::Item.new(jindow, false).set(true).refresh(item_id, type)
        jindow.item[id].x = (id % 7) * 30
        jindow.item[id].y = (id / 7) * 30 + 12
        jindow.item[id].id_set
        break
      end
      id += 1
    end
  end
  
  def gain_item(id, n)
    jingukang_jindow_game_party_gain_item(id, n)
    if n > 0 and not jindow_item_include?(id, 0)
      jindow_push_item(id, 0)
    end
  end
  
  def gain_weapon(weapon_id, n, equip = false)
    if weapon_id > 0
      @weapons[weapon_id] = [[weapon_number(weapon_id) + n, 0].max, 99].min
    end
    if n > 0 and not equip and not jindow_item_include?(weapon_id, 1)
      jindow_push_item(weapon_id, 1)
    end
  end
  
  def gain_armor(armor_id, n, equip = false)
    if armor_id > 0
      @armors[armor_id] = [[armor_number(armor_id) + n, 0].max, 99].min
    end
    if n > 0 and not equip and not jindow_item_include?(armor_id, 2)
      jindow_push_item(armor_id, 2)
    end
  end
end
