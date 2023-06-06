import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../misc/graphs/bar_graph/bar_graph.dart';
import '../../misc/graphs/line_graph/line_graph.dart';
import '../../misc/graphs/pie_graph/pie_graph.dart';

enum GraphType {
  BarGraph,
  PieChart,
  LineChart,
}

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  GraphType selectedGraph = GraphType.BarGraph;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<GraphType>(
              value: selectedGraph,
              onChanged: (GraphType? newValue) {
                setState(() {
                  selectedGraph = newValue!;
                });
              },
              items: GraphType.values.map((GraphType graphType) {
                return DropdownMenuItem<GraphType>(
                  value: graphType,
                  child: Text(graphType.toString().split('.').last),
                );
              }).toList(),
            ),
            GraphWidget(graphType: selectedGraph),
          ],
        ),
      ),
    );
  }
}

class GraphWidget extends StatelessWidget {
  final GraphType graphType;

  const GraphWidget({required this.graphType});

  @override
  Widget build(BuildContext context) {
    Widget graphWidget;
    double aspectRatio;

    switch (graphType) {
      case GraphType.BarGraph:
        graphWidget = BarGraph();
        aspectRatio = 1.4; // Adjust the aspect ratio for the BarGraph
        break;
      case GraphType.PieChart:
        graphWidget = PieChart();
        aspectRatio = 2.5; // Adjust the aspect ratio for the PieChart
        break;
      case GraphType.LineChart:
        graphWidget = LineChart();
        aspectRatio = 1.5; // Adjust the aspect ratio for the LineChart
        break;
    }

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: graphWidget,
    );
  }
}

class BarGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Build the Bar Graph widget
    return BarGraphWidget();
  }
}

class PieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Build the Pie Chart widget
    return PieGraphWidget();
  }
}

class LineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Build the Line Chart widget
    return LineGraph();
  }
}
