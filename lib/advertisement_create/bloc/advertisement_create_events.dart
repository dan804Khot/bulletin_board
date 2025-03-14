part of 'advertisement_create_bloc.dart';

abstract class AdvertisementCreateEvents {}

class AdvertisementCreateGetCategory extends AdvertisementCreateEvents {}

class AdvertisementCreateUpdateCategory extends AdvertisementCreateEvents {
  final CategoryModel? category; 
  AdvertisementCreateUpdateCategory(this.category);
}

class AdvertisementCreateUploadImage extends AdvertisementCreateEvents {
  final File image;
  AdvertisementCreateUploadImage(this.image);
}

class AdvertisementCreateUpdateData extends AdvertisementCreateEvents {}

class AdvertisementCreateCreate extends AdvertisementCreateEvents {
  final AdvertisementForm form;
  AdvertisementCreateCreate(this.form);
}

class AdvertisementCreateSubmit extends AdvertisementCreateEvents {
  final String title;
  final String description;
  final String name;
  final String phone;
  final String price;

  AdvertisementCreateSubmit({
    required this.title,
    required this.description,
    required this.name,
    required this.phone,
    required this.price,
  });
}
