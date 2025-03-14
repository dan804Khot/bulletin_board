import '../models/advertisement_model.dart';
import '../models/advertisement_form.dart';

abstract class AdCreator {
  Future<AdvertisementModel> createAd(AdvertisementForm form);
}
