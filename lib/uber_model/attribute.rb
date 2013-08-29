require 'bigdecimal'
require 'bigdecimal/util'

module UberModel
  class UnsupportedType < UberModelError; end
  class InvalidConversion < UberModelError; end

  # Attributes are persistable characteristics of a model, explicitly defined
  # by the user.
  #
  # By default, all attributes are initialized with a value of nil.
  class Attribute
    attr_reader :name, :type, :default
    attr_accessor :coder

    alias :encoded? :coder

    VALID_TYPES = [:string, :integer, :float, :decimal, :date, :datetime, :boolean]

    TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE'].to_set
    FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE'].to_set

    module Format
      ISO_DATE = /\A(\d{4})-(\d\d)-(\d\d)\z/
      ISO_DATETIME = /\A(\d{4})-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)(\.\d+)?\z/
    end

    #
    # Initializes a new Attribute object.  See {UberModel::AttributeMethods::ClassMethods#attribute attribute}
    def initialize(name, type, options = {})
      @name, @type = name.to_s, type
      @default = options.delete(:default)

      raise UnsupportedType.new("Invalid type: #{@type}") unless VALID_TYPES.include?(@type)
    end

    def number?
      [:integer, :float, :decimal].include?(@type)
    end

    def type_cast(value)
      return nil if value.nil?
      return coder.load(value) if encoded?

      klass = self.class
      case type
      when :string      then value.to_s
      when :integer     then klass.value_to_integer(value)
      when :float       then value.to_f rescue nil
      when :decimal     then klass.value_to_decimal(value)
      when :date        then klass.value_to_date(value)
      when :datetime    then klass.value_to_time(value)
      when :boolean     then klass.value_to_boolean(value)
      end
    end

    def type_cast_for_write(value)
      value
    end

    class << self
      def value_to_integer(value)
        case value
        when TrueClass, FalseClass
          value ? 1 : 0
        else
          value.to_i rescue nil
        end
      end

      def value_to_boolean(value)
        if value.is_a?(String) && value.blank?
          nil
        else
          TRUE_VALUES.include?(value)
        end
      end

      def value_to_decimal(value)
        if value.class == BigDecimal
          value
        elsif value.respond_to?(:to_d)
          value.to_d
        else
          value.to_s.to_d
        end
      end

      def value_to_date(value)
        if value.is_a?(String)
          return nil if value.empty?
          fast_string_to_date(value) || fallback_string_to_date(value)
        elsif value.respond_to?(:to_date)
          value.to_date
        else
          value
        end
      end

      def value_to_time(value)
        return value unless value.is_a?(String)
        return nil if value.empty?

        fast_string_to_time(value) || fallback_string_to_time(value)
      end

      protected

      def microseconds(time)
        ((time[:sec_fraction].to_f % 1) * 1_000_000).to_i
      end

      def new_date(year, mon, mday)
        if year && year != 0
          Date.new(year, mon, mday) rescue nil
        end
      end

      def new_time(year, mon, mday, hour, min, sec, microsec)
        return nil if year.nil? || (year == 0 && mon == 0 && mday == 0)

        
        DateTime.new(year, mon, mday, hour, min, sec, microsec) rescue nil
      end

      def fast_string_to_date(value)
        if value =~ Format::ISO_DATE
          new_date $1.to_i, $2.to_i, $3.to_i
        end
      end

      def fallback_string_to_date(string)
        new_date(*::Date._parse(string, false).values_at(:year, :mon, :mday))
      end

      def fast_string_to_time(string)
        if string =~ Format::ISO_DATETIME
          microsec = ($7.to_r * 1_000_000).to_i
          new_time $1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i, microsec
        end
      end

      def fallback_string_to_time(string)
        time_hash = Date._parse(string)
        time_hash[:sec_fraction] = microseconds(time_hash)

        new_time(*time_hash.values_at(:year, :mon, :mday, :hour, :min, :sec, :sec_fraction)) rescue nil
      end
    end
  end
end
