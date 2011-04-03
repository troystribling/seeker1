require 'rubygems'
require 'zgomot'

#.........................................................................................................
before_start do
  Zgomot.logger.level = Logger::DEBUG
end

#.........................................................................................................
lead_i1 = np([:C,5], :aeolian, :l=>4, :v=>0.99)[6,3]
lead_i2 = np([:C,5], :ionian, :l=>4, :v=>0.99)[6,3]
lead_intro = [lead_i1, n(:R), lead_i2, n(:R)]

#.........................................................................................................
start = 1
lead_p1 = np([:C,5], :aeolian, :l=>8, :v=>0.99)[7,4,6,3]
lead_p2 = np([:C,5], :phrygian, :l=>8, :v=>0.99)[7,4,6,5]
lead_p3 = [np([:C,5], :phrygian, :l=>8, :v=>0.99)[7,4,6], np([:C,5], :phrygian, :l=>16, :v=>0.99)[5,6]]
lead_p4 = [np([:C,5], :dorian, :l=>8, :v=>0.99)[5,3,1], n(:R, :l=>8)]
lead_phrases = [lead_p1, lead_p2, lead_p1, lead_p2, lead_p1, lead_p3, lead_p1, lead_p2, lead_p1, lead_p4]

#.........................................................................................................
str 'lead' do
  if count > start
    c = (count - start - 1) % lead_phrases.length
    ch(0) << lead_phrases[c]
  else
    ch(0) << lead_intro
  end
end

#.........................................................................................................
play
