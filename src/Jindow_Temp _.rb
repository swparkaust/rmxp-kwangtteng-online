class Jindow_Temp
  attr_accessor :inventory
  attr_accessor :skill
  attr_accessor :status
  
  def initialize
    @inventory = Rect.new(205, 162, 640, 480)
    @skill = Rect.new(258, 176, 640, 480)
    @status = Rect.new(242, 134, 640, 480)
  end
end
