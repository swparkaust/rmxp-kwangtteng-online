class Jindow_Skill < Jindow
  def initialize
    $game_system.se_play($data_system.decision_se)
    super(0, 0, 120, 150)
    self.name = "스킬"
    @head = true
    @mark = true
    @drag = true
    @close = true
    self.refresh "Skill"
    self.x = $jindow_temp.skill.x
    self.y = $jindow_temp.skill.y
    @data = []
    for i in 0...$game_party.actors[0].skills.size
      skill = $data_skills[$game_party.actors[0].skills[i]]
      if skill != nil
        @data.push(skill)
      end
    end
    @buttons = {}
    i = 0
    for data in @data
      @buttons[data.id] = J::Button.new(self).refresh(120,
           "(SP -" + data.sp_cost.to_s + "). " + data.name)
      @buttons[data.id].y = i * 30 + 12
      i += 1
    end
    @a = J::Button.new(self).refresh(60, "취소")
    @a.x = self.width - 60
    @a.y = @buttons.size * 30 + 14
  end
  
  def update
    self.x != $jindow_temp.skill.x ? ($jindow_temp.skill.x = self.x) : 0
    self.y != $jindow_temp.skill.y ? ($jindow_temp.skill.y = self.y) : 0
    super
    if @a.click  # 취소
      $game_system.se_play($data_system.decision_se)
      Hwnd.dispose(self)
    end
  end
end
