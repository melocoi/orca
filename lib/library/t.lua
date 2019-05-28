local T = function (self, x, y, glyph)

  self.y = y
  self.x = x
  
  self.glyph = glyph
  self.passive = glyph == string.lower(glyph) and true 
  self.name = 'track'
  self.info = 'Reads an eastward operator with offset'
  
  self.ports = { 
    {-1, 0, 'in-length', 'haste'}, {-2, 0, 'in-position', 'haste'}, 
    {1, 0, 'in-value', 'input'}, 
    {0, 1, 't-output', 'output'}
  }

  local length = self:listen(self.x - 1, self.y, 1) or 1
  length = util.clamp(length, 1, self.XSIZE - self.bounds_x)
  local pos = util.clamp(self:listen(self.x - 2, self.y, 0) or 1, 1, length)  
  local val = self.data.cell[self.y][self.x + util.clamp(pos, 1, length)]
  self.data.cell.params[self.y][self.x].seq = length

  if not self.passive then
    self:spawn(self.ports)
    for i = 1, #self.chars do
      if i <= length then
        self.lock( self.x + i, self.y, false,  pos == i and true, true )
      else
        if not self.locked((self.x + i) + 1, self.y) and self:active((self.x + i) + 1, self.y) then 
          break
        else
          self.unlock(self.x + i, self.y, false, false, false)
        end
      end
    end
    self.data.cell[self.y + 1][self.x] = val or '.'
  end
  
end

return T