      processState = ProcessState.values[json['processState'] as int];
      extraCigarettesCount = json['extraCigarettesCount'];

      'processState' : processState.index,
      'extraCigarettesCount' : extraCigarettesCount,

//--------------------------- Calculations -----------------------------------
// Current day number
int _currentDay = 0;
int get currentDay => _currentDay;

// Today user must smoke minus this count cigarettes
double _minusCigarettePerDay = 0;
double get minusCigarettePerDay => _minusCigarettePerDay;

// Cigarettes, saved today
int _savedCigarettesPerDay = 0;
int get savedCigarettesPerDay => _savedCigarettesPerDay;

// Cigarettes, saved from begin
int _savedCigarettesFromBegin = 0;
int get savedCigarettesFromBegin => _savedCigarettesFromBegin;

// Money, saved from begin
int _savedMoney = 0;
int get savedMoney => _savedMoney;

// Time in percent to stop smoke finish
int _endOfSmoke = 0;
int get endOfSmoke => _endOfSmoke;

// Cigarettes, passed from begin
int _passedCigarettesFromBegin = 0;
int get passedCigarettesFromBegin => _passedCigarettesFromBegin;

// Cigarettes, passed today
int _totalCigarettesToday = 0;
int get totalCigarettesToday => _totalCigarettesToday;

// Cigarettes, smoked by now
int _smokedByNow = 0;
int get smokedByNow => _smokedByNow;

// Interval
DayTime _interval = DayTime(hours: 1, minutes: 0);
DayTime get interval => _interval;

// Time to next smoke
DayTime _timeToNext = DayTime(hours: 1, minutes: 0);
DayTime get timeToNext => _timeToNext;

// Percent to next
double _percentToNext = 0.75;
double get percentToNext => _percentToNext;

//-------------------------------- Process -----------------------------------
// Registered
ProcessState _processState = ProcessState.stopped;
set processState(ProcessState value){_processState = value;}
ProcessState get processState => _processState;

// Extra cigarettes count from begin
int extraCigarettesCount = 0;

// Get updates
void getUpdates(){
notifyListeners();
}

//-------------------------------  CALCULATES  -----------------------------------
// Calculate passed cigarettes
int getSavedCigarettes(){
double sum = 0;
for (var i = 0; i < _currentDay; i++){
sum += (i * _minusCigarettePerDay);
}
return sum.round();
}

// Current State Data
void calculates(){
// get current day
_currentDay = DateTime.now().difference(registrationDate).inDays;

    // Ones
    _minusCigarettePerDay = perDay.value / daysToSmokeBreak.value;
    _savedCigarettesPerDay = (_currentDay * _minusCigarettePerDay).floor();

    // Statistics
    _savedCigarettesFromBegin = getSavedCigarettes() - extraCigarettesCount;
    _savedMoney = (_savedCigarettesFromBegin * (price.value / 20)).round();
    _endOfSmoke = ((_currentDay / daysToSmokeBreak.value) * 100).round();

    _totalCigarettesToday = perDay.value - _savedCigarettesPerDay;

    // time between cigarette smoke
    _interval = (lastCigaretteTime - firstCigaretteTime) / (_totalCigarettesToday + 1);
    // now
    DateTime now = DateTime.now();
    DayTime timeNow = DayTime(hours: now.hour, minutes: now.minute);

    if ((firstCigaretteTime < timeNow)&&(timeNow < lastCigaretteTime)){
      _timeToNext = _interval * (((timeNow - firstCigaretteTime) ~/ _interval) + 1) - (timeNow - firstCigaretteTime);
      _percentToNext = _timeToNext.inMinutes() / _interval.inMinutes();
    }else{
      _timeToNext = firstCigaretteTime + DayTime.parse('24:00') - timeNow;
      _percentToNext = _timeToNext.inMinutes() / (firstCigaretteTime + DayTime.parse('24:00') - lastCigaretteTime).inMinutes();
    }
}

//-------------------------------------  DATA STATES  ----------------------------------------------

//------------------------------ Methods -------------------------------------
// Store user data
void startDataState(){
// store registration date
registrationDate = DateTime.now();
extraCigarettesCount = 0;
_processState = ProcessState.started;
}

// Reset all data
void resetDataState(){
_processState = ProcessState.stopped;
}

// CongratulationDataState
void congratulationDataState(){
_processState = ProcessState.ended;
}

