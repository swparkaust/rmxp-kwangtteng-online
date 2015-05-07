class Jindow_Status < Jindow
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 132, 184)
    self.name = "상태"
    @head = true
    @mark = true
    @drag = true
    @close = true
    @route = "Graphics/Jindow/" + @skin + "/Window/"
    self.refresh("Status")
    self.x = $jindow_temp.status.x
    self.y = $jindow_temp.status.y
    @equip_1 = Sprite.new(self)
    @equip_2 = Sprite.new(self)
    @equip_3 = Sprite.new(self)
    @equip_4 = Sprite.new(self)
    @equip_5 = Sprite.new(self)
    @equip_1.bitmap = Bitmap.new(@route + "item_win")
    @equip_2.bitmap = Bitmap.new(@route + "item_win")
    @equip_3.bitmap = Bitmap.new(@route + "item_win")
    @equip_4.bitmap = Bitmap.new(@route + "item_win")
    @equip_5.bitmap = Bitmap.new(@route + "item_win")
    itemwin_mid = Bitmap.new(@route + "itemwin_mid")
    @equip_1.bitmap.blt(1, 1, itemwin_mid, itemwin_mid.rect)
    @equip_2.bitmap.blt(1, 1, itemwin_mid, itemwin_mid.rect)
    @equip_3.bitmap.blt(1, 1, itemwin_mid, itemwin_mid.rect)
    @equip_4.bitmap.blt(1, 1, itemwin_mid, itemwin_mid.rect)
    @equip_5.bitmap.blt(1, 1, itemwin_mid, itemwin_mid.rect)
    @equip_2.x = 106
    @equip_3.y = 31
    @equip_4.x = 106
    @equip_4.y = 31
    @equip_5.y = 62
    @armor2_id = $game_party.actors[0].armor2_id
    if @armor2_id != 0
      @armor2 = J::Item.new(self).refresh(@armor2_id, 2)
      @armor2.x = 1
      @armor2.y = 1
    end
    @character = Sprite.new(self)
    @character.bitmap = Bitmap.new(@route + "character_win")
    @character.x = 31
    @armor3_id = $game_party.actors[0].armor3_id
    if @armor3_id != 0
      @armor3 = J::Item.new(self).refresh(@armor3_id, 2)
      @armor3.x = 107
      @armor3.y = 1
    end
    @weapon_id = $game_party.actors[0].weapon_id
    if @weapon_id != 0
      @weapon = J::Item.new(self).refresh(@weapon_id, 1)
      @weapon.x = 1
      @weapon.y = 32
    end
    @armor1_id = $game_party.actors[0].armor1_id
    if @armor1_id != 0
      @armor1 = J::Item.new(self).refresh(@armor1_id, 2)
      @armor1.x = 107
      @armor1.y = 32
    end
    @armor4_id = $game_party.actors[0].armor4_id
    if @armor4_id != 0
      @armor4 = J::Item.new(self).refresh(@armor4_id, 2)
      @armor4.x = 1
      @armor4.y = 63
    end
    @equip = [@weapon, @armor1, @armor2, @armor3, @armor4]
    @actor = Sprite.new(self)
    actor = $game_party.actors[0]
    bitmap = Bitmap.new("Graphics/Characters/" + actor.character_name)
    @character_name = actor.character_name
    cw = bitmap.width / 4
    ch = bitmap.height / 4
    @actor.bitmap = Bitmap.new(cw, ch)
    @actor.bitmap.blt(0, 0, bitmap, @actor.bitmap.rect)
    @actor.x = @character.x + (@character.width / 2 - @actor.width / 2)
    @actor.y = @character.height - @actor.height - 10
    @name = Sprite.new(self)
    @name.bitmap = Bitmap.new(@character.width, 20)
    @name.x = @character.x
    @name.y = @actor.y - @name.height
    @name.bitmap.font.alpha = 1
    @name.bitmap.font.beta = 2
    @name.bitmap.font.size = 12
    @name.bitmap.font.color.set(0, 128, 255, 255)
    @name.bitmap.draw_text(0, 0, @character.width, 20, $game_party.actors[0].name, 1)
    @actor_name = $game_party.actors[0].name
    @text1 = J::Text_Box.new(self)
    @text1.set("tb_6", 2).refresh(132, 0)
    @text1.y = @character.y + @character.height
    @text1.font.alpha = 1
    @text1.bitmap.font.size = 12
    @text1.bitmap.font.color.set(0, 0, 0, 255)
    @text1.bitmap.draw_text(0, 0, @text1.width, @text1.height, actor.name, 0)
    @text1.bitmap.font.color.set(0, 0, 0, 255)
    @text1.bitmap.draw_text(0, 0, @text1.width, @text1.height, "Lv " + actor.level.to_s, 2)
    @level = actor.level
    @text2 = J::Text_Box.new(self)
    @text2.set("tb_1", 1).refresh(132, 13)
    @text2.y = @text1.y + @text1.height
    @text2.font.alpha = 1
    @text2.bitmap.font.size = 12
    @text2.bitmap.font.color.set(128, 0, 255, 255)
    @text2.bitmap.draw_text(0, 0, @text2.width, @text2.height, "[" + actor.class_name + "]", 2)
    @class_name = actor.class_name
    @text3 = J::Text_Box.new(self)
    @text3.set("tb_2", 2).refresh(44, 0)
    @text3.y = @text2.y + @text2.height + 1
    @text3.font.alpha = 1
    @text3.bitmap.font.size = 12
    @text3.bitmap.font.color.set(0, 0, 0, 255)
    @text3.bitmap.draw_text(0, 0, @text3.width, @text3.height, "완력", 1)
    @text3_2 = J::Text_Box.new(self)
    @text3_2.set("tb_2", 2).refresh(36, 0)
    @text3_2.x = @text3.x + @text3.width - 1
    @text3_2.y = @text2.y + @text2.height + 1
    @text3_2.font.alpha = 1
    @text3_2.bitmap.font.size = 12
    @text3_2.bitmap.font.color.set(0, 0, 255, 255)
    n = 0
    weapon = $data_weapons[actor.weapon_id]
    armor1 = $data_armors[actor.armor1_id]
    armor2 = $data_armors[actor.armor2_id]
    armor3 = $data_armors[actor.armor3_id]
    armor4 = $data_armors[actor.armor4_id]
    n += (weapon != nil and actor.weapon_id != 0) ? weapon.str_plus : 0
    n += (armor1 != nil and actor.armor1_id != 0) ? armor1.str_plus : 0
    n += (armor2 != nil and actor.armor2_id != 0) ? armor2.str_plus : 0
    n += (armor3 != nil and actor.armor3_id != 0) ? armor3.str_plus : 0
    n += (armor4 != nil and actor.armor4_id != 0) ? armor4.str_plus : 0
    @text3_2.bitmap.draw_text(0, 1, @text3_2.width, @text3_2.height, "(+" + n.to_s + ")", 1)
    @str_plus = n
    @text3_3 = J::Text_Box.new(self)
    @text3_3.set("tb_3", 2).refresh(54, 0)
    @text3_3.x = @text3_2.x + @text3_2.width - 1
    @text3_3.y = @text2.y + @text2.height + 1
    @text3_3.font.alpha = 1
    @text3_3.bitmap.font.size = 12
    @text3_3.bitmap.font.color.set(0, 0, 0, 255)
    @text3_3.bitmap.draw_text(0, 1, @text3_3.width - 5, @text3_3.height, actor.str.to_s, 2)
    @str = actor.str
    @text4 = J::Text_Box.new(self)
    @text4.set("tb_2", 2).refresh(44, 0)
    @text4.y = @text3.y + @text3.height + 1
    @text4.font.alpha = 1
    @text4.bitmap.font.size = 12
    @text4.bitmap.font.color.set(0, 0, 0, 255)
    @text4.bitmap.draw_text(0, 0, @text4.width, @text4.height, "지능", 1)
    @text4_2 = J::Text_Box.new(self)
    @text4_2.set("tb_2", 2).refresh(36, 0)
    @text4_2.x = @text4.x + @text4.width - 1
    @text4_2.y = @text3.y + @text3.height + 1
    @text4_2.font.alpha = 1
    @text4_2.bitmap.font.size = 12
    @text4_2.bitmap.font.color.set(0, 0, 255, 255)
    n = 0
    n += (weapon != nil and actor.weapon_id != 0) ? weapon.dex_plus : 0
    n += (armor1 != nil and actor.armor1_id != 0) ? armor1.dex_plus : 0
    n += (armor2 != nil and actor.armor2_id != 0) ? armor2.dex_plus : 0
    n += (armor3 != nil and actor.armor3_id != 0) ? armor3.dex_plus : 0
    n += (armor4 != nil and actor.armor4_id != 0) ? armor4.dex_plus : 0
    @text4_2.bitmap.draw_text(0, 1, @text4_2.width, @text4_2.height, "(+" + n.to_s + ")", 1)
    @dex_plus = n
    @text4_3 = J::Text_Box.new(self)
    @text4_3.set("tb_3", 2).refresh(54, 0)
    @text4_3.x = @text4_2.x + @text4_2.width - 1
    @text4_3.y = @text3.y + @text3.height + 1
    @text4_3.font.alpha = 1
    @text4_3.bitmap.font.size = 12
    @text4_3.bitmap.font.color.set(0, 0, 0, 255)
    @text4_3.bitmap.draw_text(0, 1, @text4_3.width - 5, @text4_3.height, actor.dex.to_s, 2)
    @dex = actor.dex
    @text5 = J::Text_Box.new(self)
    @text5.set("tb_2", 2).refresh(44, 0)
    @text5.y = @text4.y + @text4.height + 1
    @text5.font.alpha = 1
    @text5.bitmap.font.size = 12
    @text5.bitmap.font.color.set(0, 0, 0, 255)
    @text5.bitmap.draw_text(0, 0, @text5.width, @text5.height, "민첩", 1)
    @text5_2 = J::Text_Box.new(self)
    @text5_2.set("tb_2", 2).refresh(36, 0)
    @text5_2.x = @text5.x + @text5.width - 1
    @text5_2.y = @text4.y + @text4.height + 1
    @text5_2.font.alpha = 1
    @text5_2.bitmap.font.size = 12
    @text5_2.bitmap.font.color.set(0, 0, 255, 255)
    n = 0
    n += (weapon != nil and actor.weapon_id != 0) ? weapon.agi_plus : 0
    n += (armor1 != nil and actor.armor1_id != 0) ? armor1.agi_plus : 0
    n += (armor2 != nil and actor.armor2_id != 0) ? armor2.agi_plus : 0
    n += (armor3 != nil and actor.armor3_id != 0) ? armor3.agi_plus : 0
    n += (armor4 != nil and actor.armor4_id != 0) ? armor4.agi_plus : 0
    @text5_2.bitmap.draw_text(0, 1, @text5_2.width, @text5_2.height, "(+" + n.to_s + ")", 1)
    @agi_plus = n
    @text5_3 = J::Text_Box.new(self)
    @text5_3.set("tb_3", 2).refresh(54, 0)
    @text5_3.x = @text5_2.x + @text5_2.width - 1
    @text5_3.y = @text4.y + @text4.height + 1
    @text5_3.font.alpha = 1
    @text5_3.bitmap.font.size = 12
    @text5_3.bitmap.font.color.set(0, 0, 0, 255)
    @text5_3.bitmap.draw_text(0, 1, @text5_3.width - 5, @text5_3.height, actor.agi.to_s, 2)
    @agi = actor.agi
    @text6 = J::Text_Box.new(self)
    @text6.set("tb_2", 2).refresh(44, 0)
    @text6.y = @text5.y + @text5.height + 1
    @text6.font.alpha = 1
    @text6.bitmap.font.size = 12
    @text6.bitmap.font.color.set(0, 0, 0, 255)
    @text6.bitmap.draw_text(0, 0, @text6.width, @text6.height, "마력", 1)
    @text6_2 = J::Text_Box.new(self)
    @text6_2.set("tb_2", 2).refresh(36, 0)
    @text6_2.x = @text6.x + @text6.width - 1
    @text6_2.y = @text5.y + @text5.height + 1
    @text6_2.font.alpha = 1
    @text6_2.bitmap.font.size = 12
    @text6_2.bitmap.font.color.set(0, 0, 255, 255)
    n = 0
    n += (weapon != nil and actor.weapon_id != 0) ? weapon.int_plus : 0
    n += (armor1 != nil and actor.armor1_id != 0) ? armor1.int_plus : 0
    n += (armor2 != nil and actor.armor2_id != 0) ? armor2.int_plus : 0
    n += (armor3 != nil and actor.armor3_id != 0) ? armor3.int_plus : 0
    n += (armor4 != nil and actor.armor4_id != 0) ? armor4.int_plus : 0
    @text6_2.bitmap.draw_text(0, 1, @text6_2.width, @text6_2.height, "(+" + n.to_s + ")", 1)
    @int_plus = n
    @text6_3 = J::Text_Box.new(self)
    @text6_3.set("tb_3", 2).refresh(54, 0)
    @text6_3.x = @text6_2.x + @text6_2.width - 1
    @text6_3.y = @text5.y + @text5.height + 1
    @text6_3.font.alpha = 1
    @text6_3.bitmap.font.size = 12
    @text6_3.bitmap.font.color.set(0, 0, 0, 255)
    @text6_3.bitmap.draw_text(0, 1, @text6_3.width - 5, @text6_3.height, actor.int.to_s, 2)
    @int = actor.int
  end
  
  def update
    self.x != $jindow_temp.status.x ? ($jindow_temp.status.x = self.x) : 0
    self.y != $jindow_temp.status.y ? ($jindow_temp.status.y = self.y) : 0
    super
    actor = $game_party.actors[0]
    if @character_name != actor.character_name
      @actor.dispose
      @actor = Sprite.new(self)
      bitmap = Bitmap.new("Graphics/Characters/" + actor.character_name)
      @character_name = actor.character_name
      cw = bitmap.width / 4
      ch = bitmap.height / 4
      @actor.bitmap = Bitmap.new(cw, ch)
      @actor.bitmap.blt(0, 0, bitmap, @actor.bitmap.rect)
      @actor.x = @character.x + (@character.width / 2 - @actor.width / 2)
      @actor.y = @character.height - @actor.height - 10
    end
    if @actor_name != $game_party.actors[0].name
      @name.dispose
      @name = Sprite.new(self)
      @name.bitmap = Bitmap.new(@character.width, 20)
      @name.x = @character.x
      @name.y = @actor.y - @name.height
      @name.bitmap.font.alpha = 1
      @name.bitmap.font.beta = 2
      @name.bitmap.font.size = 12
      @name.bitmap.font.color.set(0, 128, 255, 255)
      @name.bitmap.draw_text(0, 0, @character.width, 20, $game_party.actors[0].name, 1)
      @actor_name = $game_party.actors[0].name
    end
    if @level != actor.level
      @text1.dispose
      @text1 = J::Text_Box.new(self)
      @text1.set("tb_6", 2).refresh(132, 0)
      @text1.y = @character.y + @character.height
      @text1.font.alpha = 1
      @text1.bitmap.font.size = 12
      @text1.bitmap.font.color.set(0, 0, 0, 255)
      @text1.bitmap.draw_text(0, 0, @text1.width, @text1.height, actor.name, 0)
      @text1.bitmap.font.color.set(0, 0, 0, 255)
      @text1.bitmap.draw_text(0, 0, @text1.width, @text1.height, "Lv " + actor.level.to_s, 2)
      @level = actor.level
    end
    if @class_name != actor.class_name
      @text2.dispose
      @text2 = J::Text_Box.new(self)
      @text2.set("tb_1", 1).refresh(132, 13)
      @text2.y = @text1.y + @text1.height
      @text2.font.alpha = 1
      @text2.bitmap.font.size = 12
      @text2.bitmap.font.color.set(128, 0, 255, 255)
      @text2.bitmap.draw_text(0, 0, @text2.width, @text2.height, "[" + actor.class_name + "]", 2)
      @class_name = actor.class_name
    end
    weapon = $data_weapons[actor.weapon_id]
    armor1 = $data_armors[actor.armor1_id]
    armor2 = $data_armors[actor.armor2_id]
    armor3 = $data_armors[actor.armor3_id]
    armor4 = $data_armors[actor.armor4_id]
    n = 0
    n += (weapon != nil and actor.weapon_id != 0) ? weapon.str_plus : 0
    n += (armor1 != nil and actor.armor1_id != 0) ? armor1.str_plus : 0
    n += (armor2 != nil and actor.armor2_id != 0) ? armor2.str_plus : 0
    n += (armor3 != nil and actor.armor3_id != 0) ? armor3.str_plus : 0
    n += (armor4 != nil and actor.armor4_id != 0) ? armor4.str_plus : 0
    if @str_plus != n
      @text3_2.dispose
      @text3_2 = J::Text_Box.new(self)
      @text3_2.set("tb_2", 2).refresh(36, 0)
      @text3_2.x = @text3.x + @text3.width - 1
      @text3_2.y = @text2.y + @text2.height + 1
      @text3_2.font.alpha = 1
      @text3_2.bitmap.font.size = 12
      @text3_2.bitmap.font.color.set(0, 0, 255, 255)
      @text3_2.bitmap.draw_text(0, 1, @text3_2.width, @text3_2.height, "(+" + n.to_s + ")", 1)
      @str_plus = n
    end
    if @str != actor.str
      @text3_3.dispose
      @text3_3 = J::Text_Box.new(self)
      @text3_3.set("tb_3", 2).refresh(54, 0)
      @text3_3.x = @text3_2.x + @text3_2.width - 1
      @text3_3.y = @text2.y + @text2.height + 1
      @text3_3.font.alpha = 1
      @text3_3.bitmap.font.size = 12
      @text3_3.bitmap.font.color.set(0, 0, 0, 255)
      @text3_3.bitmap.draw_text(0, 1, @text3_3.width - 5, @text3_3.height, actor.str.to_s, 2)
      @str = actor.str
    end
    n = 0
    n += (weapon != nil and actor.weapon_id != 0) ? weapon.dex_plus : 0
    n += (armor1 != nil and actor.armor1_id != 0) ? armor1.dex_plus : 0
    n += (armor2 != nil and actor.armor2_id != 0) ? armor2.dex_plus : 0
    n += (armor3 != nil and actor.armor3_id != 0) ? armor3.dex_plus : 0
    n += (armor4 != nil and actor.armor4_id != 0) ? armor4.dex_plus : 0
    if @dex_plus != n
      @text4_2.dispose
      @text4_2 = J::Text_Box.new(self)
      @text4_2.set("tb_2", 2).refresh(36, 0)
      @text4_2.x = @text4.x + @text4.width - 1
      @text4_2.y = @text3.y + @text3.height + 1
      @text4_2.font.alpha = 1
      @text4_2.bitmap.font.size = 12
      @text4_2.bitmap.font.color.set(0, 0, 255, 255)
      @text4_2.bitmap.draw_text(0, 1, @text4_2.width, @text4_2.height, "(+" + n.to_s + ")", 1)
      @dex_plus = n
    end
    if @dex != actor.dex
      @text4_3.dispose
      @text4_3 = J::Text_Box.new(self)
      @text4_3.set("tb_3", 2).refresh(54, 0)
      @text4_3.x = @text4_2.x + @text4_2.width - 1
      @text4_3.y = @text3.y + @text3.height + 1
      @text4_3.font.alpha = 1
      @text4_3.bitmap.font.size = 12
      @text4_3.bitmap.font.color.set(0, 0, 0, 255)
      @text4_3.bitmap.draw_text(0, 1, @text4_3.width - 5, @text4_3.height, actor.dex.to_s, 2)
      @dex = actor.dex
    end
    n = 0
    n += (weapon != nil and actor.weapon_id != 0) ? weapon.agi_plus : 0
    n += (armor1 != nil and actor.armor1_id != 0) ? armor1.agi_plus : 0
    n += (armor2 != nil and actor.armor2_id != 0) ? armor2.agi_plus : 0
    n += (armor3 != nil and actor.armor3_id != 0) ? armor3.agi_plus : 0
    n += (armor4 != nil and actor.armor4_id != 0) ? armor4.agi_plus : 0
    if @agi_plus != n
      @text5_2.dispose
      @text5_2 = J::Text_Box.new(self)
      @text5_2.set("tb_2", 2).refresh(36, 0)
      @text5_2.x = @text5.x + @text5.width - 1
      @text5_2.y = @text4.y + @text4.height + 1
      @text5_2.font.alpha = 1
      @text5_2.bitmap.font.size = 12
      @text5_2.bitmap.font.color.set(0, 0, 255, 255)
      @text5_2.bitmap.draw_text(0, 1, @text5_2.width, @text5_2.height, "(+" + n.to_s + ")", 1)
      @agi_plus = n
    end
    if @agi != actor.agi
      @text5_3.dispose
      @text5_3 = J::Text_Box.new(self)
      @text5_3.set("tb_3", 2).refresh(54, 0)
      @text5_3.x = @text5_2.x + @text5_2.width - 1
      @text5_3.y = @text4.y + @text4.height + 1
      @text5_3.font.alpha = 1
      @text5_3.bitmap.font.size = 12
      @text5_3.bitmap.font.color.set(0, 0, 0, 255)
      @text5_3.bitmap.draw_text(0, 1, @text5_3.width - 5, @text5_3.height, actor.agi.to_s, 2)
      @agi = actor.agi
    end
    n = 0
    n += (weapon != nil and actor.weapon_id != 0) ? weapon.int_plus : 0
    n += (armor1 != nil and actor.armor1_id != 0) ? armor1.int_plus : 0
    n += (armor2 != nil and actor.armor2_id != 0) ? armor2.int_plus : 0
    n += (armor3 != nil and actor.armor3_id != 0) ? armor3.int_plus : 0
    n += (armor4 != nil and actor.armor4_id != 0) ? armor4.int_plus : 0
    if @int_plus != n
      @text6_2.dispose
      @text6_2 = J::Text_Box.new(self)
      @text6_2.set("tb_2", 2).refresh(36, 0)
      @text6_2.x = @text6.x + @text6.width - 1
      @text6_2.y = @text5.y + @text5.height + 1
      @text6_2.font.alpha = 1
      @text6_2.bitmap.font.size = 12
      @text6_2.bitmap.font.color.set(0, 0, 255, 255)
      @text6_2.bitmap.draw_text(0, 1, @text6_2.width, @text6_2.height, "(+" + n.to_s + ")", 1)
      @int_plus = n
    end
    if @int != actor.int
      @text6_3.dispose
      @text6_3 = J::Text_Box.new(self)
      @text6_3.set("tb_3", 2).refresh(54, 0)
      @text6_3.x = @text6_2.x + @text6_2.width - 1
      @text6_3.y = @text5.y + @text5.height + 1
      @text6_3.font.alpha = 1
      @text6_3.bitmap.font.size = 12
      @text6_3.bitmap.font.color.set(0, 0, 0, 255)
      @text6_3.bitmap.draw_text(0, 1, @text6_3.width - 5, @text6_3.height, actor.int.to_s, 2)
      @int = actor.int
    end
    if @weapon and @weapon.double_click
      $game_party.actors[0].equip(0, 0)
    elsif @armor1 and @armor1.double_click
      $game_party.actors[0].equip(1, 0)
    elsif @armor2 and @armor2.double_click
      $game_party.actors[0].equip(2, 0)
    elsif @armor3 and @armor3.double_click
      $game_party.actors[0].equip(3, 0)
    elsif @armor4 and @armor4.double_click
      $game_party.actors[0].equip(4, 0)
    end
    if @weapon_id != $game_party.actors[0].weapon_id
      @weapon_id = $game_party.actors[0].weapon_id
      @weapon ? (@weapon.dispose; @weapon = nil) : 0
      if @weapon_id != 0
        @weapon = J::Item.new(self).refresh(@weapon_id, 1)
        @weapon.y = 26 + 5
      end
    end
    if @armor1_id != $game_party.actors[0].armor1_id
      @armor1_id = $game_party.actors[0].armor1_id
      @armor1 ? (@armor1.dispose; @armor1 = nil) : 0
      if @armor1_id != 0
        @armor1 = J::Item.new(self).refresh(@armor1_id, 2)
        @armor1.x = 31 + 70 + 5
        @armor1.y = 26 + 5
      end
    end
    if @armor2_id != $game_party.actors[0].armor2_id
      @armor2_id = $game_party.actors[0].armor2_id
      @armor2 ? (@armor2.dispose; @armor2 = nil) : 0
      if @armor2_id != 0
        @armor2 = J::Item.new(self).refresh(@armor2_id, 2)
      end
    end
    if @armor3_id != $game_party.actors[0].armor3_id
      @armor3_id = $game_party.actors[0].armor3_id
      @armor3 ? (@armor3.dispose; @armor3 = nil) : 0
      if @armor3_id != 0
        @armor3 = J::Item.new(self).refresh(@armor3_id, 2)
        @armor3.x = 31+ 70 + 5
      end
    end
    if @armor4_id != $game_party.actors[0].armor4_id
      @armor4_id = $game_party.actors[0].armor4_id
      @armor4 ? (@armor4.dispose; @armor4 = nil) : 0
      if @armor4_id != 0
        @armor4 = J::Item.new(self).refresh(@armor4_id, 2)
        @armor4.y = 31 + 26 + 5
      end
    end
  end
end
