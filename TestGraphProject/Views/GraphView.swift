//
//  GraphView.swift
//  TestGraphProject
//
//  Created by Taras Chernysh on 29.03.2022.
//

import UIKit
import Charts
import SnapKit

final class StatisticGraphView: UIView {
    private var chartView: LineChartView = {
        let view = LineChartView(frame: .zero)
        return view
    }()
    
    private let maxY: Double
    private var segmentItem: SegmentedItem = .week
    
    // MARK: - Init
    
    init(
        configs: [Config],
        maxMoodLevel: Double
    ) {
        self.maxY = maxMoodLevel
        
        super.init(frame: .zero)
        
        addView()
        setup()
        setDataCount(
            configs: configs,
            maxMoodLevel: maxMoodLevel,
            segmentItem: .week
        )
    }
    
    required init?(coder: NSCoder) {
        self.maxY = 0
        super.init(coder: coder)
    }
    
    // MARK: - Public
    
    func animateGraph() {
        chartView.animate(xAxisDuration: 0.35)
    }
    
    func setDataCount(
        configs: [Config],
        maxMoodLevel: Double,
        segmentItem: SegmentedItem
    ) {
        self.segmentItem = segmentItem
        
        let realValues = makeEntries(from: configs)
        let set1 = LineChartDataSet(entries: realValues, label: " ")
        setup(set1)
        
        let data = LineChartData(dataSet: set1)
        
        chartView.xAxis.valueFormatter = TGXAxisFormatter(segmentedItem: segmentItem)
        chartView.data = data

        if let last = realValues.last {
            let highlight = Highlight(x: last.x, y: last.y, dataSetIndex: 0)
            self.chartView.highlightValue(highlight, callDelegate: true)
        }
        animateGraph()
    }
    
    // MARK: - Private
    
    private func makeEntries(from configs: [Config]) -> [ChartDataEntry] {
        let values = configs
            .sorted(by: { $0.timeInterval < $1.timeInterval })
            .map {
            ChartDataEntry(x: $0.timeInterval, y: $0.moodLevel, icon: nil)
        }
        return values
    }
    
    private func setup() {
        chartView.delegate = self

        chartView.chartDescription.enabled = false
        chartView.dragEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
//        chartView.data?.highlightEnabled = true
//
        chartView.legend.form = .none
        chartView.setViewPortOffsets(left: 0, top: 10, right: 0, bottom: 50)
  

        // x axis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = false
        xAxis.valueFormatter = TGXAxisFormatter(segmentedItem: segmentItem)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularityEnabled = true
        xAxis.granularity = segmentItem == .week ? 43_200 : 2_592_000//2592000// seconds in whole day
        chartView.xAxis.setLabelCount(7, force: false)

        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = maxY
        leftAxis.axisMinimum = 0
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawAxisLineEnabled = false
        chartView.rightAxis.enabled = false
        let marker = BalloonMarker(
            color: .white,
            font: .systemFont(ofSize: 17, weight: .semibold),
            textColor: .black,
            insets: UIEdgeInsets(top: 8, left: 8, bottom: 10, right: 8)
        )
        marker.minimumSize = CGSize(width: 80, height: 40)
        marker.chartView = chartView
        chartView.marker = marker
    }
    
    private func setup(_ dataSet: LineChartDataSet) {
        let set1 = dataSet
        
       
        // version of Charts must be 4.0.0
        // then uncomment code below
//        set1.isDrawLineWithGradientEnabled = true
//        set1.gradientPositions = [0, maxY]
//        set1.setColors(R.color.sidecar()!, R.color.brandy()!)
//        chartView.data?.isHighlightEnabled = true
        // path
        set1.setColors(UIColor.systemOrange)
        set1.lineWidth = 6.0
        set1.mode = .cubicBezier

        // hole and circle
        set1.circleRadius = 6.0
        set1.circleHoleRadius = 4
        set1.drawCircleHoleEnabled = true
        set1.setCircleColor(UIColor.systemOrange)
        set1.drawCirclesEnabled = true
        
        // value
        set1.drawValuesEnabled = true
        let formatter = TGValueFormatter()
        formatter.visibleEntries = [set1.last]
        set1.valueFormatter = formatter
        set1.valueFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        set1.highlightEnabled = true
        set1.highlightLineWidth = 2
        set1.highlightColor = UIColor.systemOrange
        set1.highlightLineDashLengths = [8]
        set1.drawHorizontalHighlightIndicatorEnabled = false
    }
    
    private func addView() {
        addSubview(chartView)
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - ChartViewDelegate

extension StatisticGraphView: ChartViewDelegate {
   
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected: x = \(highlight.x), \(highlight.y)")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("chartValueNothingSelected")
    }
}

// MARK: -

extension StatisticGraphView {
    struct Config {
        let moodLevel: Double
        let timeInterval: TimeInterval
    }
}

class TGXAxisFormatter: AxisValueFormatter {
    private let segmentedItem: SegmentedItem
    
    init(segmentedItem: SegmentedItem) {
        self.segmentedItem = segmentedItem
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate(segmentedItem == .week ? "EEEEE" : "MMM")
        dateFormatter.locale = .current
        axis?.labelFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        axis?.labelTextColor = .gray
        
        let date = Date(timeIntervalSince1970: value)
        
        return dateFormatter.string(from: date)
    }
}

class TGValueFormatter: ValueFormatter {
    var visibleEntries: [ChartDataEntry?] = []

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
        //visibleEntries.contains(entry) ? "\(value)" : ""
    }
}

