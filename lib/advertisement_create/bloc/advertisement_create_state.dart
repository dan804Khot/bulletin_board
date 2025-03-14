part of 'advertisement_create_bloc.dart';

abstract class AdvertisementCreateState {}

class AdvertisementCreateLoading extends AdvertisementCreateState {}

class AdvertisementCreateInitial extends AdvertisementCreateState {
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;

  AdvertisementCreateInitial(this.categories, {this.selectedCategory}); 
}


class AdvertisementCreateUpdated extends AdvertisementCreateState {}

class AdvertisementCreateImagePicked extends AdvertisementCreateState {
  final File image;
  AdvertisementCreateImagePicked(this.image);
}

class AdvertisementCreateError extends AdvertisementCreateState {
  final String message;
  AdvertisementCreateError(this.message);
}

class AdvertisementCreateCreated extends AdvertisementCreateState {}
