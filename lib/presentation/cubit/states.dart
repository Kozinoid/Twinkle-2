import 'package:twinkle/domain/models/time_class.dart';

abstract class TwinkleState{}

class TwinkleLoadingState extends TwinkleState{}

class TwinkleOnBoardOneState extends TwinkleState{}

class TwinkleOnBoardTwoState extends TwinkleState{}

class TwinkleProcessingState extends TwinkleState{
  TwinkleProcessingState(this.timeToNextSmoke, this.percentageToNextSmoke);
  final DayTime timeToNextSmoke;
  final double percentageToNextSmoke;
}

class TwinkleSettingsState extends TwinkleState{}

class TwinkleAchivementsState extends TwinkleState{}

class TwinkleNextCigaretteState extends TwinkleState{}

class TwinkleWakeUpState extends TwinkleState{}

class TwinkleGoodNightState extends TwinkleState{}

class TwinkleCongratulationsState extends TwinkleState{}