local rnote = function(self, x, y)
  self.y = y
  self.x = x
  self.name = "r.note"
  self.ports = { {-1, 0, "in-rate"}, {1, 0, "in-scale"}, {0, 1, "^-out"}, {2, 0, "in-note"} }

  local mode = self:listen(self.x - 1, self.y)
  local scale = self:listen(self.x + 1, self.y) or 1 scale = scale == 0 and 1 or scale
  local note = self:glyph_at(self.x + 2, self.y) or "C"

  local transposed = self:transpose(note, 0)
  local get_scale = self:get_scale(scale, transposed[1] + 1)
  local scale_name = get_scale[1]
  local note_array = get_scale[2]
  local out
  local test

  if mode then
    if mode == 0 then
      --out = self.notes[note_array[math.random(#note_array - 1)]] --OLD FUNCTION
      test = note_array[math.random(#note_array - 1)+1] --modulo around the scale that is selected
      out = self.notes[((test-1) % 12)+1] --modulo through the array of notes
    else
      --out = self.notes[note_array[math.floor(mode) % (#note_array - 1)]] -- OLD FUNCTION
      test = note_array[((mode-1) % (#note_array-1)+1)] --modulo around the scale that is selected
      out = self.notes[((test-1) % 12)+1] --modulo through the array of notes
      --print(test)
    end
  else
    --out = self.notes[note_array[math.random(#note_array - 1)]] --OLD FUNCTION
      test = note_array[math.random(#note_array - 1)+1] --modulo around the scale that is selected
      out = self.notes[((test-1) % 12)+1] --modulo through the array of notes
  end

  self.ports[2][3] = scale_name
  self:spawn(self.ports)

  if not mode and self:neighbor(self.x, self.y, "*") then
    self:write(self.ports[3][1], self.ports[3][2], out)
  elseif mode then
    self:write(self.ports[3][1], self.ports[3][2], out)
  end
end

return rnote
