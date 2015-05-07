module J
  class Text_Box < Sprite
    attr_reader :id
    attr_reader :skin
    attr_reader :click
    attr_reader :double_click
    attr_reader :push
    attr_accessor :type
    
    def initialize(viewport)
      super(viewport)
      @viewport = viewport
      @id = viewport.item.index self
      @viewport = viewport
      @skin = viewport.skin
      @route = "Graphics/Jindow/" + @skin + "/Window/Text_Box/"
      @file = nil
      @type = 0
      @push = false
      @click = false
      @double_click = false
      @double_wait = 0
      @bluck = false
      @start = false
      return self
    end
    
    def set(file, type)
      @file = @route + file
      @type = type
      return self
    end
    
    def file=(val)
      @file = @route + val
    end
    
    def bluck?
      return @bluck
    end
    
    def bluck=(val)
      if val and not @bluck
        @bluck = true
        for i in self.viewport.item
          i == self ? next : 0
          i.JS? ? 0 : next
          i.bluck = false
        end
      elsif not val and @bluck
        @bluck = false
      end
    end
    
    def refresh?
      return @start
    end
    
    def font
      self.refresh? ? 0 : return
      return bitmap.font
    end
    
    def refresh(width, height)
      @start = true
      case @type
      when 0
        self.bitmap = Bitmap.new(width, height)
      when 1
        self.bitmap = Bitmap.new(width, height, @file, 1)
      when 2
        left = Bitmap.new(@file + "_left")
        mid = Bitmap.new(width, left.height, @file + "_mid", 1)
        right = Bitmap.new(@file + "_right")
        self.bitmap = Bitmap.new(width, mid.height)
        self.bitmap.blt(0, 0, left, left.rect)
        self.bitmap.blt(left.width, 0, mid, mid.rect)
        self.bitmap.blt(self.width - right.width, 0, right, right.rect)
      end
      return self
    end
    
    def update
      super
      self.refresh? ? 0 : return
      @click ? (@click = false) : 0
      if not @viewport.hudle
        if Input.mouse_lbutton
          if not @push and Mouse.arrive_sprite_rect?(self) and @viewport.base?
            @push = true
            self.bluck = true
          end
        else
          @push ? (@push = false) : 0
        end
      else
      end
      if Hwnd.highlight? == @viewport and self.bluck? and Key.trigger?(4)
        @click = true
      end
    end
    
    def click=(value)
      @click = value
      self.bluck = value
    end
  end
end
