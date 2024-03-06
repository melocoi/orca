local I = function(self, x, y)
  self.y = y
  self.x = x
  self.name = "increment"
  self.ports = { {-1, 0 , "in-step" }, {1, 0, "in-mod" }, {0, 1, "i-out"} }
  self:spawn(self.ports)

  --updated function to match Orca desktop
  
  local step = self:listen(self.x - 1, self.y) or 1
  local with = self:listen(self.x + 1, self.y) or 9
  local val = self:listen(self.x, self.y + 1) or 0
  
  if with <= 0 then
    with = 35
  end
  
  local value = self.chars[(((val+ step)-1) % (with))+1]

  self:write(0, 1, value)
end

return I
