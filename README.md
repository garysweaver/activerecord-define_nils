Define Nils for ActiveRecord 3.x/4.x and Rails 3.x/4.x
=====

If working with a legacy database used by another application that uses a non-null value to mean null, you may need to translate certain values to nil to make them more normal to work with in Ruby/Rails and then save nil as a specific value.

For example, if nil is stored as 0 in `my_id`:

    define_nils as: 0, for: :my_id

If nil is stored as 0 in `my_id` and `your_id`:

    define_nils as: 0, for: [:my_id, :your_id]

If you want to accept 0 or '' as nil for `my_id` but save nil as 0:

    define_nils as: [0, ''], for: :my_id, saving_as: 0

It will choose the only/first element in the as if you don't specify `saving_as`, so a less clear way to define that is:

    define_nils as: [0, ''], for: :my_id

If you want to accept 0 or '' as nil for `my_id` and `your_id` but save nil as nil/null:

    define_nils as: [0, ''], for: [:my_id, :your_id], saving_as: nil

It handles `read_attribute` calls, calls to the attribute name, and all `belongs_to` associations defined after the `define_nils` that use the specified attribute as a foreign_key. It also will show the value as nil in calls to inspect/returned values in rails console. So, for the most part it should look as if the value is nil within Ruby but on the database-side, nil is stored as whatever value you want to represent nil.

### Setup

In your ActiveRecord/Rails 3.1+ project, add this to your Gemfile:

    gem 'activerecord-define_nils'

For the development version:

    gem 'activerecord-define_nils', :git => 'git://github.com/garysweaver/activerecord-define_nils.git'

Then run:

    bundle install

### Usage

If you are on Rails, the concern `ActiveRecordDefineNils::Model` is included automatically in `ActiveRecord::Base` via railtie.

Be sure to place `define_nils` above your `belongs_to` associations in the model class or those associations will query on unaltered foreign key values, which is probably not what you want.

### License

Copyright (c) 2013 FineLine Prototyping, Inc., released under the [MIT license][lic].

[lic]: http://github.com/garysweaver/activerecord-define_nils/blob/master/LICENSE
