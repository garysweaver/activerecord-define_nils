require 'activerecord-define_nils'

module ActiveRecordDefineNils
  class Railtie < Rails::Railtie
    initializer "define_nils.active_record" do
      ActiveSupport.on_load(:active_record) do
        include ActiveRecordDefineNils::Model
      end
    end
  end
end
