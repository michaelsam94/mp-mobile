import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';

class LocaleCubit extends Cubit<Locale> {
  static const _cacheKey = 'app_locale';

  LocaleCubit() : super(_loadSavedLocale());

  static Locale _loadSavedLocale() {
    final saved = CacheHelper.getString(_cacheKey);
    if (saved == 'ar') return const Locale('ar');
    return const Locale('en');
  }

  static LocaleCubit get(BuildContext context) =>
      BlocProvider.of<LocaleCubit>(context);

  void setLocale(Locale locale) {
    CacheHelper.setString(_cacheKey, locale.languageCode);
    emit(locale);
  }

  void toggleLocale() {
    if (state.languageCode == 'en') {
      setLocale(const Locale('ar'));
    } else {
      setLocale(const Locale('en'));
    }
  }

  bool get isArabic => state.languageCode == 'ar';
}
