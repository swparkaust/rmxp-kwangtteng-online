class Jindow_Inventory < Jindow
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 206, 128)
    self.name = "인벤토리"
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh("Inventory")
    self.x = $jindow_temp.inventory.x
    self.y = $jindow_temp.inventory.y
    for i in 1..$data_items.size
      if $game_party.item_number(i) > 0
        J::Item.new(self).set(true).refresh($data_items[i].id, 0)
      end
    end
    for i in 1..$data_weapons.size
      if $game_party.weapon_number(i) > 0
        J::Item.new(self).set(true).refresh($data_weapons[i].id, 1)
      end
    end
    for i in 1..$data_armors.size
      if $game_party.armor_number(i) > 0
        J::Item.new(self).set(true).refresh($data_armors[i].id, 2)
      end
    end
    for i in @item
      i.x = (i.id % 7) * 30
      i.y = (i.id / 7) * 30 + 12
    end
  end
  
  def update
    self.x != $jindow_temp.inventory.x ? ($jindow_temp.inventory.x = self.x) : 0
    self.y != $jindow_temp.inventory.y ? ($jindow_temp.inventory.y = self.y) : 0
    for i in @item
      i.item? ? 0 : next
      i.double_click ? 0 : next
      case i.type
      when 0
        $game_party.actors[0].item_effect(i.item)
        $game_system.se_play(i.item.menu_se)
        if i.item.consumable
          $game_party.lose_item(i.item.id, 1)
          if i.num <= 0
            id = i.id
            @item[id] = nil
            i.dispose
          end
        end
      when 1
        if $game_party.actors[0].equippable?(i.item)
          $game_party.actors[0].equip(0, i.item.id)
        end
      when 2
        if $game_party.actors[0].equippable?(i.item)
          $game_party.actors[0].equip(i.item.kind + 1, i.item.id)
        end
      end
    end
    super
  end
end
