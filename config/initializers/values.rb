states = [
  "Baden-Württemberg"     ,
  "Bayern"                ,
  "Berlin "               ,
  "Brandenburg"           ,
  "Bremen "               ,
  "Hamburg "              ,
  "Hessen"                ,
  "Mecklenburg-Vorpommern",
  "Niedersachsen"         ,
  "Nordrhein-Westfalen"   ,
  "Rheinland-Pfalz"       ,
  "Saarland"              ,
  "Sachsen"               ,
  "Sachsen-Anhalt"        ,
  "Schleswig-Holstein"    ,
  "Thüringen"             
]

GERMAN_STATES = states.map {|s| [s, states.index(s)+1]}
german_states_hash = {}
GERMAN_STATES.each {|s| german_states_hash.merge!(s[1] => s[0])}

GERMAN_STATES_HASH = german_states_hash