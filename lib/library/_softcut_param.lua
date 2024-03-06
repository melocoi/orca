local param_ids = {
  "source",--1
  "pre_level",--2
  "pan",--3
  "pan_slew_time",--4
  "rate_slew_time",--5
  "level_slew_time",--6
  "post_filter_fc",--7
  "post_filter_rq",--8
  "post_filter_lp", --9
  "post_filter_hp", --10
  "post_filter_bp", --11
  "post_filter_dry",--12
}
local param_names = {
  "source",
  "S.O.S.",
  "pan",
  "pan slew",
  "rate slew",
  "level slew",
  "filtCutOff",
  "filter Q",
  "Low Pass Filt",
  "Hi Pass Filt",
  "Band Pass Filt",
   "filter DRY",
}

local softcut_param = function(self, x, y)
  self.y = y
  self.x = x
  self.name = "sc.param"

  local playhead = util.clamp(self:listen(self.x + 1, self.y) or 1, 1, self.sc_ops.max)
  local param = util.clamp(self:listen( self.x + 2, self.y) or 1, 1, #param_ids)
  local val = self:listen(self.x + 3, self.y) or 0
  val = (param == 1 and (val % 4)) or val
  local value = val or 0
  local source = (val == 1 and "in ext" or val == 2 and "in engine" or val == 3 and "both" or val == 0 and "off") or "off"
  local helper = param_names[param] .. " " .. (param == 1 and source or value)
 
  --Filter Frequency Range
  local mF = 40
  local MF = 2000
  -------------------------
  self.ports = { {1, 0, "in-playhead", "input"}, {2, 0, helper or "in-param", "input"}, {3, 0, helper or "in-value", "input"} }

  self:spawn(self.ports)

  if self:neighbor(self.x, self.y, "*") then
    if param == 1 then
      if val == 0 then
        audio.level_adc_cut(0)
        audio.level_eng_cut(0)
      elseif val == 1 then
        audio.level_adc_cut(1)
        audio.level_eng_cut(0)
      elseif val == 2 then
        audio.level_adc_cut(0)
        audio.level_eng_cut(1)
      elseif val == 3 then
        audio.level_adc_cut(1)
        audio.level_eng_cut(1)
      end
      
    elseif param == 2 then --pre Level/ Sound on Sound recording  
      softcut[param_ids[param]](playhead, value / 35)
      
    elseif param == 3 then -- Pan
      softcut[param_ids[param]](playhead, value/35*2-1)
      
    elseif param == 4 then -- Pan slew time
      softcut[param_ids[param]](playhead, value/35*2)
    
    elseif param == 5 then -- rate slew time
      softcut[param_ids[param]](playhead, value/35*2)  
      
    elseif param == 6 then -- level slew time
      softcut[param_ids[param]](playhead, value/35*2)    
      
    elseif param == 7 then -- filter cutoff
      value = util.round(util.linlin(1, 35, mF, MF, val), 1)
      softcut[param_ids[param]](playhead, value)
    
    elseif param == 8 then --filter Q  
      softcut[param_ids[param]](playhead, value/35*2)
    
    elseif param == 9 then -- filter LowPass gain  
      softcut[param_ids[param]](playhead, value / 35) 
      
    elseif param == 10 then -- filter HiPass gain  
      softcut[param_ids[param]](playhead, value / 35) 
    
    elseif param == 11 then -- filter BandPass gain  
      softcut[param_ids[param]](playhead, value / 35)   
      
    elseif param == 12 then -- filter dry gain
      softcut[param_ids[param]](playhead, value / 35)  
      
      
    
   
    
    
    else
      softcut[param_ids[param]](playhead, value)
      
      
    
    end
    --print(param)
    --print(value)  
  end
end

return softcut_param
