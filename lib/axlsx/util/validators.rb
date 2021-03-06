# encoding: UTF-8
module Axlsx
  # Validate a value against a specific list of allowed values.
  class RestrictionValidator
    # Perform validation
    # @param [String] name The name of what is being validatied. This is included in the error message
    # @param [Array] choices The list of choices to validate against
    # @param [Any] v The value to be validated
    # @raise [ArgumentError] Raised if the value provided is not in the list of choices.
    # @return [Boolean] true if validation succeeds.
    def self.validate(name, choices, v)
      raise ArgumentError, (ERR_RESTRICTION % [v.to_s, name, choices.inspect]) unless choices.include?(v)
      true
    end
  end

  # Validates the value against the regular expression provided.
  class RegexValidator
    # @param [String] name The name of what is being validated. This is included in the output when the value is invalid
    # @param [Regexp] regex The regular expression to evaluate
    # @param [Any] v The value to validate.
    def self.validate(name, regex, v)
      raise ArgumentError, (ERR_REGEX % [v.inspect, regex.to_s]) unless (v.respond_to?(:=~) && v =~ regex)
    end
  end
  # Validate that the class of the value provided is either an instance or the class of the allowed types and that any specified additional validation returns true.
  class DataTypeValidator
    # Perform validation
    # @param [String] name The name of what is being validated. This is included in the error message
    # @param [Array, Class] types A single class or array of classes that the value is validated against.
    # @param [Block] other Any block that must evaluate to true for the value to be valid
    # @raise [ArugumentError] Raised if the class of the value provided is not in the specified array of types or the block passed returns false
    # @return [Boolean] true if validation succeeds.
    # @see validate_boolean
    def self.validate(name, types, v, other= lambda{|arg| true })
      types = [types] unless types.is_a? Array
      valid_type = false
      if v.class == Class
        types.each { |t| valid_type = true if v.ancestors.include?(t) }
      else
        types.each { |t| valid_type = true if v.is_a?(t) }
      end
      raise ArgumentError, (ERR_TYPE % [v.inspect, name, types.inspect]) unless (other.call(v) && valid_type)
    end
    true
  end

  # Requires that the value is a Fixnum or Integer and is greater or equal to 0
  # @param [Any] v The value validated
  # @raise [ArgumentError] raised if the value is not a Fixnum or Integer value greater or equal to 0
  # @return [Boolean] true if the data is valid
  def self.validate_unsigned_int(v)
    DataTypeValidator.validate(:unsigned_int, [Fixnum, Integer], v, lambda { |arg| arg.respond_to?(:>=) && arg >= 0 })
  end

  # Requires that the value is a Fixnum Integer or Float and is greater or equal to 0
  # @param [Any] v The value validated
  # @raise [ArgumentError] raised if the value is not a Fixnun, Integer, Float value greater or equal to 0
  # @return [Boolean] true if the data is valid
  def self.validate_unsigned_numeric(v)
    DataTypeValidator.validate("Invalid column width", [Fixnum, Integer, Float], v, lambda { |arg| arg.respond_to?(:>=) && arg >= 0 })
  end

  # Requires that the value is a Fixnum or Integer
  # @param [Any] v The value validated
  def self.validate_int(v)
    DataTypeValidator.validate :unsigned_int, [Fixnum, Integer], v
  end

  # Requires that the value is a form that can be evaluated as a boolean in an xml document.
  # The value must be an instance of Fixnum, String, Integer, Symbol, TrueClass or FalseClass and
  # it must be one of 0, 1, "true", "false", :true, :false, true, false, "0", or "1"
  # @param [Any] v The value validated
  def self.validate_boolean(v)
    DataTypeValidator.validate(:boolean, [Fixnum, String, Integer, Symbol, TrueClass, FalseClass], v, lambda { |arg| [0, 1, "true", "false", :true, :false, true, false, "0", "1"].include?(arg) })
  end

  # Requires that the value is a String
  # @param [Any] v The value validated
  def self.validate_string(v)
    DataTypeValidator.validate :string, String, v
  end

  # Requires that the value is a Float
  # @param [Any] v The value validated
  def self.validate_float(v)
    DataTypeValidator.validate :float, Float, v
  end

  # Requires that the value is valid pattern type.
  # valid pattern types must be one of :none, :solid, :mediumGray, :darkGray, :lightGray, :darkHorizontal, :darkVertical, :darkDown,
  # :darkUp, :darkGrid, :darkTrellis, :lightHorizontal, :lightVertical, :lightDown, :lightUp, :lightGrid, :lightTrellis, :gray125, or :gray0625.
  # @param [Any] v The value validated
  def self.validate_pattern_type(v)
    RestrictionValidator.validate :pattern_type, [:none, :solid, :mediumGray, :darkGray, :lightGray, :darkHorizontal, :darkVertical, :darkDown, :darkUp, :darkGrid,
       :darkTrellis, :lightHorizontal, :lightVertical, :lightDown, :lightUp, :lightGrid, :lightTrellis, :gray125, :gray0625], v
  end

  # Requires that the value is a gradient_type.
  # valid types are :linear and :path
  # @param [Any] v The value validated
  def self.validate_gradient_type(v)
    RestrictionValidator.validate :gradient_type, [:linear, :path], v
  end

  # Requires that the value is a valid horizontal_alignment
  # :general, :left, :center, :right, :fill, :justify, :centerContinuous, :distributed are allowed
  # @param [Any] v The value validated
  def self.validate_horizontal_alignment(v)
    RestrictionValidator.validate :horizontal_alignment, [:general, :left, :center, :right, :fill, :justify, :centerContinuous, :distributed], v
  end

  # Requires that the value is a valid vertical_alignment
  # :top, :center, :bottom, :justify, :distributed are allowed
  # @param [Any] v The value validated
  def self.validate_vertical_alignment(v)
    RestrictionValidator.validate :vertical_alignment, [:top, :center, :bottom, :justify, :distributed], v
  end

  # Requires that the value is a valid content_type
  # TABLE_CT, WORKBOOK_CT, APP_CT, RELS_CT, STYLES_CT, XML_CT, WORKSHEET_CT, SHARED_STRINGS_CT, CORE_CT, CHART_CT, DRAWING_CT are allowed
  # @param [Any] v The value validated
  def self.validate_content_type(v)
    RestrictionValidator.validate :content_type, [TABLE_CT, WORKBOOK_CT, APP_CT, RELS_CT, STYLES_CT, XML_CT, WORKSHEET_CT, SHARED_STRINGS_CT, CORE_CT, CHART_CT, JPEG_CT, GIF_CT, PNG_CT, DRAWING_CT], v
  end

  # Requires that the value is a valid relationship_type
  # XML_NS_R, TABLE_R, WORKBOOK_R, WORKSHEET_R, APP_R, RELS_R, CORE_R, STYLES_R, CHART_R, DRAWING_R, IMAGE_R, HYPERLINK_R, SHARED_STRINGS_R are allowed
  # @param [Any] v The value validated
  def self.validate_relationship_type(v)
    RestrictionValidator.validate :relationship_type, [XML_NS_R, TABLE_R, WORKBOOK_R, WORKSHEET_R, APP_R, RELS_R, CORE_R, STYLES_R, CHART_R, DRAWING_R, IMAGE_R, HYPERLINK_R, SHARED_STRINGS_R], v
  end

  # Requires that the value is a valid table element type
  # :wholeTable, :headerRow, :totalRow, :firstColumn, :lastColumn, :firstRowStripe, :secondRowStripe, :firstColumnStripe, :secondColumnStripe, :firstHeaderCell, :lastHeaderCell, :firstTotalCell, :lastTotalCell, :firstSubtotalColumn, :secondSubtotalColumn, :thirdSubtotalColumn, :firstSubtotalRow, :secondSubtotalRow, :thirdSubtotalRow, :blankRow, :firstColumnSubheading, :secondColumnSubheading, :thirdColumnSubheading, :firstRowSubheading, :secondRowSubheading, :thirdRowSubheading, :pageFieldLabels, :pageFieldValues are allowed
  # @param [Any] v The value validated
  def self.validate_table_element_type(v)
    RestrictionValidator.validate :table_element_type, [:wholeTable, :headerRow, :totalRow, :firstColumn, :lastColumn, :firstRowStripe, :secondRowStripe, :firstColumnStripe, :secondColumnStripe, :firstHeaderCell, :lastHeaderCell, :firstTotalCell, :lastTotalCell, :firstSubtotalColumn, :secondSubtotalColumn, :thirdSubtotalColumn, :firstSubtotalRow, :secondSubtotalRow, :thirdSubtotalRow, :blankRow, :firstColumnSubheading, :secondColumnSubheading, :thirdColumnSubheading, :firstRowSubheading, :secondRowSubheading, :thirdRowSubheading, :pageFieldLabels, :pageFieldValues], v
  end

end
