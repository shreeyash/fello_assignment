import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  double _bottomPadding = 24;

  void jumpMario() async {
    setState(() {
      _bottomPadding = 110;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _bottomPadding = 24;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.elasticIn,
            height: 350,
            child: Image.asset('assets/mario.png'),
            margin: EdgeInsets.only(bottom: _bottomPadding),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RawMaterialButton(
              onPressed: () {
                jumpMario();
              },
              elevation: 2.0,
              fillColor: Colors.red,
              child: Text(
                'Jump',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
              padding: EdgeInsets.all(25.0),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
    );
  }
}
