
class NotificationTrigger{
  bool _triggerValue = false;
  bool _isNotHandled = false;

  // Set trigger value
  set triggerValue (bool value){
    if (!_triggerValue && value){
      _isNotHandled = true;
    }
    _triggerValue = value;
  }

  // Event is not handled
  bool get isNotHandled => _isNotHandled;

  // Handle trigger event
  void handle(){
    _isNotHandled = false;
  }
}

