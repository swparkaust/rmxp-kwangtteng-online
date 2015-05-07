class Jindow_Item_Info < Jindow
  def initialize(item_id, type)
    super(0, 0, 150, 480)
    self.name = "아이템 정보"
    @head = true
    @mark = true
    @drag = true
    @close = true
    height = 0
    item = nil
    case type
    when 0
      item = $data_items[item_id]
    when 1
      item = $data_weapons[item_id]
    when 2
      item = $data_armors[item_id]
    end
    @route = "Graphics/Jindow/" + @skin + "/Window/"
    @icon_route = "Graphics/Icons/"
    @item_win = Sprite.new(self)
    @icon = Sprite.new(self)
    @icon.bitmap = Bitmap.new(@icon_route + item.icon_name)
    @item_win.bitmap = Bitmap.new(@route + "item_win2")
    @icon.x = @item_win.width / 2 - @icon.width / 2
    @icon.y = @item_win.height / 2 - @icon.height / 2
    height += @item_win.height
    @item_name = Sprite.new(self)
    @item_name.bitmap = Bitmap.new(100, 15 + 3)
    @item_name.x = @item_win.x + @item_win.width + 5
    @item_name.y = 12 - 3
    @item_name.bitmap.font.size = 15
    @item_name.bitmap.font.alpha = 3
    @item_name.bitmap.font.beta = 1
    @item_name.bitmap.font.color.set(255, 255, 255, 255) 
    @item_name.bitmap.font.gamma.set(0, 0, 0, 255) 
    for i in (type == 2 ? item.guard_element_set : item.element_set)
      case $data_system.elements[i]
      when "하급"
        @item_name.bitmap.font.color.set(96, 96, 96, 255) 
      when "일반"
        @item_name.bitmap.font.alpha = 3
        @item_name.bitmap.font.color.set(255, 255, 255, 255) 
      when "고급"
        @item_name.bitmap.font.alpha = 3
        @item_name.bitmap.font.color.set(0, 255, 0, 255) 
      when "희귀"
        @item_name.bitmap.font.alpha = 3
        @item_name.bitmap.font.color.set(0, 0, 255, 255) 
      when "영웅"
        @item_name.bitmap.font.alpha = 3
        @item_name.bitmap.font.color.set(128, 0, 255, 255) 
      when "전설"
        @item_name.bitmap.font.alpha = 3
        @item_name.bitmap.font.color.set(255, 128, 0, 255) 
      end
    end
    @item_name.bitmap.draw_text(0, 0, @item_name.width, @item_name.height, item.name)
    @element = Sprite.new(self)
    @element.bitmap = Bitmap.new(self.width, 14)
    @element.bitmap.font.size = 12
    @element.bitmap.font.color.set(255 ,128, 0, 255)
    @element.bitmap.font.alpha = 1
    @element.y = @item_name.y + @item_name.height
    command = ""
    case type
    when 2
      for i in item.guard_element_set
        command += "[" + $data_system.elements[i] + "]"
      end
    else
      for i in item.element_set
        command += "[" + $data_system.elements[i] + "]"
      end
    end
    @element.bitmap.draw_text(0, 0, self.width, @element.height, command, 2)
    if type != 0
      @equip = Sprite.new(self)
      @equip.bitmap = Bitmap.new(100, 14)
      @equip.bitmap.font.size = 12
      @equip.bitmap.font.alpha = 1
      @equip.x = @item_name.x
      @equip.y = @element.y + @element.height
      if $game_party.actors[0].equippable?(item)
        @equip.bitmap.font.color.set(0, 128, 0, 255)
        @equip.bitmap.draw_text(0, 0, @equip.width, @equip.height, "<착용 가능>", 2)
      else
        @equip.bitmap.font.color.set(128, 0, 0, 255)
        @equip.bitmap.draw_text(0, 0, @equip.width, @equip.height, "<착용 불가>", 2)
      end
    end
    if item.description != ""
      @description = Sprite.new(self)
      @description.y = height + 10
      height += 10
      bitmap = Bitmap.new(self.width, 480)
      bitmap.font.size = 12
      w = 0
      h = 0
      for i in item.description.scan(/./)
        rect = bitmap.text_size(i)
        if w + rect.width > self.width
          w = 0
          h += rect.height
        else
          w += rect.width
        end
      end
      @description.bitmap = Bitmap.new(self.width, h + bitmap.font.size + 2)
      @description.bitmap.font.color.set(255, 255, 255, 255)
      @description.bitmap.font.alpha = 3
      @description.bitmap.font.beta = 1
      @description.bitmap.font.gamma.set(0, 0, 0, 255)
      @description.bitmap.font.size = 12
      height += h + bitmap.font.size
      w = 0
      h = 0
      for i in item.description.scan(/./)
        rect = bitmap.text_size(i)
        if w + rect.width > self.width
          w = 0
          h += rect.height
          @description.bitmap.draw_text(w, h, rect.width, rect.height, i)
          w += rect.width
        else
          @description.bitmap.draw_text(w, h, rect.width, rect.height, i)
          w += rect.width
        end
      end
    end
    @detail = Sprite.new(self)
    @detail.y = height
    h = 0
    case type
    when 0
      item.recover_hp != 0 ? (h += bitmap.text_size(item.recover_hp .to_s).height) : 0
      item.recover_sp != 0 ? (h += bitmap.text_size(item.recover_sp.to_s).height) : 0
      item.recover_hp_rate != 0 ? (h += bitmap.text_size(item.recover_hp_rate.to_s).height) : 0
      item.recover_sp_rate != 0 ? (h += bitmap.text_size(item.recover_sp_rate.to_s).height) : 0
    when 1
      item.atk != 0 ? (h += bitmap.text_size(item.atk.to_s).height) : 0
      item.pdef != 0 ? (h += bitmap.text_size(item.pdef.to_s).height) : 0
      item.mdef != 0 ? (h += bitmap.text_size(item.mdef.to_s).height) : 0
      item.str_plus != 0 ? (h += bitmap.text_size(item.str_plus.to_s).height) : 0
      item.dex_plus != 0 ? (h += bitmap.text_size(item.dex_plus.to_s).height) : 0
      item.agi_plus != 0 ? (h += bitmap.text_size(item.agi_plus.to_s).height) : 0
      item.int_plus != 0 ? (h += bitmap.text_size(item.int_plus.to_s).height) : 0
    when 2
      item.pdef != 0 ? (h += bitmap.text_size(item.pdef.to_s).height) : 0
      item.mdef != 0 ? (h += bitmap.text_size(item.mdef.to_s).height) : 0
      item.eva != 0 ? (h += bitmap.text_size(item.eva.to_s).height) : 0
      item.str_plus != 0 ? (h += bitmap.text_size(item.str_plus.to_s).height) : 0
      item.dex_plus != 0 ? (h += bitmap.text_size(item.dex_plus.to_s).height) : 0
      item.agi_plus != 0 ? (h += bitmap.text_size(item.agi_plus.to_s).height) : 0
      item.int_plus != 0 ? (h += bitmap.text_size(item.int_plus.to_s).height) : 0
    end
    @detail.bitmap = Bitmap.new(self.width, (h == 0 ? 1 : h))
    @detail.bitmap.font.size = 12
    @detail.bitmap.font.alpha = 2
    @detail.bitmap.font.color.set(128, 128, 128, 255)
    @detail.bitmap.font.gamma.set(0, 0, 0, 255)
    height += (h == 0 ? 1 : h)
    h = 0
    case type
    when 0
      if item.recover_hp != 0
        rect = @detail.bitmap.text_size(item.recover_hp.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "HP += " + item.recover_hp.to_s)
        h += rect.height
      end
      if item.recover_sp != 0
        rect = @detail.bitmap.text_size(item.recover_sp.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "SP += " + item.recover_sp.to_s)
        h += rect.height
      end
      if item.recover_hp_rate != 0
        rect = @detail.bitmap.text_size(item.recover_hp_rate.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "HP += " + item.recover_hp_rate.to_s)
        h += rect.height
      end
      if item.recover_sp_rate != 0
        rect = @detail.bitmap.text_size(item.recover_sp_rate.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "SP += " + item.recover_sp_rate.to_s)
        h += rect.height
      end
    when 1
      if item.atk != 0
        rect = @detail.bitmap.text_size(item.atk.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "공격력 += " + item.atk.to_s)
        h += rect.height
      end
      if item.pdef != 0
        rect = @detail.bitmap.text_size(item.pdef.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "물리 방어 += " + item.pdef.to_s)
        h += rect.height
      end
      if item.mdef != 0
        rect = @detail.bitmap.text_size(item.mdef.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "마법 방어 += " + item.mdef.to_s)
        h += rect.height
      end
      if item.str_plus != 0
        rect = @detail.bitmap.text_size(item.str_plus.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "완력 += " + item.str_plus.to_s)
        h += rect.height
      end
      if item.dex_plus != 0
        rect = @detail.bitmap.text_size(item.dex_plus.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "지능 += " + item.dex_plus.to_s)
        h += rect.height
      end
      if item.agi_plus != 0
        rect = @detail.bitmap.text_size(item.agi_plus.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "민첩 += " + item.agi_plus.to_s)
        h += rect.height
      end
      if item.int_plus != 0
        rect = @detail.bitmap.text_size(item.int_plus.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "마력 += " + item.int_plus.to_s)
        h += rect.height
      end
    when 2
      if item.pdef != 0
        rect = @detail.bitmap.text_size(item.pdef.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "물리 방어 += " + item.pdef.to_s)
        h += rect.height
      end
      if item.mdef != 0
        rect = @detail.bitmap.text_size(item.mdef.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "마법 방어 += " + item.mdef.to_s)
        h += rect.height
      end
      if item.eva != 0
        rect = @detail.bitmap.text_size(item.eva.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "회피 += " + item.eva.to_s)
        h += rect.height
      end
      if item.str_plus != 0
        rect = @detail.bitmap.text_size(item.str_plus.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "완력 += " + item.str_plus.to_s)
        h += rect.height
      end
      if item.dex_plus != 0
        rect = @detail.bitmap.text_size(item.dex_plus.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "지능 += " + item.dex_plus.to_s)
        h += rect.height
      end
      if item.agi_plus != 0
        rect = @detail.bitmap.text_size(item.agi_plus.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "민첩 += " + item.agi_plus.to_s)
        h += rect.height
      end
      if item.int_plus != 0
        rect = @detail.bitmap.text_size(item.int_plus.to_s)
        @detail.bitmap.draw_text(0, h, self.width, rect.height, "마력 += " + item.int_plus.to_s)
        h += rect.height
      end
    end
    self.height = height
    self.refresh("Item_Info")
  end
end
