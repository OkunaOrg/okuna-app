run_prod:
	flutter run --flavor production

run_dev:
	flutter run --flavor development

build_prod:
	flutter build --flavor production

build_ios_dev:
	flutter build ios --flavor development

build_apk_dev:
	flutter build apk --flavor development

build_ios_prod:
	flutter build ios --flavor production

build_apk_prod:
	flutter build apk --flavor production

generate_locale:
	flutter pub pub run intl_translation:extract_to_arb --output-dir assets/i18n lib/services/localization.dart
	node bin/splitLocales
	rm assets/i18n/intl_messages.arb

build_locale:
	node bin/buildLocales
	flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/locale --no-use-deferred-loading lib/services/localization.dart assets/i18n/intl_*.arb

upload_crowdin_locales:
    crowdin upload sources

download_crowdin_locales:
    crowdin download -l de
    crowdin download -l es-ES
    crowdin download -l fr
    crowdin download -l it
    crowdin download -l pt-BR
    crowdin download -l sv-SE
    crowdin download -l tr

