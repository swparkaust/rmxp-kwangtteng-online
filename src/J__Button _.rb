module J
  class Button < Sprite
    attr_reader :id
    attr_reader :skin
    attr_reader :file
    attr_reader :push
    attr_reader :click
    attr_reader :double_click
    attr_reader :command
    attr_reader :bluck
    attr_accessor :font
    
    def initialize(viewport = Viewport.new(0, 0, 640, 480))
      super(viewport)
      @id = viewport.item.index self
      @viewport = viewport
      @skin = viewport.skin
      @route = "Graphics/Jindow/" + @skin + "/Window/"
      @file = @route + "button"
      @font = Font.new
      @font.size = 12
      @font.alpha = 1
      @font.color.set(0, 0, 0, 255)
      @width = 50
      @command = ""
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
    
    def file=(val)
      @file = @route + val
    end
    
    def refresh(width = @width, command = @command)
      @width = width
      @command = command
      @start = true
      self.refresh? ? 0 : return
      left = Sprite.new
      mid = Sprite.new
      right = Sprite.new
      message = Sprite.new
      left.bitmap = Bitmap.new(@file + "_l")
      right.bitmap = Bitmap.new(@file + "_r")
      mid.bitmap = Bitmap.new(@width - left.bitmap.width - right.bitmap.width, left.bitmap.height, @file + "_m", 1)
      self.bitmap = Bitmap.new(@width, mid.bitmap.height)
      self.bitmap.blt(0, 0, left.bitmap, left.bitmap.rect)
      self.bitmap.blt(left.bitmap.width, 0, mid.bitmap, mid.bitmap.rect)
      self.bitmap.blt(@width - right.bitmap.width, 0, right.bitmap, right.bitmap.rect)
      message.bitmap = Bitmap.new(@width, self.bitmap.height)
      message.bitmap.font = @font
      message.bitmap.font.alpha = @font.alpha
      message.bitmap.font.beta = @font.beta
      message.bitmap.font.gamma = @font.gamma
      message.bitmap.draw_text(self.bitmap.rect, command, 1)
      self.bitmap.blt(0, 0, message.bitmap, message.bitmap.rect)
      left.dispose
      mid.dispose
      right.dispose
      message.dispose
      return self
    end
    
    def bluck?
      return @bluck
    end
    
    def bluck=(val)
      if val and not @bluck
        @bluck = true
        self.tone.set(0, 0, 64)
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
    
    def update
      super
      self.refresh? ? 0 : return
      @click ? (@click = false) : 0
      if not @viewport.hudle
        if Input.mouse_lbutton
          if not @push and not @viewport.push? and Mouse.arrive_sprite?(self) and @viewport.base?
            @push = true
            self.bluck = true
          end
        else
          if @push and Mouse.arrive_sprite?(self) and @viewport.base?
            @click = true
          elsif Mouse.arrive_sprite?(self) and @viewport.base?  # 로울버 효과
            self.tone.set(10, 10, 10)
          elsif not Mouse.arrive_sprite?(self) and @viewport.base?
            self.tone.set(0, 0, 0)
          end
          @push ? (@push = false) : 0
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
    end
    
    def click=(value)
      @click = value
      self.bluck = value
    end
  end
end
