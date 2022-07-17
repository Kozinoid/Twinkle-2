import 'package:twinkle/domain/models/main_data_model.dart';

abstract class TwinkleRepository{
  void storeData();
  void loadData();

  void storeProcessState();
  void loadProcessState();
}