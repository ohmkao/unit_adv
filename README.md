# UnitAdv

Easy use provide a logical method for self code

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unit_adv', tag: "v0.5", git: "https://github.com/ohmkao/unit_adv.git"
```

And then execute:

    $ bundle install


## Usage

```
class ObjApple::Box
  include UnitAdv::ModuleUnit::Klass
  include UnitAdv::ModuleUnit::MethodCall
  include UnitAdv::ModuleUnit::Init

end
```

## Development

See unit_adv/example/
