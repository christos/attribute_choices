require 'test_helper'


class AttributesWithChoicesTest < ActiveSupport::TestCase
  
  setup do
    class Profile < ActiveRecord::Base
    end
  end
    
  test "It should add a class method to all ActiveRecord objects" do
    assert_respond_to(Profile, :attributes_with_choices)
  end
  
end
