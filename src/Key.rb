KEY_LEFT = 0  # 커서 키[←]
KEY_UP = 1  # 커서 키[↑]
KEY_RIGHT = 2  # 커서 키[→]
KEY_DOWN = 3  # 커서 키[↓]
KEY_ENTER = 4  # [ENTER]
KEY_SPACE = 5  # [SPACE]
KEY_ESC = 6  # [ESC]
KEY_BACKSPACE = 7  # [BACKSPACE]
KEY_DELETE = 8  # [DELETE]
KEY_SHIFT = 9  # [SHIFT]
KEY_CTRL = 10  # [CTRL]
KEY_ALT = 11  # [ALT]
KEY_TAB = 12  # [TAB]
KEY_CAPSLOCK = 13  # [CAPSLOCK]
KEY_0 = 14  # [0]
KEY_1 = 15  # [1]
KEY_2 = 16  # [2]
KEY_3 = 17  # [3]
KEY_4 = 18  # [4]
KEY_5 = 19  # [5]
KEY_6 = 20  # [6]
KEY_7 = 21  # [7]
KEY_8 = 22  # [8]
KEY_9 = 23  # [9]
KEY_A = 24  # [A]
KEY_B = 25  # [B]
KEY_C = 26  # [C]
KEY_D = 27  # [D]
KEY_E = 28  # [E]
KEY_F = 29  # [F]
KEY_G = 30  # [G]
KEY_H = 31  # [H]
KEY_I = 32  # [I]
KEY_J = 33  # [J]
KEY_K = 34  # [K]
KEY_L = 35  # [L]
KEY_M = 36  # [M]
KEY_N = 37  # [N]
KEY_O = 38  # [O]
KEY_P = 39  # [P]
KEY_Q = 40  # [Q]
KEY_R = 41  # [R]
KEY_S = 42  # [S]
KEY_T = 43  # [T]
KEY_U = 44  # [U]
KEY_V = 45  # [V]
KEY_W = 46  # [W]
KEY_X = 47  # [X]
KEY_Y = 48  # [Y]
KEY_Z = 49  # [Z]

#------------------------------------------------------------------------------
# ●임의 키 취득 스크립트  by tonbi
#
#  최신판의 정보나 버그 보고는 여기 → http://www.mc.ccnw.ne.jp/sarada/toshi/
#
# 이것을 사용한 것으로 ，이벤트의 스크립트로부터 ，
#
#   get_press(variable,key)       키가 눌러지고 있는가 취득 
#   get_trigger(variable,key)     키가 누른 순간인지 취득 
#   get_repeat(variable,key)      키가 눌러지고 있는가 취득(일정 시간마다)
#   get_press_all(variable)       상기의 일괄 취득 판
#   get_trigger_all(variable)     상기의 일괄 취득 판
#   get_repeat_all(variable)      상기의 일괄 취득 판
#
#   ※variable = 변수 ID  key = 키 ID　입니다．
#
# 이들이 실행할 수 있게 됩니다．
# 각각，지정한 넘버의 변수에 ，눌러지고 있다면 １，다르면０이 대입됩니다．
# 또，하단의 일괄 취득계는 ，지정한 변수의 넘버로부터 순서로，키 ID:0,1,2,···
# 토스 가와의 키 ID가 대입되고 갑니다．
#
# 조건 분기의 스크립트로 ，Key.press?(key) 라고(와) 넣으면 ，변수 사용하지 않고 분기될 수 있습니다．
# Key.trigger?(key)，Key.repeat?(key) 모방할 수 있습니다．
# 
# 키 ID 초기 설정은 ，(타이핑겜 기분?)
#
#      0 : 커서 키[←]
#      1 : 커서 키[↑]
#      2 : 커서 키[→]
#      3 : 커서 키[↓]
#      4 : [ENTER]
#      5 : [SPACE]
#      6 : [ESC]
#      7 : [BACKSPACE]
#      8 : [DELETE]
#      9 : [SHIFT]
#     10 : [CTRL]
#     11 : [ALT]
#     12 : [TAB]
#     13 : [CAPSLOCK]
# 14∼23 : [0]∼[9]（메인 키보드）
# 24∼49 : [A]∼[Z]
# 50∼59 : [0]∼[9]（텐 키）
#     60 : [,] (값)
#     61 : [.] (る)
#     62 : [/] (싹)
#     63 : [_] (로)
#     64 : [;] (れ)
#     65 : [:] (け)
#     66 : []] (무)
#     67 : [@] (＂)
#     68 : [[] (。)
#     69 : [-] (돛)
#     70 : [^] (에)
#     71 : [\]
#
# 아래쪽의 ★도장의 코멘트의 주변을 만지면，
# 필요하지 않는 키를 삭제하거나 ，늘리거나 를 할 수 있습니다．
# 키 코드의 지식이 필요합니다만 ．
#   
#------------------------------------------------------------------------------
# ●스크립트로부터 직접 다양한 키를 취득하고 싶은 쪽에 
#
# １．취득하고 싶은 장면의 Input.update의 뒤 정답에 「Key.update」를 추가 
# ２．Key.trigger?(keyID)로서 취득한다．press?，repeat?그러나 가
#　　　덧붙여서 되돌아가고 값은 Input의 경우와 동일한．
#
#------------------------------------------------------------------------------   

#==============================================================================
# ■ Key
# 키 취득을 관리한 클래스 
#==============================================================================

module Key
  #----------------------------------------------------------
  # ● 오브젝트 초기화 
  #----------------------------------------------------------
  def self.setup
    @keystatus=[]
    @getkeystate = Win32API.new("user32", "GetKeyState", "i", "i")
  end
  #----------------------------------------------------------
  # ● 갱신 
  #----------------------------------------------------------
  def self.update
    for i in @keystatus
      num1 = false
      for j in i[1]
        num2=@getkeystate.call(j)
        if num2 != 1 and num2 != 0
          num1 = true
          break
        end
      end
      if num1 == false
        if i[0] > 0
          i[0] = i[0]*-1
        else 
          i[0] = 0
        end
      else
        if i[0] > 0
          i[0] += 1
        else
          i[0] = 1
        end
      end
    end
  end
  #----------------------------------------------------------
  # ● 키가 설정된 최대 삭
  #----------------------------------------------------------
  def self.max
    return @keystatus.size
  end
  #----------------------------------------------------------
  # ● 키 설정을 추가하다 
  #     id    추가 선ＩＤ
  #     code  추가한 키 코드 
  #----------------------------------------------------------
  def self.add_key(id,code)
    if @keystatus[id]=nil
      keystatus[id]=[]
    end
    @keystatus[id][0]=0
    @keystatus[id][1].push(code)
  end
  #----------------------------------------------------------
  # ● 키 설정을 삭제하다 
  #     id    삭제 ＩＤ
  #----------------------------------------------------------
  def self.del_key(id)
    @keystatus[id]=nil
  end
  #----------------------------------------------------------
  # ● 키 설정을 일괄 변경하다 
  #     val    키 설정의 배열，２ 차원 
  #     예　[[65],[66,67],[68]]
  #     졸참나무,  ID.0=Ａ 키，ID.1=Ｂ와 Ｃ 키，ID.2=Ｄ 키와 설정 
  #----------------------------------------------------------
  def self.add_key_set(val)
    @keystatus = []
    for i in 0...val.size
      if @keystatus[i]==nil
        @keystatus[i]=[]
      end
      @keystatus[i][0]=0
      @keystatus[i][1]=val[i]
    end
  end
  #----------------------------------------------------------
  # ● 키 설정을 일괄 삭제한다 
  #----------------------------------------------------------
  def self.del_key_set
    @keystatus[i]=nil
  end
  #----------------------------------------------------------
  # ● 키 정보를 돌려 준다．Input와 동일한．
  #     id   키 ID
  #----------------------------------------------------------
  def self.press?(id)
    if @keystatus[id][0] > 0
      return true
    else
      return false
    end
  end
  
  def self.trigger?(id)
    if @keystatus[id][0] == 1
      return true
    else
      return false
    end
  end
  
  def self.repeat?(id)
    if @keystatus[id][0] <= 0
      return false
    else
      if @keystatus[id][0] % 5 == 1 and @keystatus[id][0] % 5 != 2
        return true
      else
        return false
      end
    end
  end
  
  def self.install
    #----------------------------------------------------------------
    # ★여기를 만지면，키 ID와 키 코드의 설정을 바꾸는 일을 할 수 있습니다．
    # １개의 ID에 여러 키 넣고 싶다면 
    # 변수 val = [[37],[38],[39],[40],[13,32]]
    # 의과 같이２ 차원 배열이 되도록 해 주십시오．
    # [13,32]과 같이 １개의 ID에 여러의 키를 설정할 수 있습니다．
    #
    set = [37,38,39,40,13,32,27,8,46,16,17,18,9,20,48,49,50,51,52,53,54,55,56,57, 
    65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90, 
    96,97,98,99,100,101,102,103,104,105,188,190,191,226,187,186,221,192,219,189, 
    222,220,145,113,114,115,116,117,118,119,120,121,122,19,33,34,35,36,45,91,92,93, 
    110,111,106,107,109,144,21]
    # ２ 차원에 변환 
    val = []
    for i in set
      val.push([i])
    end
    # set 가 아니고 val 에(로) 설정하십시오．set 은  1회용．
    #----------------------------------------------------------------
    Key.setup
    Key.add_key_set(val)
    Key.update
  end
end

#==============================================================================
# ■ Interpreter (이벤트＞스크립트용 방법)
#==============================================================================

class Interpreter
  def get_press(variable,id)
    $game_variables[variable]= Key.press?(id) == true ? 1 : 0
  end
  
  def get_trigger(variable,id)
    $game_variables[variable]= Key.trigger?(id) == true ? 1 : 0
  end
  
  def get_repeat(variable,id)
    $game_variables[variable]= Key.repeat?(id) == true ? 1 : 0
  end
  
  def get_press_all(variable)
    for i in 0...Key.max
      $game_variables[variable+i]= Key.press?(i) == true ? 1 : 0
    end
  end
  
  def get_trigger_all(variable)
    for i in 0...Key.max
      $game_variables[variable+i]= Key.trigger?(i) == true ? 1 : 0
    end
  end
  
  def get_repeat_all(variable)
    for i in 0...Key.max
      $game_variables[variable+i]= Key.repeat?(i) == true ? 1 : 0
    end
  end
end
