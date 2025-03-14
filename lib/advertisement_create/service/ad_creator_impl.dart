import 'dart:convert';
import 'package:bulletin_board/advertisement_create/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ad_creator.dart';

class AdCreatorImpl implements AdCreator {
  @override
  Future<AdvertisementModel> createAd(AdvertisementForm form) async {
    String adId = DateTime.now().millisecondsSinceEpoch.toString();
    String? imageUrl;

    //конвертация изображения в base64
    if (form.image != null) {
      List<int> imageBytes = await form.image!.readAsBytes();
      imageUrl = base64Encode(imageBytes);
    }

    AdvertisementModel ad = AdvertisementModel(
      id: adId,
      title: form.title,
      description: form.description,
      category: form.category,
      price: form.price,
      name: form.name,
      phone: form.phone,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
    );

    //сохранение данных в Firebase
    await FirebaseFirestore.instance.collection('advertisements').doc(adId).set(ad.toMap());

    return ad;
  }
}
