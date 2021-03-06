# encoding: UTF-8
module Axlsx
  # The Scaling class defines axis scaling
  class Scaling

    # logarithmic base for a logarithmic axis.
    # must be between 2 and 1000
    # @return [Integer]
    attr_reader :logBase

    # the orientation of the axis
    # must be one of [:minMax, :maxMin]
    # @return [Symbol]
    attr_reader :orientation

    # the maximum scaling
    # @return [Float]
    attr_reader :max

    # the minimu scaling
    # @return [Float]
    attr_reader :min

    # creates a new Scaling object
    # @option options [Integer, Fixnum] logBase
    # @option options [Symbol] orientation
    # @option options [Float] max
    # @option options [Float] min
    def initialize(options={})
      @orientation = :minMax
      @logBase, @min, @max = nil, nil, nil
      options.each do |o|
        self.send("#{o[0]}=", o[1]) if self.respond_to? "#{o[0]}="
      end
    end

    # @see logBase
    def logBase=(v) DataTypeValidator.validate "Scaling.logBase", [Integer, Fixnum], v, lambda { |arg| arg >= 2 && arg <= 1000}; @logBase = v; end
    # @see orientation
    def orientation=(v) RestrictionValidator.validate "Scaling.orientation", [:minMax, :maxMin], v; @orientation = v; end
    # @see max
    def max=(v) DataTypeValidator.validate "Scaling.max", Float, v; @max = v; end

    # @see min
    def min=(v) DataTypeValidator.validate "Scaling.min", Float, v; @min = v; end

    def to_xml_string(str = '')
      str << '<c:scaling>'
      str << '<c:logBase val="' << @logBase.to_s << '"/>' unless @logBase.nil?
      str << '<c:orientation val="' << @orientation.to_s << '"/>' unless @orientation.nil?
      str << '<c:min val="' << @min.to_s << '"/>' unless @min.nil?
      str << '<c:max val="' << @max.to_s << '"/>' unless @max.nil?
      str << '</c:scaling>'
    end

  end
end
