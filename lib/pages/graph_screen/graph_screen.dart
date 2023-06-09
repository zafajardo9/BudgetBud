import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../misc/colors.dart';
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
    return Container(
      width: Adaptive.w(100),
      height: Adaptive.h(55),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.mainColorOne, // Custom color for the border
                  width: 2.0, // Custom border thickness
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<GraphType>(
                value: selectedGraph,
                onChanged: (GraphType? newValue) {
                  setState(() {
                    selectedGraph = newValue!;
                  });
                },
                underline: SizedBox(),
                items: GraphType.values.map((GraphType graphType) {
                  return DropdownMenuItem<GraphType>(
                    value: graphType,
                    child: Text(graphType.toString().split('.').last),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            // Place Expanded directly inside Column
            flex: 1,
            child: GraphWidget(graphType: selectedGraph),
          ),
        ],
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
        aspectRatio = 2.5; // Adjust the aspect ratio for the BarGraph
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
    return PieGraphWidget(
      transactionType: TransactionType.all,
    );
  }
}

class LineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Build the Line Chart widget
    return LineGraph();
  }
}
