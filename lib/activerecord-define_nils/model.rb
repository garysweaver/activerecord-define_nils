module ActiveRecordDefineNils
  module Model
    extend ActiveSupport::Concern

    included do
      class_attribute :nil_definitions, instance_writer: false
      class_attribute :nil_saved_as, instance_writer: false
    end

    module ClassMethods

      def define_nils(options)
        raise ArgumentError.new("define_nils takes a hash, but got #{options.inspect}") unless options.is_a?(Hash)
        if options.has_key?(:as) && options.has_key?(:for)
          self.nil_saved_as ||= {}
          self.nil_definitions ||= {}
          as_vals = Array.wrap(options[:as])
          raise ArgumentError.new("define_nils must supply at least one value for :as, but got #{options.inspect}") if as_vals.size == 0
          Array.wrap(options[:for]).each do |attr_name|
            attr_sym = attr_name.to_sym
            self.nil_saved_as[attr_sym] = options[:saving_as] || as_vals[0]
            self.nil_definitions[attr_sym] = as_vals
            class_eval "def #{attr_name}; value = super(); self.nil_definitions && self.nil_definitions[#{attr_sym.inspect}] && self.nil_definitions[#{attr_sym.inspect}].include?(value) ? nil : value; end"
          end
        else
          raise ArgumentError.new("define_nils takes a hash with :as and :for keys, but got #{options.inspect}")
        end
      end

      def belongs_to(*args)
        super(*args)
        return unless self.nil_definitions
        # after belongs_to is finished, we wrap it
        self.nil_definitions.keys.each do |attr_sym|
          self.reflections.collect {|association_name, reflection|
            if reflection.macro == :belongs_to && reflection.foreign_key.to_sym == attr_sym
              class_eval "def #{association_name}; return nil if __send__(#{attr_sym.inspect}).nil?; super(); end"
            end
          }
        end
      end

    end

    def read_attribute(attr_name)
      value = super(attr_name)
      (@define_nils_no_read_mod ||= false) ? value : (self.nil_definitions && self.nil_definitions[attr_name.to_sym] && self.nil_definitions[attr_name.to_sym].include?(value) ? nil : value)
    end

    private

    def create
      @define_nils_no_read_mod = true
      if self.nil_saved_as
        self.nil_saved_as.each do |column, translated_nil|
          if respond_to?(column) && respond_to?("#{column}=") && self.__send__(column).nil?
            write_attribute(column.to_s, translated_nil)
          end
        end
      end

      super
    ensure
      @define_nils_no_read_mod = false
    end

    def update(*args)
      @define_nils_no_read_mod = true
      if self.nil_saved_as
        self.nil_saved_as.each do |column, translated_nil|
          if respond_to?(column) && respond_to?("#{column}=") && self.__send__(column).nil?
            write_attribute(column.to_s, translated_nil)
          end
        end
      end
      
      super
    ensure
      @define_nils_no_read_mod = false
    end
  end
end
