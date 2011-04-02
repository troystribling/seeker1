require 'rubygems'
require 'zgomot'

#.........................................................................................................
before_start do
  Zgomot.logger.level = Logger::DEBUG
end

#.........................................................................................................
p1 = np([:C,5], :aeolian, :l=>8, :v=>0.99)[7,4,6,3]
p2 = np([:C,5], :dorian, :l=>8, :v=>0.99)[5,3,1]

#.........................................................................................................
str 'prog', p1 do |pattern|
  p = (count % 4)
  ch(0) << if p < 3
             p1        
           else
             p2
           end
end

#.........................................................................................................
play
