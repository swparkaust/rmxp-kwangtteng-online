module J
  class Type
    def JS?
      return true
    end
  end
  
  class Item
    def JS?
      return true
    end
    
    def item?
      return true
    end
  end
  
  class Button
    def JS?
      return true
    end
  end
end

class Viewport
  def viewport?
    return true
  end
  
  def jindow?
    return false
  end
end

class Jindow
  def jindow?
    return true
  end
end

class Sprite
  def item?
    return false
  end
  
  def jindow?
    return false
  end
  
  def sprite?
    return true
  end
  
  def bitmap?
    return false
  end
  
  def string?
    return false
  end
  
  def JS?
    return false
  end
end

class Bitmap
  def string?
    return false
  end
  
  def bitmap?
    return true
  end
  
  def sprite?
    return false
  end
end

class Integer
  def integer?
    return true
  end
  
  def rect?
    return false
  end
  
  def string?
    return false
  end
end

class Rect
  def rect?
    return true
  end
end

class String
  def jindow?
    return false
  end
  
  def string?
    return true
  end
  
  def color?
    return false
  end
end

class Color
  def string?
    return false
  end
  
  def color?
    return false
  end
end

class FalseClass
  def jindow?
    return false
  end
  
  def string?
    return false
  end
end

class NilClass
  def item?
    return false
  end
  
  def JS?
    return false
  end
end

class GB
  attr_reader :color
  attr_reader :width
  attr_reader :height
  
  def initialize(color, width, height)
    @color = color
    @width = width
    @height = height
  end
end
