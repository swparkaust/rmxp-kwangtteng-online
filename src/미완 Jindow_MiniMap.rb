class Jindow_MiniMap < Jindow
  def initialize
    super(0, 0, 100, 100)
    self.name = "미니 맵"
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh "MiniMap"
    
  end
  
  def update
    super
    
  end
end
