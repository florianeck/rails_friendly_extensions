# -*- encoding : utf-8 -*-
require "yaml"
class ActiveRecordArray

  # Das ActiveRecordArray:
  # 
  #   Folgender Hintergrund: UserMethodCache versucht ständig lauter Datenbankobjekte in die DB zu schreiben, was immer wieder zu Fehlern führt.
  # 
  #   Idee: Wieso die ganzen Objekte in die DB speichern, wir müssen doch bloß wissen welche Art von Object und welche ID's wir brauchen.
  # 
  #   Problem: Wie und wann wird der ganze Kram konvertiert?
  # 
  #   Lösung: ActiveRecordArray!
  # 
  #   Beispiel: 
  # 
  #   1. users = User.find_all_by_parent_id(3)
  # 
  #   2. users.is_active_record_array?
  #     true, weil Array mit ActiveRecord Objekten vom Typ 'User'. Nebenbei funktioniert .is_active_record_array? mit ALLEN objekten in ruby, was undefined_methods vorbeugt.
  # 
  #   3. users sieht jetzt so aus (bsp.) [<#User id:1, parent_id:3 ... >, <#User id:2, parent_id:3 ... >, <#User id:4, parent_id:3 ... >, <#User id:5, parent_id:3 ... >]
  #     Das kann in der Datenbank schon mal echt belastend werden, grad bei umsatz.
  # 
  #   4. users = users.parse_active_record_array  
  #     Das users-Array in ein ActiveRecordArray verwandeln... das sieht dann so aus:
  # 
  #   #<ActiveRecordArray:0x6f61444 @entries=[1, 2, 4, 5], @record_class="Object::User>
  # 
  #   5. users.to_yaml 
  #     "--- !FRIENDS,2011/active_record_array Object::User//1-2-4-5\n"
  #     Das ist das was in die Datenbank gespeichert wird.
  # 
  #   6. users.parse_record_data
  #     Aus users wird wieder [<#User id:1, parent_id:3 ... >, <#User id:2, parent_id:3 ... >, <#User id:4, parent_id:3 ... >, <#User id:5, parent_id:3 ... >]

  attr_accessor :record_class, :entries

  # Klasse kann auch leer initialisiert werden. Wird zum YAML.load gebraucht
  def initialize(model_base = nil, entries = nil)
    @record_class = [model_base.parents.reverse, model_base.name].flatten.join("::") rescue nil
    @entries      = entries.map {|e| e.id} rescue nil
  end

  # Stellt wieder ein Array mit AR-Objekten her
  # self.record_class ist das Model
  # self.entries sind die ID's
  # => Model.find([1,2,3...])
  def parse_record_data
    self.record_class.constantize.find(self.entries)
  end    

  #== YAML support
  # Domain Type anlegen
  YAML::add_domain_type("FRIENDS,2011", "active_record_array") do |type, val|
    ActiveRecordArray.from_string_representation(val)
  end

  # type deklarieren
  def to_yaml_type
    "!FRIENDS,2011/active_record_array"
  end

  def to_yaml(opts = {})
    YAML.quick_emit( nil, opts ) { |out|
      out.scalar( taguri, to_string_representation, :plain )
    }
  end
  
  # Workaround um alle daten ins yaml reinzukriegen...
  def to_string_representation
    "#{@record_class}//#{@entries.join('-')}"
  end

  # ... und alle daten wieder aus dem String rauszuholen.
  def self.from_string_representation(str)
    data = str.split("//")
    arr = self.new
    arr.record_class  = data.first
    arr.entries       = data.last.split("-").map {|id| id.to_i}
    return arr
  end


end  
