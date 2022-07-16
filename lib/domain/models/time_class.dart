class DayTime{
  // Constructor
  DayTime({this.hours = 0, this.minutes = 0});

  // Fields
  int hours = 0;
  int minutes = 0;

  // To Json
  Map<String, dynamic> toJson(){
    return {
      'hours' : hours,
      'minutes' : minutes
    };
  }

  // static From Json
  static DayTime fromJson(Map<String, dynamic> json){
    return DayTime(hours: json['hours'], minutes: json['minutes']);
  }

  // static From DateTime
  static DayTime fromDateTime(DateTime dateTime){
    return DayTime(hours: dateTime.hour, minutes: dateTime.minute);
  }

  // static From minutes
  static DayTime fromMinutes(int minutes){
    int hrs = minutes ~/ 60;
    int mns =minutes % 60;
    return DayTime(hours: hrs, minutes: mns);
  }

  // In Minutes
  int inMinutes(){
    return hours * 60 + minutes;
  }

  // DayTime a; DayTime b; int result = a ~/ b
  int operator ~/(DayTime interval){
    return inMinutes() ~/ interval.inMinutes();
  }

  // DayTime a; int divider; DayTime result = a / divider
  DayTime operator /(int divider){
    return DayTime.fromMinutes(inMinutes() ~/ divider);
  }

  // DayTime a; int divider; DayTime result = a * divider
  DayTime operator *(int divider){
    return DayTime.fromMinutes(inMinutes() * divider);
  }

  // DayTime a; DayTime b; DayTime result = a + b
  DayTime operator +(DayTime interval){
    return DayTime.fromMinutes(inMinutes() + interval.inMinutes());
  }

  // DayTime a; DayTime b; DayTime result = a - b
  DayTime operator -(DayTime interval){
    return DayTime.fromMinutes(inMinutes() - interval.inMinutes());
  }

  // DayTime a; DayTime b; DayTime result = a % b
  DayTime operator %(DayTime interval){
    return DayTime.fromMinutes(inMinutes() % interval.inMinutes());
  }


  // operator >
  bool operator >(DayTime time){
    return (inMinutes() > time.inMinutes());
  }

  // operator <
  bool operator <(DayTime time){
    return (inMinutes() < time.inMinutes());
  }

  // operator >=
  bool operator >=(DayTime time){
    return (inMinutes() >= time.inMinutes());
  }

  // operator <=
  bool operator <=(DayTime time){
    return (inMinutes() <= time.inMinutes());
  }

  // static Parse
  static DayTime parse(String timeString){
    final stringList = timeString.split(':');
    return DayTime(hours: int.parse(stringList[0]), minutes: int.parse(stringList[1]));
  }

  // To String
  @override
  String toString() {
    final m = '$minutes'.padLeft(2, '0');
    return '$hours:$m';
  }
}