class Jindow < Viewport
  attr_reader :skin
  attr_reader :base_file
  attr_reader :hudle
  attr_accessor :item
  attr_accessor :link
  attr_accessor :linked
  attr_accessor :linked_window
  attr_accessor :back
  attr_accessor :hwnd
  attr_accessor :name
  attr_accessor :mark
  attr_accessor :drag
  attr_accessor :nodrag
  attr_accessor :close
  attr_accessor :base_type
  attr_accessor :base_color
  
  def initialize(x, y, width, height)
    if x.rect?
      y = x.y
      width = x.width
      height = x.height
      x = x.x
    end
    @back = Viewport.new(0, 0, 1, 1)
    super(x, y, width, height)
    Hwnd.push self
    @id = Hwnd.index self
    self.z = @id + 10000
    @back.z = self.z
    @item = []
    @link = []
    @linked = false
    @linked_window = nil
    @hwnd = "hwnd"
    @skin = "Standard"
    @route = "Graphics/Jindow/" + @skin + "/Window/"
    @name = ""
    @head = false
    @mark = false
    @drag = false
    @nodrag = false
    @close = false
    @close_yn = false
    @wsv = 0
    @hsv = 0
    @width_scroll = false
    @height_scroll = false
    @base_type = 0
    @base_file = @route + "base"
    @base_color = Color.new(255, 255, 255, 255)
    @hudle = true
    @start = false
    return self
  end
  
  def skin=(val)
    @skin = val
    @route = "Graphics/Jindow/" + @skin + "/Window/"
  end
  
  def base_file=(val)
    @base_file = @route + val
  end
  
  def refresh(hwnd = @hwnd)
    @hwnd = hwnd
    @start = true
    # 스프라이트 선언
    @ul = Sprite.new(@back)
    @um = Sprite.new(@back)
    @ur = Sprite.new(@back)
    @ml = Sprite.new(@back)
    @mr = Sprite.new(@back)
    @dl = Sprite.new(@back)
    @dm = Sprite.new(@back)
    @dr = Sprite.new(@back)
    if @head
      @mark ? (@mark_s = Sprite.new(@back)) : 0
      @name ? (@name_s = Sprite.new(@back)) : 0
      @close ? (@close_s = Sprite.new(@back)) : 0
    end
    @base_s = Sprite.new(@back)
    # 비트 맵 선언 (틀 잡기)
    @ul.bitmap = Bitmap.new(@route + (@head ? "hl" : "ul"))
    @ur.bitmap = Bitmap.new(@route + (@head ? "hr" : "ur"))
    @dl.bitmap = Bitmap.new(@route + "dl")
    @dr.bitmap = Bitmap.new(@route + "dr")
    # 뷰포트 재설정
    @back.x = x - @ul.bitmap.width
    @back.y = y - @ul.bitmap.height
    @back.width = width + @ul.bitmap.width + @ur.bitmap.width
    @back.height = height + @ul.bitmap.height + @dl.bitmap.height
    # 비트 맵 선언 (늘이기, 특수)
    cw = @back.width - @ul.bitmap.width - @ur.bitmap.width
    ch = @back.height - @ul.bitmap.height - @dl.bitmap.height
    @um.bitmap = Bitmap.new(cw, @ul.bitmap.height, @route + (@head ? "hm" : "um"), 1)
    @ml.bitmap = Bitmap.new(@ul.bitmap.width, ch, @route + "ml", 1)
    @mr.bitmap = Bitmap.new(@ur.bitmap.width, ch, @route + "mr", 1)
    @dm.bitmap = Bitmap.new(cw, @dl.bitmap.height, @route + "dm", 1)
    if @head
      @mark ? (@mark_s.bitmap = Bitmap.new(@route + "mark")) : 0
      @head ? (@name_s.bitmap = Bitmap.new(self.width, @um.bitmap.height)) : 0
      @close ? (@close_s.bitmap = Bitmap.new(@route + "close")) : 0
    end
    case @base_type
    when 0
      @base_s.bitmap = Bitmap.new(self.width, self.height, @base_file, 1)
    when 1
      @base_s.bitmap = Bitmap.new(self.width, self.heght)
      @base_s.bitmap.fill_rect(@base_s.bitmap.rect, @base_color)
    end
    # 창 배열
    @um.x = @ul.bitmap.width
    @ur.x = @back.width - @ur.bitmap.width
    @ml.y = @ul.bitmap.height
    @mr.x = @back.width - @mr.bitmap.width; @mr.y = @ur.bitmap.height
    @dl.y = @back.height - @dl.bitmap.height
    @dm.x = @dl.bitmap.width; @dm.y = @back.height - @dm.bitmap.height
    @dr.x = @back.width - @dr.bitmap.width; @dr.y = @back.height - @dr.bitmap.height
    @base_s.x = @ul.x + @ul.bitmap.width; @base_s.y = @ul.y + @ul.bitmap.height;
    if @head
      @mark ? (@mark_s.x = (@ul.bitmap.width / 2) - (@mark_s.bitmap.width / 2)) : 0
      @mark ? (@mark_s.y = (@ul.bitmap.height / 2) - (@mark_s.bitmap.height / 2)) : 0
      @name_s.bitmap.font.size = 12
      @name_s.bitmap.font.color.set(0, 0, 0, 255)
      @name_s.bitmap.font.alpha = 2
      @name_s.bitmap.font.gamma.set(255, 255, 255, 255)
      @name_s.x = @um.x
      @name_s.y = @um.y
      @name_s.bitmap.draw_text(0, 0, self.width, @um.bitmap.height, @name)
      @close ? (@close_s.x = (@ur.bitmap.width / 2) - (@close_s.bitmap.width / 2) + @ur.x - 1) : 0
      @close ? (@close_s.y = (@ur.bitmap.height / 2) - (@close_s.bitmap.height / 2)) : 0
    end
    return self
  end
  
  def x=(mx)
    cx = mx - self.x
    super(mx)
    @back.x += cx
    self.refresh? ? 0 : return
    @linked ? return : 0
    @link.size == 0 ? return : 0
    for i in @link
      i.jindow? ? (i.x += cx) : next
    end
  end
  
  def y=(my)
    cy = my - self.y
    super(my)
    @back.y += cy
    self.refresh? ? 0 : return
    @linked ? return : 0
    @link.size == 0 ? return : 0
    for i in @link
      i.jindow? ? (i.y += cy) : next
    end
  end
  
  def max_width
    return (self.width + @ml.bitmap.width + @mr.bitmap.width)
  end
  
  def max_height
    return (self.height + @um.bitmap.height + @dm.bitmap.height)
  end
  
  def width=(width)
    super(width)
    self.refresh? ? 0 : return
    @back.width = width + @ul.bitmap.width + @ur.bitmap.width
  end
  
  def height=(height)
    super(height)
    self.refresh? ? 0 : return
    @back.height = height + @ul.bitmap.height + @dl.bitmap.height
  end
  
  def side_width(type = 0)
    self.refresh? ? 0 : return
    case type
    when 0
      return (@ml.bitmap.width)
    when 1
      return (@mr.bitmap.width)
    end
  end
  
  def side_height(type = 0)
    self.refresh? ? 0 : return
    case type
    when 0
      return (@um.bitmap.height)
    when 1
      return (@dm.bitmap.height)
    end
  end
  
  def opacity=(opacity)
    @ul.opacity = opacity if @ul != nil
    @um.opacity = opacity if @um != nil
    @ur.opacity = opacity if @ur != nil
    @ml.opacity = opacity if @ml != nil
    @mr.opacity = opacity if @mr != nil
    @dl.opacity = opacity if @dl != nil
    @dm.opacity = opacity if @dm != nil
    @dr.opacity = opacity if @dr != nil
    @base_s.opacity = opacity if @base_s != nil
  end
  
  def arrive?
    return Mouse.arrive_rect?(@back.rect)
  end
  
  def base?
    return Mouse.arrive_rect?(self.rect)
  end
  
  def push?
    for i in @item
      i.JS? ? 0 : next
      i.push ? (return i) : 0
    end
    return false
  end
  
  def drag?
    if @head and @drag and not self.push?
      return (Mouse.arrive_sprite?(@ul) or Mouse.arrive_sprite?(@um) or Mouse.arrive_sprite?(@ur))
    elsif @nodrag
      test = true
      for i in @item
        Mouse.arrive_sprite_rect?(i) ? (test = false) : 0
      end
      return (Mouse.arrive_rect?(@back.rect) and test)
    end
  end
  
  def highlight(cz = false)
    if cz
      self.z = cz
      @back.z = cz
    end
    @linked ? return : 0
    @id = Hwnd.index(self)
    self.z = @id + 5000
    @back.z = self.z
    @link.size == 0 ? return : 0
    for i in @link
      i.jindow? ? i.highlight(self.z) : 0
    end
  end
  
  def refresh?
    return @start
  end
  
  def scroll
    ow, oh = self.scroll?
    if ow != @wsv and ow > 0
      @wsv = ow
      @width_scroll ? scroll_width_dispose : (@width_scroll = true)
      @scroll1mid = Sprite.new(@back)
      @scroll1left = Sprite.new(@back)
      @scroll1right = Sprite.new(@back)
      @scroll1bar_mid = Sprite.new(@back)
      @scroll1bar_left = Sprite.new(@back)
      @scroll1bar_right = Sprite.new(@back)
      @scroll1left.bitmap = Bitmap.new(@route + "scroll1left")
      @scroll1right.bitmap = Bitmap.new(@route + "scroll1right")
      @scroll1bar_left.bitmap = Bitmap.new(@route + "scroll1bar_left")
      @scroll1bar_right.bitmap = Bitmap.new(@route + "scroll1bar_right")
      cw = @dm.bitmap.width - @scroll1left.bitmap.width - @scroll1right.bitmap.width
      @scroll1mid.bitmap = Bitmap.new(cw, @scroll1left.bitmap.height, @route + "scroll1mid", 1)
      ccw = cw / ((self.width + oh) * 1.0)
      @scroll1bar_mid.bitmap = Bitmap.new((ccw * self.width).round, @scroll1left.bitmap.height, @route + "scroll1bar_mid", 1)
      @scroll1left.x = @dm.x; @scroll1left.y = @dm.y
      @scroll1right.x = @dr.x - @scroll1right.bitmap.width; @scroll1right.y = @dm.y
      @scroll1mid.x = @scroll1left.x + @scroll1left.bitmap.width; @scroll1mid.y = @dm.y
      @scroll1bar_mid.x = @scroll1mid.x; @scroll1bar_mid.y = @scroll1mid.y
      @scroll1bar_left.x = @scroll1bar_mid.x - @scroll1bar_left.bitmap.width; @scroll1bar_left.y = @scroll1bar_mid.y
      @scroll1bar_right.x = @scroll1bar_mid.x + @scroll1bar_mid.bitmap.width; @scroll1bar_right.y = @scroll1bar_mid.y
    end
    if oh != @hsv and oh > 0
      @hsv = oh
      @height_scroll ? scroll_height_dispose : (@height_scroll = true)
      @scroll0mid = Sprite.new(@back)
      @scroll0up = Sprite.new(@back)
      @scroll0down = Sprite.new(@back)
      @scroll0bar_mid = Sprite.new(@back)
      @scroll0bar_up = Sprite.new(@back)
      @scroll0bar_down = Sprite.new(@back)
      @scroll0up.bitmap = Bitmap.new(@route + "scroll0up")
      @scroll0down.bitmap = Bitmap.new(@route + "scroll0down")
      @scroll0bar_up.bitmap = Bitmap.new(@route + "scroll0bar_up")
      @scroll0bar_down.bitmap = Bitmap.new(@route + "scroll0bar_down")
      ch = self.height - @scroll0up.bitmap.height - @scroll0down.bitmap.height
      @scroll0mid.bitmap = Bitmap.new(@scroll0up.bitmap.width, ch, @route + "scroll0mid", 1)
      cch = ch / ((self.height + oh) * 1.0)
      @scroll0bar_mid.bitmap = Bitmap.new(@scroll0up.bitmap.width, (cch * self.height).round, @route + "scroll0bar_mid", 1)
      @scroll0up.x = @mr.x; @scroll0up.y = @mr.y
      @scroll0down.x = @mr.x; @scroll0down.y = @dr.y - @scroll0down.bitmap.height
      @scroll0mid.x = @mr.x; @scroll0mid.y = @scroll0up.y + @scroll0up.bitmap.height
      @scroll0bar_mid.x = @scroll0mid.x; @scroll0bar_mid.y = @scroll0mid.y
      @scroll0bar_up.x = @scroll0mid.x; @scroll0bar_up.y = @scroll0bar_mid.y - @scroll0bar_up.bitmap.height
      @scroll0bar_down.x = @scroll0mid.x; @scroll0bar_down.y = @scroll0bar_mid.y + @scroll0bar_mid.bitmap.height
    end
  end
  
  def scroll_width_dispose
    @scroll1mid.dispose
    @scroll1left.dispose
    @scroll1right.dispose
    @scroll1bar_left.dispose
    @scroll1bar_mid.dispose
    @scroll1bar_right.dispose
  end
  
  def scroll_height_dispose
    @scroll0mid.dispose
    @scroll0up.dispose
    @scroll0down.dispose
    @scroll0bar_mid.dispose
    @scroll0bar_up.dispose
    @scroll0bar_down.dispose
  end
  
  def scroll?
    ow = self.width
    oh = self.height
    for i in @item
      i == nil ? next : 0
      tw = (i.x + i.width)
      tw > ow ? (ow = tw) : 0
      th = (i.y + i.height)
      th > oh ? (oh = th) : 0
    end
    pw = ow - self.width
    ph = oh - self.height
    return pw, ph
  end
  
  def width_scroll_move?
    self.push? ? (return false) : 0
    return (Mouse.arrive_sprite?(@scroll1bar_left) or Mouse.arrive_sprite?(@scroll1bar_mid) or Mouse.arrive_sprite?(@scroll1bar_right))
  end
  
  def height_scroll_move?
    self.push? ? (return false) : 0
    return (Mouse.arrive_sprite?(@scroll0bar_up) or Mouse.arrive_sprite?(@scroll0bar_mid) or Mouse.arrive_sprite?(@scroll0bar_down))
  end
  
  def scroll_update
    if @width_scroll
      w = (@scroll1mid.bitmap.width - @scroll1bar_mid.bitmap.width) * 1.0
      nw = (@scroll1bar_mid.x - @scroll1mid.x) * 1.0
      self.ox = ((@wsv / w) * nw).round
    end
    if @height_scroll
      h = (@scroll0mid.bitmap.height - @scroll0bar_mid.bitmap.height) * 1.0
      nh = (@scroll0bar_mid.y - @scroll0mid.y) * 1.0
      self.oy = ((@hsv / h) * nh).round
    end
  end
  
  def bluck?
    for i in @item
      i.JS? ? 0 : next
      i.bluck? ? (return i) : 0
    end
    return false
  end
  
  def bluck_update
    self.jindow? ? 0 : return
    @item.size == 0 ? return : 0
    Hwnd.highlight? == self ? 0 : return
    alpha = 0
    for i in @item
      if i.JS?
        alpha += 1
      end
    end
    alpha > 0 ? 0 : return
    if Key.trigger?(12)
      test = self.bluck?.id + 1
      unless bluck?
        test = 0
      end
      test > (@item.size - 1) ? (test = 0) : 0
      until @item[test].JS?
        test > (@item.size - 1) ? (test = 0) : (test += 1)
      end
      @item[test].bluck = true
    end
  end
  
  def update
    super
    refresh? ? 0 : return
    self.scroll
    self.bluck_update
    if not Hwnd.hudle(self)
      @hudle ? (@hudle = false) : 0
      if Input.mouse_lbutton
        if @head and @close and not @close_yn and Mouse.arrive_sprite?(@close_s)
          @close_yn = true
          @close_s.tone.set(-10, -10, 0)
        end
        if drag? and (@close ? (not Mouse.arrive_sprite?(@close_s)) : true)
          cx = Mouse.x - Mouse.ox
          cy = Mouse.y - Mouse.oy
          self.x -= cx
          self.y -= cy
          Mouse.x -= cx
          Mouse.y -= cy
        end
        if (@height_scroll or @width_scroll)
          cx = Mouse.x - Mouse.ox
          cy = Mouse.y - Mouse.oy
          if @width_scroll and self.width_scroll_move?
            num = @scroll1bar_mid.x + @scroll1bar_mid.bitmap.width - cx
            if @scroll1bar_mid.x - cx >= @scroll1left.x + @scroll1left.bitmap.width and num <= @scroll1right.x
              for i in [@scroll1bar_left, @scroll1bar_mid, @scroll1bar_right]
                i.x -= cx
              end
            end
          end
          if @height_scroll and self.height_scroll_move?
            num = @scroll0bar_mid.y + @scroll0bar_mid.bitmap.height - cy
            if @scroll0bar_mid.y - cy >= @scroll0up.y + @scroll0up.bitmap.height and num <= @scroll0down.y
              for i in [@scroll0bar_up, @scroll0bar_mid, @scroll0bar_down]
                i.y -= cy
              end
            end
          end
          self.scroll_update
          Mouse.x -= cx
          Mouse.y -= cy
        end
      else
        if @head and @close and @close_yn and Mouse.arrive_sprite?(@close_s)
          $game_system.se_play($data_system.cancel_se)
          Hwnd.dispose(self)
          return
        elsif @head and @close and not @close_yn and
             Mouse.arrive_sprite?(@close_s)  # 로울버 효과
          @close_s.tone.set(10, 10, 20)
        elsif @head and @close and not @close_yn and not Mouse.arrive_sprite?(@close_s)
          @close_s.tone.set(0, 0, 0)
        end
        @close_yn ? (@close_yn = false) : 0
      end
    else
      @hudle ? 0 : (@hudle = true)
    end
    if Hwnd.highlight? == self and @close and Key.trigger?(6)
      $game_system.se_play($data_system.cancel_se)
      Hwnd.dispose(self)
      return
    end
    for i in @item
      i == nil ? next : 0
      i.update
    end
  end
  
  def dispose
    for i in @link
      i.jindow? ? 0 : next
      Hwnd.dispose(i)
    end
    super
    @back.dispose
  end
end
