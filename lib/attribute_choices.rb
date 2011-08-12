require 'active_record'

module AttributeChoices
  def self.included(base) #:nodoc:
    base.extend(AttributeChoicesMacro)
  end

  module AttributeChoicesMacro

    # Associate a list of display values for an attribute with a list of discreet values
    #
    # The arguments are:
    #
    # * +attribute+ - The attribute whose values you want to map to display values
    # * +choices+ - Either an +Array+ of tupples where the first value of the tupple is the attribute \
    #               value and the second one is the display value mapping, or a +Hash+ where the key is the \
    #               attribute value and the value is the display value mapping.
    # * <tt>options</tt> - An optional hash of options:
    #   * <tt>:localize</tt> - If set to +true+, then <tt>I18n.trasnlate</tt> is used to translate the value \
    #                          returned by the +_display+ instance methods as well as translate the display \
    #                          values returned by the +_choices+ class method
    #   * <tt>:validate</tt> - If set to +true+, +validates_inclusion_of+ is used to ensure that the attribute \
    #                          only accepts the values passed in with the +choices+
    #   * <tt>:i18n</tt> - If set to +true+, then <tt>I18n</tt> used to load choices from translations. In that \
    #                      case no +choices+ needs to be specified
    #                      
    #
    # For example:
    #   class User < ActiveRecord::Base
    #     attribute_choices :gender,  { 'm' => "Male", 'f' => 'Female'}
    #     attribute_choices :age_group,  [
    #       ['18-24', '18 to 24 years old], 
    #       ['25-45', '25 to 45 years old']
    #     ], :localize => true, :validate => false
    #   end
    #
    # With I18n:
    #   class User < ActiveRecord::Base
    #     attribute_choices :gender, :i18n => true, :validate => true
    #   end
    #
    # The macro adds an instance method named after the attribute, suffixed with <tt>_display</tt>
    # (e.g. <tt>gender_display</tt> for <tt>:gender</tt>) that returns the display value of the
    # attribute for a given value, or <tt>nil</tt> if a mapping for a value is missing.
    # 
    # It also adds a class method named after the attribute, suffixed with <tt>_choices</tt>
    # (e.g. <tt>User.gender_choices</tt> for <tt>:gender</tt>) that returns an array of choices and values
    # in a fomrat that is suitable for passing directly to the Rails <tt>select_*</tt> helpers.
    #
    # NOTE: You can use a Hash for the +choices+ argument which is converted to an Array. The order of the \
    # tupples of the resulting Array is only guaranteed to be preserved if you are using Ruby 1.9
    def attribute_choices(attribute, *args)

      assert_valid_attribute(attribute.to_s)

      attribute = attribute.to_sym

      options   = args.extract_options!
      test_opts = options.reverse_merge(:validate => false, :localize => false, :i18n => false)

      options = begin
        test_opts.assert_valid_keys(:validate, :localize, :i18n)
      rescue
        args.push(options) # back to args
        Hash[:localize, false, :validate, false, :i18n, false]
      else
        options.reverse_merge(:validate => false, :localize => false, :i18n => false)
      end
      
      choices = if args.size.zero?
        if options[:i18n] == true
          nspace = unless self.name.to_s.index('::').nil?
            "activerecord.humanized_attribute_values.#{self.name.to_s.underscore.gsub(/\//, '.')}.#{attribute.to_s}"
          else
            "activerecord.humanized_attribute_values.#{self.name.downcase}.#{attribute.to_s}"
          end
          probe = I18n.translate(nspace).to_a
          if probe.first.is_a?(String)
            raise ArgumentError, "Cannot find choices for attribute #{attribute} in translations, namespace #{nspace}"
          else
            probe.collect{|p| [p.first.to_s, p.last]}
          end
        end
      else
        if args.first.is_a?(Hash) || args.first.is_a?(Array)
          args.first
        else
          raise ArgumentError, "Choices must be either an Array or Hash"
        end
      end
      
      attribute_choices_options[attribute] = options

      choices = if options[:localize]
        choices.to_a.collect {|t| [t.first, I18n.translate(t.last)]}
      else
        choices.to_a
      end

      define_method("#{attribute.to_s}_display") do
        # The local variable `choices` is saved inside this Proc
        tupple = choices.assoc(send(attribute))
        tupple && tupple.last
      end

      (class << self; self; end).send(:define_method, "#{attribute.to_s}_choices") do
        choices.collect(&:reverse)
      end

      if options[:validate]
        validates_inclusion_of attribute.to_sym, :in => choices.collect {|i| i.first}
      end

    end
    
    def attribute_choices_options
      @attribute_choices_options ||= {}
    end

    private
    def assert_valid_attribute(attr_name)
      unless column_names.include?(attr_name.to_s) || (instance_methods.include?(attr_name) && instance_methods.include?("#{attr_name}="))
        raise ArgumentError, "Model attribute '#{attr_name.to_s}' doesn't exist" 
      end
    end
  end
end

ActiveRecord::Base.send(:include, AttributeChoices) 