import 'dart:io';

import 'package:bulletin_board/advertisement_create/models/advertisement_form.dart';
import 'package:bulletin_board/advertisement_create/models/category_model.dart';
import 'package:bulletin_board/advertisement_create/service/ad_creator.dart';
import 'package:bulletin_board/advertisement_create/service/category_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advertisement_create_state.dart';
part 'advertisement_create_events.dart';

class AdvertisementCreateBloc extends Bloc<AdvertisementCreateEvents, AdvertisementCreateState> {
  final AdCreator adCreator;
  final CategoryService categoryService;

  AdvertisementCreateBloc({required this.adCreator, required this.categoryService})
      : super(AdvertisementCreateLoading()) {
    on<AdvertisementCreateGetCategory>(_onGetCategories);
    on<AdvertisementCreateUploadImage>(_onUploadImage);
    on<AdvertisementCreateUpdateData>(_onUpdateData);
    on<AdvertisementCreateCreate>(_onCreateAd);
    on<AdvertisementCreateUpdateCategory>(_onUpdateCategory);
    on<AdvertisementCreateSubmit>(_onSubmit); 
  }

  Future<void> _onGetCategories(
    AdvertisementCreateGetCategory event, 
    Emitter<AdvertisementCreateState> emit,
  ) async {
    if (state is! AdvertisementCreateInitial) {
      try {
        final categories = await categoryService.fetchCategories();
        final selectedCategory = categories.isNotEmpty ? categories.first : null;
        emit(AdvertisementCreateInitial(categories, selectedCategory: selectedCategory));
      } catch (e) {
        emit(AdvertisementCreateError('Ошибка загрузки категорий: $e'));
      }
    }
  }

  void _onUploadImage(
    AdvertisementCreateUploadImage event, 
    Emitter<AdvertisementCreateState> emit,
  ) {
    if (state is AdvertisementCreateInitial) {
      final currentState = state as AdvertisementCreateInitial;
      emit(AdvertisementCreateInitial(
        currentState.categories,
        selectedCategory: currentState.selectedCategory,
        image: event.image,
      ));
    }
  }

  void _onUpdateData(
    AdvertisementCreateUpdateData event, 
    Emitter<AdvertisementCreateState> emit,
  ) {
    if (state is AdvertisementCreateInitial) {
      final currentState = state as AdvertisementCreateInitial;
      emit(AdvertisementCreateInitial(
        currentState.categories,
        selectedCategory: currentState.selectedCategory,
        image: currentState.image,
      ));
    }
  }

  Future<void> _onCreateAd(
    AdvertisementCreateCreate event, 
    Emitter<AdvertisementCreateState> emit,
  ) async {
    try {
      await adCreator.createAd(event.form);
      emit(AdvertisementCreateCreated());
    } catch (e) {
      emit(AdvertisementCreateError('Ошибка создания объявления: $e'));
    }
  }

  void _onUpdateCategory(
    AdvertisementCreateUpdateCategory event, 
    Emitter<AdvertisementCreateState> emit,
  ) {
    if (state is AdvertisementCreateInitial) {
      final currentState = state as AdvertisementCreateInitial;
      emit(AdvertisementCreateInitial(
        currentState.categories,
        selectedCategory: event.category,
        image: currentState.image,
      ));
    }
  }

  void _onSubmit(
  AdvertisementCreateSubmit event,
  Emitter<AdvertisementCreateState> emit,
) {
  if (state is AdvertisementCreateInitial) {
    final currentState = state as AdvertisementCreateInitial;

    if (currentState.selectedCategory == null) {
      emit(AdvertisementCreateError('Ошибка: выберите категорию.'));
      return;
    }

    final adForm = AdvertisementForm(
      title: event.title,
      description: event.description,
      category: currentState.selectedCategory!, 
      price: event.price,
      name: event.name,
      phone: event.phone,
      image: currentState.image,
    );

    emit(AdvertisementCreateInitial(
      currentState.categories,
      selectedCategory: currentState.selectedCategory,
      image: currentState.image,
    ));

    add(AdvertisementCreateCreate(adForm));
  }
}

}