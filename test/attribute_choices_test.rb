require 'test_helper'
require 'ruby-debug'

class AttributeChoicesTest < ActiveSupport::TestCase

  class Person < ActiveRecord::Base
    attribute_choices :gender, {'m' => 'Male', 'f' => 'Female'}
  end

  class Adult < Person
    attribute_choices :gender , {'m' => 'Man', 'f' => 'Woman', 'o' => 'Other'}
    attribute_choices :salutation, [
      ["mr", 'Mister'],
      ["mrs", 'Misses'],
      ["ms", 'Miss'],
    ]
  end

  test "It should add a class method to all ActiveRecord objects" do
    assert_respond_to(Person, :attribute_choices)
  end

  test "It should add a class and an instance method for each attribute" do
    assert_respond_to(Person, :gender_choices)
    assert_respond_to(Person.new, :gender_display)
    
    assert_raise(NoMethodError) do
       Object.gender_choices
    end
    
  end
  
  test "A child AR object should not share the parent's choices" do
    assert_not_equal Adult.gender_choices, Person.gender_choices
  end

  test "Does not allow specifying non-existent attributes" do
    assert_raise ArgumentError do
      class Person < ActiveRecord::Base
        attribute_choices :non_existent_attribute, []
      end
    end
  end

  test "Does not allow invalid option keys" do
    assert_raise ArgumentError do
      class Person < ActiveRecord::Base
        attribute_choices :gender, {'m' => 'Male', 'f' => 'Female'}, :not_a_real_option => true
      end
    end
  end

  test "given a valid value for an attribute the correct display value is returned " do
    @person = Person.new(:gender => 'm', :salutation => 'mr')
    assert @person.valid?

    assert_equal 'Male', @person.gender_display
  end

  test "a localized version of the display value is returned when :localize => true" do
    class Human < Person
      attribute_choices :gender, [['m', 'Male'], ['f', 'Female']], :localize => true
    end
    @human = Human.new(:gender => 'm', :salutation => 'mr')

    assert_equal I18n.translate('Male'), @human.gender_display
  end

  test "a localized version of the attribute choices is returned when :localize => true" do
    class Human < Person
      attribute_choices :gender, [['m', 'Male'], ['f', 'Female']], :localize => true
    end
    @human = Human.new(:gender => 'm', :salutation => 'mr')

    assert_equal [[I18n.translate('Male'), 'm'], [I18n.translate('Female'), 'f']], Human.gender_choices
  end

  test "nil is returned as the display value of an attribute without a value to display mapping" do
    @adult = Adult.new(:salutation => 'master')
    assert_nil @adult.salutation_display

    @adult.gender = 'unknown'
    assert_nil @adult.gender_display

  end

  test "Multiple calls to attribute_choices update the attribute choices" do
    class Medic < Adult; end
    assert_equal [['Mister', 'mr'], ['Misses', 'mrs'], ["Miss", 'ms']], Medic.salutation_choices

    class Medic < Adult
      attribute_choices :salutation, [ ["dr", 'Doctor'] ]
    end

    assert_equal [ ['Doctor', 'dr'] ], Medic.salutation_choices
  end

  test "It should store an options Hash if passed as the the optional third parameter" do
    class Person < ActiveRecord::Base
      attribute_choices :gender, {'m' => 'Male', 'f' => 'Female'}, :localize => true, :validate => false
    end
    assert_equal Hash[:localize, true, :validate, false], Person.attribute_choices_options[:gender]
  end

  test "Default values are assigned for any options that are not specified" do
    class Person < ActiveRecord::Base
      attribute_choices :gender, {'m' => 'Male', 'f' => 'Female'}, :localize => true
    end

    assert_equal Hash[:localize, true, :validate, false], Person.attribute_choices_options[:gender]
  end

  test "Doesn't validate inclusion of attribute value in choices values by default" do
    @person = Person.new(:gender => 'trans', :salutation => 'mr')
    assert @person.valid?
  end

  test "Validates inclusion of attribute value in choices values when :localize => true" do
    class Person < ActiveRecord::Base
      attribute_choices :gender, {'m' => 'Male', 'f' => 'Female'}, :validate => true
    end

    @person = Person.new(:gender => 'm', :salutation => 'mr')
    assert @person.valid?

    @person.gender = 'trans'
    assert !@person.valid?
  end

end
