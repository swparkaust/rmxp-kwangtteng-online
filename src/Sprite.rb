class Sprite
  alias jingukang_jindow_sprite_initialize initialize
  alias jingukang_jindow_sprite_dispose dispose
  def initialize(viewport = Viewport.new(0, 0, 640, 480), push = true)
    (viewport.jindow? and push) ? (viewport.item.push self) : 0
    jingukang_jindow_sprite_initialize(viewport)
  end
  
  def dispose
    viewport.jindow? ? (viewport.item.delete self) : 0
    jingukang_jindow_sprite_dispose
  end
  
  def width
    return bitmap.width
  end
  
  def height
    return bitmap.height
  end
end
