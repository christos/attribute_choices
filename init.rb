# Include hook code here
require 'attributes_with_choices'
ActiveRecord::Base.send(:include, FortyTwo::AttributesWithChoices) 
