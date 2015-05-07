#==============================================================================
# ■ Comment_Include
#==============================================================================

#--------------------------------------------------------------------------
# ● 주석의 취득
#--------------------------------------------------------------------------
def comment_include(*args)
  list = *args[0].list
  trigger = *args[1]
  split = *args[2]
  return nil if list == nil
  return nil unless list.is_a?(Array)
  for item in list
    next if item.code != 108
    if split
      par = item.parameters[0].split(' | ')
      return item.parameters[0] if par[0] == trigger
    else
      return item.parameters[0] if item.parameters[0] == trigger
    end
  end
  return nil
end
