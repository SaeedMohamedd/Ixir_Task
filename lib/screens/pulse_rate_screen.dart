import 'package:flutter/material.dart';
import 'package:xiri_task/components/pulse_animation.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'dart:async';
import 'package:xiri_task/module/get_data_from_xls_sheet.dart';
import 'package:xiri_task/constants.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class PulseRate extends StatefulWidget {
  @override
  _PulseRateState createState() => _PulseRateState();
}

class _PulseRateState extends State<PulseRate>
    with SingleTickerProviderStateMixin {
  final assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  bool _toggled = false;
  AnimationController controller;

  Timer _timer;
  GetData getData = GetData();
  int index = 0;
  List<double> ppgwave = List();

  _toggle() {
    _timer = Timer.periodic(Duration(milliseconds: 400), _generateTrace);

    assetsAudioPlayer.open(Audio("assets/beeb_sound.m4a"));
    assetsAudioPlayer.play();
    assetsAudioPlayer.playlistFinished.listen((finished) {
      assetsAudioPlayer.play();
    });
    getData.read_data();
    controller.forward();
    setState(() {
      _toggled = true;
    });
  }

  _untoggle() {
    setState(() {
      _toggled = false;
    });
    controller.reset();
    controller.stop();
    assetsAudioPlayer.pause();
    ppgwave.clear();
    _timer.cancel();
  }

  _generateTrace(Timer t) {
    setState(() {
      ppgwave.addAll(traceSine);

      if (index > 299) {
        index = 0;
      }
      index++;
    });
  }

  @override
  void initState() {
    super.initState();
    getData.read_data();

    controller = AnimationController(
      duration: Duration(milliseconds: 750),
      vsync: this,
      lowerBound: .5,
    );
    controller.addListener(() {
      setState(() {});
      if (controller.isCompleted) {
        controller.reverse();
      }
      if (controller.isDismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Oscilloscope scopeOne = Oscilloscope(
      showYAxis: true,
      yAxisColor: Colors.white,
      padding: 20.0,
      backgroundColor: Colors.white,
      traceColor: Colors.red,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      dataSet: ppgwave,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    child: Text(
                      'Welcome Back',
                      style:
                          TextStyle(fontSize: 25.0, color: Color(0xFFBAB9BA)),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    child: Text(
                      'Matte',
                      style:
                          TextStyle(fontSize: 30.0, color: Color(0xFF949494)),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          getData.ppg_data.isEmpty != true
                              ? getData.ppg_data[index]
                              : 'empty',
                          style: TextStyle(
                              fontSize: 40.0, color: Color(0xFF949494)),
                        ),
                        Text(
                          'bpm',
                          style: TextStyle(
                              fontSize: 20.0, color: Color(0xFF949494)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IconButton(
                            icon: Icon(Icons.favorite),
                            color: Colors.red,
                            iconSize:
                                _toggled != true ? 50 : 50 * controller.value,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
            Expanded(
              child: Container(
                color: Color(0xFFB5B5B5),
                child: _toggled != true ? null : scopeOne,
              ),
            ),
            Expanded(
              child: Center(
                child: new CustomPaint(
                  painter: _toggled != true ? null : SpritePainter(),
                  child: IconButton(
                    icon: Icon(Icons.circle),
                    color: Colors.red,
                    iconSize: _toggled != true ? 150 : 150 * controller.value,
                    onPressed: () {
                      if (_toggled) {
                        _untoggle();
                      } else {
                        _toggle();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
