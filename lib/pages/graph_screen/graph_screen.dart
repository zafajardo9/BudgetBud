import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../misc/graphs/bar_graph/bar_graph.dart';
import '../../misc/graphs/bargraph.dart';
import '../../misc/graphs/line_graph/line_graph.dart';
import '../../misc/graphs/pie_graph/pie_graph.dart';

enum GraphType {
  BarGraph,
  PieChart,
  LineChart,
  //LineChart,
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
      height: Adaptive.h(45),
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
    switch (graphType) {
      case GraphType.BarGraph:
        return BarGraph();
      case GraphType.PieChart:
        return PieChart();

      case GraphType.LineChart:
        return LineChart();
    }
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
    // Build the Pie Chart widget
    return LineGraph();
  }
}

// class LineChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Build the Line Chart widget
//     return Container(
//       child: Text('Line Chart'),
//     );
//   }
// }
