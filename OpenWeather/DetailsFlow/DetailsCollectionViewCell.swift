import Charts
import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    
    private let lineChart: LineChartView = {
        let chart = LineChartView()
        chart.legend.enabled = false
        chart.isUserInteractionEnabled = false
        chart.backgroundColor = Colors.dividerColor.withAlphaComponent(0.3)
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.enabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.leftAxis.drawZeroLineEnabled = true
        chart.leftAxis.axisLineDashLengths = [5]
        chart.xAxis.labelCount = 25
        chart.leftAxis.zeroLineDashLengths = [5]
        chart.leftAxis.axisLineColor = Colors.dividerColor
        chart.leftAxis.zeroLineColor = Colors.dividerColor
        return chart
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Colors.customBackgroundColor
        setupLineChart()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLineChart() {
        var values = [Int]()
        var times = [String]()
        var icons = [UIImage]()
        
        for i in 0 ..< HourlyWeatherStorage.hourlyWeather.count - 1 {
            let data = HourlyWeatherStorage.hourlyWeather[i]
            let temp = Int(data.temp)
            values.append(temp)
            
            let time = data.dt
            let date = NSDate(timeIntervalSince1970: TimeInterval(time))
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let newTime = formatter.string(from: date as Date)
            times.append(newTime)
            
            let weather = HourlyWeatherStorage.hourlyWeather[i].weather.first?.main.rawValue
            let image = setupWeatherImage(weather: weather)
            
            if let image = image {
                icons.append(image)
            } else {
                icons.append(#imageLiteral(resourceName: "fullMoon"))
            }
        }
        
        setChart(dataPoints: times, values: values, icons: icons)
    }
    
    private func setChart(dataPoints: [String], values: [Int], icons: [UIImage]) {
        let formatter = LineChartFormatter()
        formatter.setValues(values: dataPoints)
        let xaxis:XAxis = XAxis()
        
        var entries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count - 1 {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]), icon: icons[i])
            entries.append(dataEntry)
        }
        
        //entries.sort(by: { $0.x < $1.x })

        let valueForm = NumberFormatter()
        valueForm.numberStyle = .percent
        valueForm.maximumFractionDigits = 0
        valueForm.multiplier = 1.0
        valueForm.percentSymbol = "°"
        
        let set = LineChartDataSet(entries: entries)
        set.drawCircleHoleEnabled = false
        set.drawCirclesEnabled = false
        set.valueFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        set.circleColors = [UIColor.white]
        set.colors = [UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)]
        set.valueFormatter = DefaultValueFormatter(formatter: valueForm)
        
        let data = LineChartData(dataSet: set)
        lineChart.data = data

        xaxis.valueFormatter = formatter
        lineChart.xAxis.valueFormatter = xaxis.valueFormatter
        
        lineChart.data = data
    }
    
    private func setupWeatherImage(weather: String?) -> UIImage? {
        switch weather {
        case "Clear":
            return UIImage(named: "sun")?.resize(60)
        case "Rain":
            return UIImage(named: "rain")?.resize(60)
        case "Clouds":
            return UIImage(named: "clouds")?.resize(60)
        default:
            return UIImage(named: "fullMoon")?.resize(60)
        }
    }
    
    private func setupLayout() {
        contentView.addSubviews(lineChart)

        let constraints = [
            lineChart.topAnchor.constraint(equalTo: contentView.topAnchor),
            lineChart.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lineChart.widthAnchor.constraint(equalToConstant: 2000),
            lineChart.heightAnchor.constraint(equalToConstant: 160)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}



