class Scene_Login
  attr_reader :login_window
  attr_reader :register_window
  attr_reader :status_console
  
  def main
    @login_window = Jindow_Login.new
    @status_console = Console.new(0, 300, 640, 200, 8)
    @status_console.show
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @status_console.dispose
    JS.dispose
  end
  
  def update
    # 패킷 데이터를 취득
    get_packet
    JS.update
  end
end
