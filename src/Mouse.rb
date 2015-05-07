module Mouse
  module_function
  
  def x
    return @x
  end
  
  def y
    return @y
  end

  def ox
    return @ox
  end

  def oy
    return @oy
  end

  def x=(x)
    @x = x
  end

  def y=(y)
    @y = y
  end

  def ox=(x)
    @ox = x
  end

  def oy=(y)
    @oy = y
  end
  
  @x = 0
  @y = 0
  @ox = 0
  @oy = 0
  
  def update
    x, y = Input.mouse_pos
    (x == nil or y == nil) ? return : 0
    if Input.mouse_lbutton
      @ox = x; @oy = y
    else
      @x = x; @y = y
    end
  end
  
  def arrive_rect?(x = 0, y = 0, width = 1, height = 1)
    if x.rect?
      y = x.y
      width = x.width
      height = x.height
      x = x.x
    end
    return (@x > x and @x < x + width and @y > y and @y < y + height)
  end
  
  def arrive_sprite_rect?(sprite)
    x = sprite.viewport.x + sprite.x - sprite.viewport.ox
    y = sprite.viewport.y + sprite.y - sprite.viewport.oy
    return self.arrive_rect?(x, y, sprite.bitmap.width, sprite.bitmap.height)
  end
  
  def arrive_sprite?(sprite)
    x = sprite.viewport.x + sprite.x - sprite.viewport.ox
    y = sprite.viewport.y + sprite.y - sprite.viewport.oy
    self.arrive_rect?(x, y, sprite.bitmap.width, sprite.bitmap.height) ? 0 : return
    color = sprite.bitmap.get_pixel(@x - x, @y - y)
    return ((color.red != 0 and color.green != 0 and color.blue != 0 and color.alpha != 0) ? true : false)
  end
end
