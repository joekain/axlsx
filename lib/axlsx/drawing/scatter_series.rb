# encoding: UTF-8
module Axlsx
  class ScatterSeries < Series
    # The x data for this series. 
    # @return [ValAxisData]
    attr_reader :xData

    # The y data for this series. 
    # @return [ValAxisData]
    attr_reader :yData

    def initialize(chart, options={})
      @xData, @yData = nil
      super(chart, options)

      @xData = XValAxisData.new(options[:xData]) unless options[:xData].nil?
      @yData = YValAxisData.new(options[:yData]) unless options[:yData].nil?
    end

    # Serializes the series
    # @param [Nokogiri::XML::Builder] xml The document builder instance this objects xml will be added to.
    # @return [String]
    def to_xml(xml)
      super(xml) do |xml_inner|
        @xData.to_xml(xml_inner) unless @xData.nil?
        @yData.to_xml(xml_inner) unless @yData.nil?
      end      
    end

    private

    # assigns the data for this series
    def xData=(v) DataTypeValidator.validate "Series.data", [SimpleTypedList], v; @data = v; end
    def yData=(v) DataTypeValidator.validate "Series.data", [SimpleTypedList], v; @data = v; end

  end
end
