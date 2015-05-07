class Font
  attr_accessor :alpha
  attr_accessor :beta
  attr_accessor :gamma
  
  alias jingukang_jindow_font_initialize initialize
  def initialize(name = Config::FONT_DEFAULT_NAME, size = Config::FONT_DEFAULT_SIZE)
    @alpha = 0
    @beta = 1
    @gamma = Color.new(0, 0, 0, 255)
    jingukang_jindow_font_initialize(name, size)
  end
end
