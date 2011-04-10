require 'rubygems'
require 'zgomot'

#.........................................................................................................
before_start do
  Zgomot.logger.level = Logger::DEBUG
end

#.........................................................................................................
# lead
#.........................................................................................................
lead_p1 = [np([:C,5], :aeolian, :l=>8, :v=>0.99)[3,1,4,2,5,3,6,4], n(:R, :l=>8)]
lead_p2 = [np([:C,5], :mixolydian, :l=>8, :v=>0.99)[4,6,2], n(:R, :l=>8)]
lead_p3 = [np([:D,5], :aeolian, :l=>16, :v=>0.99)[4,5,6], n(:R, :l=>16), np([:D,5], :aeolian, :l=>16, :v=>0.99)[6], n(:R, :l=>16)]
lead_p4 = [np([:D,5], :mixolydian, :l=>16, :v=>0.99)[5,4,2], n(:R, :l=>16), np([:D,5], :mixolydian, :l=>16, :v=>0.99)[2], n(:R, :l=>16)]
lead_p5 = [np([:C,5], :mixolydian, :l=>16, :v=>0.99)[6,5,3], n(:R, :l=>16), np([:D,5], :mixolydian, :l=>16, :v=>0.99)[3], n(:R, :l=>16), n(:R, :l=>2)]
lead_p6 = [np([:D,5], :aeolian, :l=>8, :v=>0.99)[6,4,5,3,4,2,3,1], n(:R, :l=>8)]
lead = [lead_p1, lead_p2, lead_p3, lead_p2, lead_p4, lead_p2, lead_p3, lead_p2, lead_p5, lead_p6]

#.........................................................................................................
str 'lead' do
  c = (count - 1) % lead.length
  ch(0) << lead[c]
end

#.........................................................................................................
# rhythm
#.........................................................................................................
start = 1
rhythm_p1 = [n(:R, :l=>1), n(:R, :l=>8)]
rhythm_p2 = [n(:R, :l=>4), np([:D,5], :mixolydian, :l=>8, :v=>0.99)[4,2]]
rhythm_p3 = [n(:R, :l=>8), np([:D,5], :aeolian, :l=>8, :v=>0.99)[3,5]]
rhythm_p4 = [n(:R, :l=>8), np([:D,5], :aeolian, :l=>16, :v=>0.99)[4,2,3,1], n(:R, :l=>8)]
rhythm_phrases =[rhythm_p1, rhythm_p2, rhythm_p3, rhythm_p2, rhythm_p3, rhythm_p2, rhythm_p3, rhythm_p2, rhythm_p3, rhythm_p4, rhythm_p1]

#.........................................................................................................
str 'rhythm' do
  c = (count - 1) % rhythm_phrases.length
  ch(1) << rhythm_phrases
end

#.........................................................................................................
# atmos
#.........................................................................................................
start = 1
atmos_p1 = [n(:R, :l=>1), n(:R, :l=>8)]
atmos_p2 = [np([:C,5], :mixolydian, :l=>4)[1], n(:R)]
atmos_p3 = [np([:C,5], :mixolydian, :l=>4)[2], n(:R, :l=>8)]
atmos_p4 = [np([:C,5], :mixolydian, :l=>4)[1], n(:R)]
atmos_p5 = [np([:C,5], :mixolydian, :l=>4)[4], n(:R), np([:C,5], :mixolydian, :l=>4)[2], n(:R), n(:R, :l=>8)]
atmos_phrases = [atmos_p1, atmos_p2, atmos_p3, atmos_p2, atmos_p3, atmos_p2, atmos_p3, atmos_p2, atmos_p3, atmos_p4, atmos_p5]
#.........................................................................................................
str 'atmos' do
  c = (count - 1) % atmos_phrases.length
  ch(2) << atmos_phrases
end

play