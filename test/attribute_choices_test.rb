require 'test_helper'


class AttributeChoicesTest < ActiveSupport::TestCase

  class Profile < ActiveRecord::Base
    attribute_choices :gender, {'m' => 'Man', 'f' => 'Woman'}
    attribute_choices :salutation, [["mr", 'Mister'], ["mrs", 'Misses']]
  end

  class ChildProfile < Profile
    attribute_choices :gender , {'m' => 'Man', 'f' => 'Woman', 'o' => 'Other'}
    attribute_choices :salutation, [
      ["mr", 'Mister'],
      ["mrs", 'Misses'],
      ["ms", 'Miss'],
    ]
  end


  test "It should add a class method to all ActiveRecord objects" do
    assert_respond_to(Profile, :attribute_choices)
  end

  test "An child AR object should not share the parent's choices" do
    assert_not_equal ChildProfile.gender_choices, Profile.gender_choices
  end

  test "nil is returned as the display value of an attribute without a value to display mapping" do
    @profile = ChildProfile.new(:salutation => 'master')
    assert_nil @profile.salutation_display
  end

  test "Multiple calls to attribute_choices update the attribute choices" do    
    assert_equal Profile.salutation_choices, [['Mister', 'mr'], ['Misses', 'mrs']]

    class Profile < ActiveRecord::Base
      attribute_choices :gender, [["mr", 'Señor'], ["mrs", 'Señora']]
    end
    assert_equal Profile.gender_choices, [['Señor', 'mr'], ['Señora', 'mrs']]
  end
  
  test "It should store an options Hash if passed as the the optional third parameter" do
      class Profile < ActiveRecord::Base
        attribute_choices :gender, [["mr", 'Señor'], ["mrs", 'Señora']], :localized => true, :validate => false
        attribute_choices :hair, [["b", 'Blonde'], ["r", 'Red']], :localized => true, :validate => true
      end
      assert_equal Profile.attribute_choices_options[:gender], {:localized => true, :validate => false}
      assert_equal Profile.attribute_choices_options[:hair], {:localized => true, :validate => true}
  end
  
  test "Default values are assigned for any options that are not specified" do
      class Profile < ActiveRecord::Base
        attribute_choices :gender, [["mr", 'Señor'], ["mrs", 'Señora']], :localized => true
        attribute_choices :hair, [["b", 'Blonde'], ["r", 'Red']]
      end
      
      assert_equal Profile.attribute_choices_options[:gender], {:localized => true, :validate => false}
      assert_equal Profile.attribute_choices_options[:hair],   {:localized => false, :validate => false}
  end
end
