require 'test_helper'


class AttributeChoicesTest < ActiveSupport::TestCase

  class Profile < ActiveRecord::Base
    attribute_choices :gender, {'m' => 'Man', 'f' => 'Woman'}
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
  
  test "An child AR object should not share the parent's chocies" do
    assert_not_equal ChildProfile.gender_choices, Profile.gender_choices
  end
  
  test "It should return nil as the display value for an attribute that isn't mapped" do
    @profile = ChildProfile.new(:salutation => 'master')
    assert_nil @profile.salutation_display
  end
end
