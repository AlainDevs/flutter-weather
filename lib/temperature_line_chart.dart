import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import 'package:weather/presentation/resources/app_resources.dart'; // Removed import for AppColors

class LineChartSample2 extends StatefulWidget { // Optionally rename the class for consistency
  final List<double> temperatures;
  final List<String> times;

  const LineChartSample2({
    super.key, // Converted 'key' to super parameter
    required this.temperatures,
    required this.times,
  });

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  // Defined colors directly instead of using AppColors
  final List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  final Color mainGridLineColor = Colors.grey; // Added mainGridLineColor

  bool showAvg = false;

  @override
  void didUpdateWidget(LineChartSample2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.temperatures != widget.temperatures ||
        oldWidget.times != widget.times) {
      setState(() {
        showAvg = false; // Reset showAvg when new data is received
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom:
                  50, // Further increased bottom padding to accommodate rotated labels
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
        Positioned(
          bottom: 15, // Adjusted positioning to align with increased padding
          right: 0,
          child: SizedBox(
            width: 60,
            height: 34,
            child: TextButton(
              onPressed: () {
                setState(() {
                  showAvg = !showAvg;
                });
              },
              child: Text(
                'avg',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12, // Reduced font size to fit rotated text
    );

    // Calculate dynamic interval based on number of data points
    int dataPointCount = widget.times.length;
    double interval = dataPointCount > 5 ? (dataPointCount / 5).floorToDouble() : 1;

    Widget text;
    if (value.toInt() % interval == 0 && value.toInt() < widget.times.length) {
      text = Text(widget.times[value.toInt()], style: style);
    } else {
      text = const Text('', style: style);
    }

    return Transform.rotate(
      angle: -0.5, // Rotate the text by -0.5 radians (~-28.6 degrees)
      child: SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    double interval = calculateYInterval();

    if (value % interval == 0) {
      text = '${value.toInt()}°C';
    } else {
      return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  double calculateYInterval() {
    if (widget.temperatures.isEmpty) return 1;
    double maxTemp = widget.temperatures.reduce((a, b) => a > b ? a : b);
    double interval = (maxTemp / 5).ceilToDouble();
    return interval > 0 ? interval : 1;
  }

  LineChartData mainData() {
    if (widget.temperatures.isEmpty || widget.times.isEmpty) {
      return LineChartData(); // Return empty chart if no data
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < widget.temperatures.length; i++) {
      spots.add(FlSpot(i.toDouble(), widget.temperatures[i]));
    }

    double maxY = widget.temperatures.reduce((a, b) => a > b ? a : b) + 5;
    double minY = widget.temperatures.reduce((a, b) => a < b ? a : b) - 5;
    minY = minY < 0 ? 0 : minY;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: calculateYInterval(),
        verticalInterval: (widget.temperatures.length / 5).floorToDouble(),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: mainGridLineColor, // Replaced AppColors.mainGridLineColor
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: mainGridLineColor, // Replaced AppColors.mainGridLineColor
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50, // Further increased reserved size for rotated labels
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: calculateYInterval(),
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 50, // Increased reserved size for better label fit
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: (widget.temperatures.length - 1).toDouble(),
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    // Implement average data if needed
    return mainData();
  }
}
