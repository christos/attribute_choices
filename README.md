AttributeChoices
================

A plugin to help you map your database enumerations to human readable form.

Given an attribute with discreet values in the database, you can provide a mapping to the model for those discreet values to a human readable strings.

Example
=======

    class User < ActiveRecord::Base
      attribute_choices :gender,  { 'm' => "Male", 'f' => 'Female'}
      attribute_choices :age_group,  [
        ['18-24', '18 to 24 years old], 
        ['25-45', '25 to 45 years old']
      ]
    end

    >> user = User.new :gender => 'f', :age_group => '18-24'
    >> user.gender
    => 'f'
    >> user.gender_display
    => 'Male'
    >> user.age_group_display
    => '18 to 24 years old'
    >> user.gender_choices
    => { 'm' => "Male", 'f' => 'Female'}
    
ToDo
====

* Write basic tests
* Validate presence of attribute before defining methods
* Validate absence of _display and _choices methods
* Consider the usefulness of _choices= method

Copyright (c) 2009 [Christos Zisopoulos], released under the MIT license
