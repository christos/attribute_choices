# Lazy loading version.  Use for behaviour that applies
# only to specified models.
module FortyTwo
  module AttributesWithChoices
    # Lazy loading.
    def self.included(base)
      base.extend ActMethods
    end
    module ActMethods
      # We only pull in the class and instance methods
      # if acts_as_fooey is called. This is lazy,
      # or on-demand, initialisation.
      def attributes_with_choices(attributes)
        # We only need to define the class and
        # instance methods once on a class.
        # If, for example, a class has multiple
        # acts_as_fooey declarations, we only want to
        # define the class and instance methods
        # the first time.
        
        attributes.each do |attribute, choices|
          define_method("#{attribute.to_s}") do |*opts|
            format = opts.first
            choices =  self.class.const_get(:"#{attribute.to_s.upcase}_CHOICES")
            return read_attribute(attribute) if format.blank? || choices.blank?
            choices[read_attribute(attribute)] if format == :display
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
end