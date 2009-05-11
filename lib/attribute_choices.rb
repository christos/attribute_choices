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
      
      write_inheritable_hash :attribute_choices_storage, {}
      class_inheritable_reader :attribute_choices_storage
      attribute_choices_storage[attribute.to_sym] = choices
      
      if choices.is_a?(Array)
        define_method("#{attribute.to_s}_display") do
          tupple = attribute_choices_storage[attribute].detect {|i| i.first == read_attribute(attribute) }
          tupple && tupple.last
        end
      elsif choices.is_a?(Hash)
        define_method("#{attribute.to_s}_display") do
          attribute_choices_storage[attribute][read_attribute(attribute)]
        end
      end
      
      self.class.instance_eval do
        define_method("#{attribute.to_s}_choices") do
          attribute_choices_storage[attribute].collect(&:reverse)
        end
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
