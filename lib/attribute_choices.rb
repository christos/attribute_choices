# Lazy loading version.  Use for behaviour that applies
# only to specified models.
module AttributeChoices
  # Lazy loading.
  def self.included(base)
    base.extend ActMethods
  end
  module ActMethods
    # We only pull in the class and instance methods
    # if acts_as_fooey is called. This is lazy,
    # or on-demand, initialisation.
    def attribute_choices(attribute, choices)
      # We only need to define the class and
      # instance methods once on a class.
      # If, for example, a class has multiple
      # acts_as_fooey declarations, we only want to
      # define the class and instance methods
      # the first time.
      
      if choices.is_a?(Array)
        define_method("#{attribute.to_s}_display") do
          choices.detect {|i| i.first == read_attribute(attribute) }.last
        end
      elsif choices.is_a?(Hash)
        define_method("#{attribute.to_s}_display") do
          choices[read_attribute(attribute)]
        end
      end

      define_method("#{attribute.to_s}_choices") do
        choices
      end

      unless included_modules.include? InstanceMethods
        extend ClassMethods
        include InstanceMethods
      end
    end
  end
  module ClassMethods
  end
  module InstanceMethods
  end
end
