import 'dart:async';
import 'dart:math';
import 'package:achievement_view/achievement_view.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:schulte/model/points_model.dart';
import 'package:schulte/screens/result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

var height = 5.0, width = 5.0;
// ignore: deprecated_member_use
List<int> listem = List() ;
// ignore: deprecated_member_use
List<bool> gosterContainer = List() ;
int siradakiSayi = 1;
Duration timeDuration;
String score = "";
// ignore: deprecated_member_use
List<PointsModel> pointsList = List();

// ignore: deprecated_member_use
List<charts.Series<PointsModel, String>> seriesList = List();

bool stopIsPressed = true;
String stopTimeDisp = "00:00:00";
var swatch = Stopwatch();
final dur = const Duration(microseconds: 0);

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    listeyiOlustur();
    startWatch();
    super.initState();
  }

  @override
  void dispose() {
    stopTimeDisp = "00:00:000";
    resetWatch();
    super.dispose();
  }

  void startTimer() {
    Timer(dur, keepRunning);
  }

  void keepRunning() {
    if (swatch.isRunning) {
      startTimer();
    }
    setState(() {
      stopTimeDisp =
          (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
              ":" +
              (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0") +
              ":" +
              (swatch.elapsed.inMilliseconds % 1000).toString().padLeft(3, "0");
    });
  }

  void startWatch() {
    setState(() {
      stopIsPressed = false;
    });
    swatch.start();
    startTimer();
  }

  void resetWatch() {
    swatch.stop();
    swatch.reset();
    var newDuration = Duration();
    timeDuration = newDuration;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 10;
    width = MediaQuery.of(context).size.width / 7;

    return Scaffold(
      appBar: AppBar(
        title: Text(stopTimeDisp),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 5; i++) satir(i),
            ],
          ),
        ),
      ),
    );
  }

  void listeyiOlustur() {
    timeDuration = new Duration();
    // listeyi temizle
    listem.clear();
    gosterContainer.clear();
    pointsList.clear();
    seriesList.clear();

    siradakiSayi = 1;

    // listeyi oluştur
    for (var i = 1; i < 26; i++) {
      listem.add(i);
      gosterContainer.add(true);
    }
    // listeyi karıştır
    listem.shuffle();
  }
}

Widget satir(int x) {
  x = x * 5;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var i = 0; i < 5; i++) kutu(x + i),
    ],
  );
}

Widget kutu(int y) {
  return Butonlar(y);
}

class Butonlar extends StatefulWidget {
  final int y;
  const Butonlar(
    this.y, {
    Key key,
  }) : super(key: key);

  @override
  _ButonlarState createState() => _ButonlarState();
}

class _ButonlarState extends State<Butonlar> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: gosterContainer[widget.y] ? 1.0 : 0.0,
      child: ButtonTheme(
        height: height,
        minWidth: width,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: RaisedButton(
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(
              color: Colors.red,
            ),
          ),
          color: gosterContainer[widget.y] ? Colors.green : Colors.red,
          onPressed: () {
            setState(() {
              var result = kontrolEt(listem[widget.y], widget.y, context);
              if (result) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(
                      seriesList,
                      score.toString(),
                      animate: true,
                    ),
                  ),
                );
              }
            });
          },
          child: Center(
            child: Text(
              listem[widget.y].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool kontrolEt(int tiklananSayi, int index, context) {
  Duration diffDur = Duration();
  double diff = 0.0;
  if (siradakiSayi == tiklananSayi) {
    gosterContainer[index] = false;

    if (tiklananSayi == 1) {
      timeDuration = swatch.elapsed;
      diffDur = timeDuration;
    } else {
      diffDur = swatch.elapsed - timeDuration;
    }

    diff = diffDur.inSeconds.roundToDouble();
    if (diffDur.inMilliseconds > 0) {
      diff = diff + (diffDur.inMilliseconds.toDouble() / 10000);
    }

    pointsList.add(PointsModel(siradakiSayi.toString(), diff,
        Colors.primaries[Random().nextInt(Colors.primaries.length)]));

    timeDuration = swatch.elapsed;

    if (tiklananSayi == 25) {
      stopWatch();
      seriesList = createData();
      addRecordScore(context);
      return true;
    }
    siradakiSayi++;
    return false;
  }
  return false;
}

void addRecordScore(context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  // en iyi score'u getir
  String bestScore = sharedPreferences.getString("bestscore");

  if (bestScore != null && bestScore != "00:00:000" && bestScore != "") {
    // best score'u integer ifadeye dönüştür
    String bestScoreStr = bestScore.substring(0, 2) +
        bestScore.substring(3, 5) +
        bestScore.substring(6, 9);
    String currScoreStr =
        score.substring(0, 2) + score.substring(3, 5) + score.substring(6, 9);
    // mevcut score ile karşılaştır.
    if (int.tryParse(currScoreStr) < int.tryParse(bestScoreStr)) {
      sharedPreferences.setString('bestscore', score);
      newRecordMessage(context);
    }
  } else {
    sharedPreferences.setString('bestscore', score);
    newRecordMessage(context);
  }
}

void newRecordMessage(BuildContext context) {
  AchievementView(
    context,
    title: "Yeaaah!",
    subTitle: "Congratulations for achieving Best Score in the game",
    icon: Icon(
      Icons.insert_emoticon,
      color: Colors.yellow,
    ),
    borderRadius: 5.0,
    color: Colors.blueGrey,
  )..show();
}

List<charts.Series<PointsModel, String>> createData() {
  return [
    new charts.Series<PointsModel, String>(
      id: 'Points',
      colorFn: (PointsModel point, __) => point.color,
      domainFn: (PointsModel point, _) => point.adim,
      measureFn: (PointsModel point, _) => point.point,
      data: pointsList,
    )
  ];
}

void stopWatch() {
  swatch.stop();
  score = (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
      ":" +
      (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0") +
      ":" +
      (swatch.elapsed.inMilliseconds % 1000).toString().padLeft(3, "0");
}
