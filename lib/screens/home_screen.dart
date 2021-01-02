import 'package:flutter/material.dart';
import 'package:schulte/screens/game_screen.dart';
import 'package:schulte/screens/info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String score;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getBestScore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Schulte"),
          actions: [
            PopupMenuButton<int>(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Colors.black.withOpacity(0.5),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  child: Text("Clear Score"),
                ),
                PopupMenuItem(
                  value: 2,
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  child: Text("Info"),
                ),
              ],
              onSelected: (val) {
                if (val == 1) {
                  deleteScore();
                } else if (val == 2) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return InfoScreen();
                  }));
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Mode:Classic Light\n",
                style: TextStyle(
                  color: Color.fromRGBO(170, 170, 170, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                "Relax and Concentrate!\n Focus in the center box of the table. Try to see whole table.\n",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                "Click on the numbers in ascending order from 1 to 25.\n",
                style: TextStyle(
                  color: Colors.yellow,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.yellow,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(),
                      ),
                    ),
                    child: Text(
                      'Play The Game',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              (score == null || score == "")
                  ? Text("")
                  : Text(
                      "Best score is $score",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void getBestScore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      score = preferences.get("bestscore");
    });
  }

  void deleteScore() {
    showDialog(
        context: context,
        // ignore: deprecated_member_use
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          backgroundColor: Colors.grey.withOpacity(0.9),
          title: Text(
            "Deletion Process",
            style: TextStyle(
              color: Colors.amber,
            ),
          ),
          content:
              Text("The best score will be reset. Continue the transaction?"),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.remove("bestscore");
                  setState(() {
                    score = "";
                  });
                  Navigator.pop(context);
                }),
            IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.green,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ));
  }
}
