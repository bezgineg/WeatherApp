import Charts

public class LineChartFormatter: NSObject, IAxisValueFormatter
{
    var names = [String]()

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return names[Int(value)]
    }

    public func setValues(values: [String])
    {
        self.names = values
    }
}
