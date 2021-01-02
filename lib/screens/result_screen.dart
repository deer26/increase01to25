import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'home_screen.dart';

// ignore: must_be_immutable
class ResultScreen extends StatefulWidget {
  List<charts.Series> seriesList;
  bool animate;
  String score;

  ResultScreen(this.seriesList, this.score, {this.animate = true});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Score is ${widget.score}"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return HomeScreen();
                }));
              }),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Time spent to find",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Expanded(
                    child: charts.BarChart(
                      widget.seriesList,
                      vertical: true,
                      animationDuration: Duration(milliseconds: 20),
                      animate: widget.animate,
                      domainAxis: new charts.OrdinalAxisSpec(
                        renderSpec: new charts.SmallTickRendererSpec(
                          labelStyle: new charts.TextStyleSpec(
                              fontSize: 6, color: charts.MaterialPalette.white),
                        ),
                      ),
                      primaryMeasureAxis: new charts.NumericAxisSpec(
                        renderSpec: new charts.GridlineRendererSpec(
                          // Tick and Label styling here.
                          labelStyle: new charts.TextStyleSpec(
                              fontSize: 10, // size in Pts.
                              color: charts.MaterialPalette.white),

                          // Change the line colors to match text color.
                        ),
                      ),
                      barGroupingType: charts.BarGroupingType.groupedStacked,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
