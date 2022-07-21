// Notification Trigger
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

// Notification dual trigger
class NotificationDualTrigger{
  final NotificationTrigger _innerTrigger = NotificationTrigger();
  final NotificationTrigger _outerTrigger = NotificationTrigger();

  // Set trigger value
  set triggerValue (bool value){
    _innerTrigger.triggerValue = value;
    _outerTrigger.triggerValue = value;
  }
  // Inner Event is not handled
  bool get innerIsNotHandled => _innerTrigger.isNotHandled;

  // Outer Event is not handled
  bool get outerIsNotHandled => _outerTrigger.isNotHandled;

  // Inner Handle trigger event
  void innerHandle(){
    _innerTrigger.handle();
  }

  // Outer Handle trigger event
  void outerHandle(){
    _outerTrigger.handle();
  }
}
