@ECHO OFF

REM Windows substitution for the Makefile and make command.

setlocal enabledelayedexpansion

IF "%1"=="run_prod" (
	flutter run --flavor production
)

IF "%1"=="run_dev" (
	flutter run --flavor development
)

IF "%1"=="build_prod" (
	flutter build --flavor production
)

IF "%1"=="build_ios_dev" (
	flutter build ios --flavor development
)

IF "%1"=="build_apk_dev" (
	flutter build apk --flavor development
)

IF "%1"=="build_ios_prod" (
	flutter build ios --flavor production
)

IF "%1"=="build_apk_prod" (
	flutter build apk --flavor production
)

IF "%1"=="generate_locale" (
	call flutter pub pub run intl_translation:extract_to_arb --output-dir assets/i18n lib/services/localization.dart
	call flutter pub pub run bin/split_locales.dart
	DEL "assets\i18n\intl_messages.arb"
)

IF "%1"=="build_locale" (
	call flutter pub pub run bin/build_locales.dart
	SET "arbfiles="
	FOR %%a IN ("assets\i18n\intl_*.arb") DO @CALL SET "arbfiles=!arbfiles! %%a"
	call flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/locale --no-use-deferred-loading lib/services/localization.dart !arbfiles!
)

IF "%1"=="" (
	ECHO Usage: make ^<command^>
)