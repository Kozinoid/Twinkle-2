import 'package:flutter/material.dart';
import 'package:twinkle/presentation/style/styles.dart';

class TwinkleSplash extends StatelessWidget {
  const TwinkleSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Utils.DARK_BLUE_COLOR,
        body: Stack(
          children: [
            Center(child: Image.asset("assets/images/splash.jpg")),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: const CircularProgressIndicator(
                  strokeWidth: 10,
                  color: Utils.DARK_BLUE_COLOR,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
