local R = function (self, x, y, glyph)

  self.y = y
  self.x = x
  
  self.glyph = glyph
  self.passive = glyph == string.lower(glyph) and true 
  self.name = 'random'
  self.info = 'Outputs a random value.'

  self.ports = {
    {-1, 0, 'in-a', 'haste'}, 
    { 1, 0, 'in-b', 'input'}, 
    {0, 1, 'r-output', 'output'}
  }
  
    local a = self:listen(self.x - 1, self.y) or 0
    local b = self:listen(self.x + 1, self.y) or 35
    local l = self:glyph_at(self.x + 1, self.y)
    local cap = l ~= '.' and l == self.up(l) and true
    if b < a then a,b = b,a end
    local val = self.chars[math.random(a, b)]
    local value = cap and self.up(val) or val

  if not self.passive then
    self:spawn(self.ports)
    self:write(self.ports[3][1], self.ports[3][2], value)
  else
    if self:banged() then
      self:spawn({{0, 1, self.glyph, 'output'}})
      self:write(self.ports[3][1], self.ports[3][2], value)
    end
  end
  
end

return R