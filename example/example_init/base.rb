class ExampleInit::Base
  include UnitAdv::ModuleUnit::Klass
  include UnitAdv::ModuleUnit::MethodCall
  include UnitAdv::ModuleUnit::Init
  include UnitAdv::ModuleUnit::TransformTo

  attr_accessor :data

end
