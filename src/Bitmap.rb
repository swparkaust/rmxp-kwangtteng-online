class Bitmap
  alias jingukang_jindow_bitmap_initialize initialize
  alias jingukang_jindow_bitmap_draw_text draw_text
  def initialize(width = nil, height = nil, file = "", type = 0)
    if width.string?
      jingukang_jindow_bitmap_initialize(width)
    else
      jingukang_jindow_bitmap_initialize(width, height)
    end
    case type
    when 0
    when 1
      file == "" ? return : 0
      bitmap = JS.get_bitmap(file)
      for x in 0..self.width
        for y in 0..self.height
          set_pixel(x, y, bitmap.color[x % bitmap.width][y % bitmap.height])
        end
      end
    when 2
    end
  end
  
  def draw_text(
    x = 0, y = (x.rect? ? "" : 0),
    width = (x.rect? ? 0 : 1),
    height = (x.rect? ? 0 : 1),
    str = "", align = 0)
    if x.rect?
      str = y
      align = width
      y = x.y
      width = x.width
      height = x.height
      x = x.x
    end
    case str
    when /\정렬 : ([0-9]+)/
      str[/\정렬 : ([0-9]+)/] = ""
      align = $1.to_i
    end
    case font.alpha
    when 0
      jingukang_jindow_bitmap_draw_text(x, y, width, height, str, align)
    when 1
      c = font.color.dup
      font.color.set(font.gamma.red, font.gamma.green, font.gamma.blue, font.gamma.alpha / 4)
      jingukang_jindow_bitmap_draw_text(x + font.beta, y + font.beta, width, height, str, align)
      font.color = c
      jingukang_jindow_bitmap_draw_text(x, y, width, height, str, align)
    when 2
      c = font.color.dup
      font.color = font.gamma
      jingukang_jindow_bitmap_draw_text(x + font.beta, y + font.beta, width, height, str, align)
      font.color = c
      jingukang_jindow_bitmap_draw_text(x, y, width, height, str, align)
    when 3
      c = font.color.dup
      font.color = font.gamma
      jingukang_jindow_bitmap_draw_text(x, y, width, height, str, align)
      jingukang_jindow_bitmap_draw_text(x + font.beta, y, width, height, str, align)
      jingukang_jindow_bitmap_draw_text(x + font.beta * 2, y, width, height, str, align)
      jingukang_jindow_bitmap_draw_text(x, y + font.beta, width, height, str, align)
      jingukang_jindow_bitmap_draw_text(x + font.beta * 2, y + font.beta, width, height, str, align)
      jingukang_jindow_bitmap_draw_text(x, y + font.beta * 2, width, height, str, align)
      jingukang_jindow_bitmap_draw_text(x + font.beta, y + font.beta * 2, width, height, str, align)
      jingukang_jindow_bitmap_draw_text(x + font.beta * 2, y + font.beta * 2, width, height, str, align)
      font.color = c
      jingukang_jindow_bitmap_draw_text(x + font.beta, y + font.beta, width, height, str, align)
    end
  end
end
