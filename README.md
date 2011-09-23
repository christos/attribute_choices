## AttributeChoices

[![Build Status](https://secure.travis-ci.org/christos/attribute_choices.png)](http://travis-ci.org/christos/attribute_choices)

Extends ActiveRecord attributes with a `:choices` pseudo-type that provides convenient methods for mapping each choice to its human readable form.

## Examples

By defining the available choices for the `gender` attribute in your `User` model,

    class User < ActiveRecord::Base
      attribute_choices :gender,  [ ['m', "Male"], ['f', 'Female'] ], 
                                  :validate => true
    end

...for any given `User` instance,

    @john = User.new(:gender => 'm')
    @john.gender
     => 'm'

...you can access the human readable attribute value like this:

    @john.gender_display
     => 'Male'

If you need to provide the available choices in a `select` tag, you can simply use `User#gender_choices`,

    <%= select("user", "gender", User.gender_choices) %>

...which would give you the following HTML snippet
 
    <select name="user[gender]">
      <option value="m">Male</option>
      <option value="f">Femail</option>
    </select>

Validation is also taken care of, if you specify `:validate => true` in the options

     @john.gender = 'x'
     @john.valid? 
      => false

And if you work with multiple languages, given the following `es.yml`

    es:
      user:
        gender_choices:
          male:  'Hombre
          female: 'Mujer'

...you can specify the attribute choices like this:

    class User < ActiveRecord::Base
      attribute_choices :gender,  [ ['m', 'user.gender_choices.male'], ['f', 'user.gender_choices.female'] ], 
                                  :validate => true, :localize => true
    end

Then, provided that `I18n.locale == :es`, you are good to go:

    @john.gender_display
     => 'Hombre'

    User.gender_choices
      => [["Hombre", 'm'], ['Mujer', 'f']]


## Installation

#### Rails 3.x

  In your `Gemfile` add
  
    gem 'attribute_choices'

#### Rails 2.x

  In `environment.rb` add:
    
    config.gem 'attribute_choices'

## Changelog

#### V1.0.2

* Works correctly with overridden ActiveRecord attribute accessors
* Multi-ruby integration testing with Travis-CI

#### v1.0.1

* Refactor to eliminate deprecation warnings in Rails 3.1 (@porras)

#### v1.0.0

* Initial release

## ToDo

* Validate absence of _display and _choices methods

Copyright (c) 2009-2011 Christos Zisopoulos, released under the MIT license
