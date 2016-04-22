# -*- encoding : utf-8 -*-
class FriendsLabel < ActiveRecord::Base

  validates_uniqueness_of :attribute_name

  labels = {}

  if self.table_exists?
    concept_labels = FriendsLabel.all
    concept_labels.each {|l| labels.merge!(l.attribute_name => {:label => l.label, :tooltip => l.tooltip, :docu_tooltip => l.tooltip_docu})}
  end

  LABELS = labels

  def is_unset?
    return (!(self.attribute_name == self.label)).to_s
  end

end
