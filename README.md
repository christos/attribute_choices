AttributeChoices
================

A plugin to help you map your database enumerations to human readable form.

Given an ActiveRecord model with an attribute that has some discreet values in the database, AttributeChoices provides convenient methods to access the display values for that attribute. 

Example
=======

First define your model:

    class User < ActiveRecord::Base
      attribute_choices :gender,  { 'm' => "Male", 'f' => 'Female'}
      attribute_choices :age_group,  [
        ['18-24', '18 to 24 years old], 
        ['25-45', '25 to 45 years old']
      ]
    end

Then try this in the console:

    >> @john = User.new :gender => 'm', :age_group => '18-24', :name => 'John'
    >> @john.gender
    => 'm'
    >> @john.gender_display
    => 'Male'
    >> @john.age_group_display
    => '18 to 24 years old'
    >> User.gender_choices
    => [["Male", 'm'], ['Female', 'f']]
    => [['18-24', '18 to 24 years old], ['25-45', '25 to 45 years old']]
    
ToDo
====

* Write basic tests
* Gem?
* Make it work with any Class with attributes, not just AR::Base?
* Validate presence of attribute before defining methods
* Validate absence of _display and _choices methods
* Consider the usefulness of _choices= method

Copyright (c) 2009 Christos Zisopoulos, released under the MIT license
