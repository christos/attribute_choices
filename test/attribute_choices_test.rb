require 'test_helper'


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

  test "A child AR object should not share the parent's choices" do
    assert_not_equal Adult.gender_choices, Person.gender_choices
  end

  test "nil is returned as the display value of an attribute without a value to display mapping" do
    @profile = Adult.new(:salutation => 'master')
    assert_nil @profile.salutation_display
  end

  test "Multiple calls to attribute_choices update the attribute choices" do      
    class Medic < Adult; end
    assert_equal Medic.salutation_choices, [['Mister', 'mr'], ['Misses', 'mrs'], ["Miss", 'ms']]

    class Medic < Adult
      attribute_choices :salutation, [ ["dr", 'Doctor'] ]
    end

    assert_equal Medic.salutation_choices, [ ['Doctor', 'dr'] ]
  end

  test "It should store an options Hash if passed as the the optional third parameter" do
    class Person < ActiveRecord::Base
      attribute_choices :gender, {'m' => 'Male', 'f' => 'Female'}, :localized => true, :validate => false
    end
    assert_equal Person.attribute_choices_options[:gender], {:localized => true, :validate => false}
  end

  test "Default values are assigned for any options that are not specified" do
    class Person < ActiveRecord::Base
      attribute_choices :gender, {'m' => 'Male', 'f' => 'Female'}, :localized => true
    end

    assert_equal Person.attribute_choices_options[:gender], {:localized => true, :validate => false}
  end

end
