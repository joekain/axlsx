# encoding: UTF-8
module Axlsx
  # The color class represents a color used for borders, fills an fonts
  class Color
    # Determines if the color is system color dependant
    # @return [Boolean]
    attr_reader :auto

    # The color as defined in rgb terms.
    # @note
    #  rgb colors need to conform to ST_UnsignedIntHex. That basically means put 'FF' before you color
    # When assigning the rgb value the behavior is much like CSS selectors and can use shorthand versions as follows:
    # If you provide a two character value it will be repeated for each r, g, b assignment
    # If you provide data that is not 2 characters in length, and is less than 8 characters it will be padded with "F"
    # @example
    #        Color.new :rgb => "FF000000"
    #          => #<Axlsx::Color:0x102106b68 @rgb="FF000000">
    #        Color.new :rgb => "0A"
    #          => #<Axlsx::Color:0x102106b68 @rgb="FF0A0A0A">
    #        Color.new :rgb => "00BB"
    #          => #<Axlsx::Color:0x102106b68 @rgb="FFFF00BB">
    # @return [String]
    attr_reader :rgb

    # no support for theme just yet
    # @return [Integer]
    #attr_reader :theme

    # The tint value.
    # @note valid values are between -1.0 and 1.0
    # @return [Float]
    attr_reader :tint

    # Creates a new Color object
    # @option options [Boolean] auto
    # @option options [String] rgb
    # @option options [Float] tint
    def initialize(options={})
      @rgb = "FF000000"
      options.each do |o|
        self.send("#{o[0]}=", o[1]) if self.respond_to? o[0]
      end
    end
    # @see auto
    def auto=(v) Axlsx::validate_boolean v; @auto = v end
    # @see color
    def rgb=(v)
      Axlsx::validate_string(v)
      v.upcase!
      v = v * 3 if v.size == 2
      v = v.rjust(8, 'FF')
      raise ArgumentError, "Invalid color rgb value: #{v}." unless v.match(/[0-9A-F]{8}/)
      @rgb = v
    end
    # @see tint
    def tint=(v) Axlsx::validate_float v; @tint = v end

    # This version does not support themes
    # def theme=(v) Axlsx::validate_unsigned_integer v; @theme = v end

    # Indexed colors are for backward compatability which I am choosing not to support
    # def indexed=(v) Axlsx::validate_unsigned_integer v; @indexed = v end

    def to_xml_string(str = '')
      str << "<color "
      self.instance_values.each do |key, value|
        str << key.to_s << '="' << value.to_s << '" '
      end
      str << "/>"
    end

    # Serializes the color
    # @param [Nokogiri::XML::Builder] xml The document builder instance this objects xml will be added to.
    # @return [String]
    def to_xml(xml) xml.color(self.instance_values) end
  end
end
