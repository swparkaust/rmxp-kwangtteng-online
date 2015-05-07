module J
  class Item < Sprite
    attr_reader :id
    attr_reader :skin
    attr_reader :click
    attr_reader :double_click
    attr_reader :push
    attr_reader :item
    attr_reader :type
    attr_accessor :font
    
    def initialize(viewport = Viewport.new(0, 0, 640, 480), push = true)
      super(viewport, push)
      @id = viewport.item.index self
      @viewport = viewport
      @skin = viewport.skin
      @route = "Graphics/Icons/"
      @route2 = "Graphics/Jindow/" + @skin + "/Window/"
      @font = Font.new(Config::FONT_DEFAULT_NAME, Config::FONT_DEFAULT_SIZE)
      @font.alpha = 1
      @font.color.set(0, 0, 0, 255)
      @item = ""
      @num = 0
      @type = 0
      @fill = false
      @memory = nil
      @push = false
      @click = false
      @double_click = false
      @double_wait = 0
      @bluck = false
      @start = false
      return self
    end
    
    def refresh?
      return @start
    end
    
    def set(fill)
      @fill = fill
      return self
    end
    
    def bluck?
      return @bluck
    end
    
    def bluck=(val)
      if val and not @bluck
        @bluck = true
        self.tone.set(64, 64, 64)
        for i in self.viewport.item
          i == self ? next : 0
          i.JS? ? 0 : next
          i.bluck = false
        end
      elsif not val and @bluck
        @bluck = false
        self.tone.set(0, 0, 0)
      end
    end
    
    def refresh(id, type = 0)
      @start = true
      @type = type
      case @type
      when 0
        @item = $data_items[id]
      when 1
        @item = $data_weapons[id]
      when 2
        @item = $data_armors[id]
      end
      @num = self.num
      @num == 0 ? (return nil) : 0
      if @fill
        self.bitmap = Bitmap.new(@route2 + "item_win")
        itemwin_mid = Sprite.new
        item_bitmap = Sprite.new
        itemwin_mid.bitmap = Bitmap.new(@route2 + "itemwin_mid")
        item_bitmap.bitmap = Bitmap.new(@route + @item.icon_name)
        self.bitmap.blt(1, 1, itemwin_mid.bitmap, itemwin_mid.bitmap.rect)
        self.bitmap.blt(1, 1, item_bitmap.bitmap, item_bitmap.bitmap.rect)
        itemwin_mid.dispose
        item_bitmap.dispose
        @memory = JS.get_bitmap(self)
      else
        self.bitmap = Bitmap.new(@route2 + "itemwin_mid")
        item_bitmap = Sprite.new
        item_bitmap.bitmap = Bitmap.new(@route + @item.icon_name)
        self.bitmap.blt(0, 0, item_bitmap.bitmap, item_bitmap.bitmap.rect)
        item_bitmap.dispose
        @memory = JS.get_bitmap(self)
      end
      @num > 1 ? 0 : (return self)
      @viewport.hwnd == "Status" ? (return self) : 0
      self.bitmap.font = @font
      self.bitmap.font.alpha = @font.alpha
      self.bitmap.font.beta = @font.beta
      self.bitmap.font.gamma = @font.gamma
      rect = self.bitmap.text_size(@num.to_s)
      self.bitmap.draw_text(0, self.height - rect.height, self.width, rect.height, @num.to_s, 2)
      return self
    end
    
    def id_set
      @id = viewport.item.index self
      return self
    end
    
    def update
      super
      self.refresh? ? 0 : return
      @click ? (@click = false) : 0
      @double_click ? (@double_click = false) : 0
      if not @viewport.hudle
        if Input.mouse_lbutton
          if not @push and not @viewport.push? and Mouse.arrive_sprite_rect?(self) and @viewport.base?
            @push = true
            self.bluck = true
          end
        else
          if @push and Mouse.arrive_sprite_rect?(self) and @viewport.base?
            @click = true
          end
          @push ? (@push = false) : 0
        end
        if Mouse.arrive_sprite_rect?(self) and Input.mouse_rbutton
          jindow = Hwnd.include?("Item_Info")
          jindow ? Hwnd.dispose("Item_Info") : 0
          jindow = Jindow_Item_Info.new(@item.id, @type)
          jindow.x = Mouse.x + jindow.side_width + 5
          jindow.y = Mouse.y + jindow.side_height + 5
          if jindow.x + jindow.max_width > 640
            jindow.x = 640 - jindow.max_width
          elsif jindow.x < 0
            jindow.x = jindow.side_width
          end
          if jindow.y + jindow.max_height > 480
            jindow.y = 480 - jindow.max_height
          elsif jindow.y < 0
            jindow.y = jindow.side_height
          end
        end
      else
      end
      if @click and @double_wait == 0
        @double_wait = 7
      elsif @double_wait > 0
        @double_wait -= 1
        if @click
          @double_click = true
          @double_wait = 0
        end
      end
      if Hwnd.highlight? == @viewport and self.bluck? and Key.trigger?(4)
        @click = true
      end
      cnum = num
      if @num != cnum
        @num = cnum
        self.bitmap.clear
        for x in 0..self.bitmap.width
          for y in 0..self.bitmap.height
            self.bitmap.set_pixel(x, y, @memory.color[x][y])
          end
        end
        if @num > 1 and @viewport.hwnd != "Status"
          self.bitmap.font = @font
          self.bitmap.font.alpha = @font.alpha
          self.bitmap.font.beta = @font.beta
          self.bitmap.font.gamma = @font.gamma
          rect = self.bitmap.text_size(@num.to_s)
          self.bitmap.draw_text(0, self.height - rect.height, self.width, rect.height, @num.to_s, 2)
        end
      end
      if self.num == 0
        self.dispose
      end
    end
    
    def num
      number = 0
      case @type
      when 0
        number = $game_party.item_number(@item.id)
      when 1
        number = $game_party.weapon_number(@item.id)
      when 2
        number = $game_party.armor_number(@item.id)
      end
      if number == 0 and self.viewport.hwnd == "Status"
        case @type
        when 1
          $game_party.actors[0].weapon_id == @item.id ? (number = 1) : 0
        when 2
          $game_party.actors[0].armor1_id == @item.id ? (number = 1) : 0
          $game_party.actors[0].armor2_id == @item.id ? (number = 1) : 0
          $game_party.actors[0].armor3_id == @item.id ? (number = 1) : 0
          $game_party.actors[0].armor4_id == @item.id ? (number = 1) : 0
        end
      end
      return number
    end
    
    def click=(value)
      @click = value
      self.bluck = value
    end
  end
end
