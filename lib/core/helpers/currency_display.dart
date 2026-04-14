import 'package:flutter/material.dart';
import 'package:mega_plus/l10n/app_localizations.dart';

/// Maps API currency codes (e.g. `EGP`) to the label for the current locale (EGP vs ج.م).
String displayCurrencyLabel(BuildContext context, String? currencyCode) {
  final raw = currencyCode?.trim();
  if (raw == null || raw.isEmpty) {
    return AppLocalizations.of(context)!.egp;
  }
  if (raw.toUpperCase() == 'EGP') {
    return AppLocalizations.of(context)!.egp;
  }
  return raw;
}
