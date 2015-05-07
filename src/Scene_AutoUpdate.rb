class Scene_AutoUpdate
  def main
    Jindow_AutoUpdate.new
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
    JS.dispose
  end
  
  def update
    # 패킷 데이터를 취득
    get_packet
    JS.update
  end
end
