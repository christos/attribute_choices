require 'test_helper'


class AttributeChoicesTest < ActiveSupport::TestCase

  class Profile < ActiveRecord::Base
    GENDER_CHOICES = {'m' => 'Man', 'f' => 'Woman'}
    attribute_choices :gender, GENDER_CHOICES
  end
  
  class ChildProfile < Profile
    GENDER_CHOICES = {'m' => 'Man', 'f' => 'Woman', 'o' => 'Other'}
    attribute_choices :gender , GENDER_CHOICES
  end
    
    
  test "It should add a class method to all ActiveRecord objects" do
    assert_respond_to(Profile, :attribute_choices)
  end
  
  test "An child AR object should not share the parent's chocies" do
    @parent = Profile.new(:gender => 'm')
    @parent2 = Profile.new(:gender => 'f')
    @child = ChildProfile.new(:gender => 'o')
    puts @parent.gender_display
    puts @parent2.gender_display
    puts @child.gender_display
  end
end
