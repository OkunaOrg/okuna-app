// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a sv locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'sv';

  static m0(minLength, maxLength) => "(${minLength}-${maxLength} tecken)";

  static m1(minLength, maxLength) =>
      "Beskrivningen måste vara mellan ${minLength} och ${maxLength} tecken.";

  static m2(minLength, maxLength) =>
      "Namnet måste vara mellan ${minLength} och ${maxLength} tecken.";

  static m3(minLength, maxLength) =>
      "Lösenordet måste vara mellan ${minLength} och ${maxLength} tecken.";

  static m4(maxLength) =>
      "Ett användarnamn kan inte vara längre än ${maxLength} tecken.";

  static m5(maxLength) =>
      "Adjektiv får inte vara längre än ${maxLength} tecken.";

  static m6(username) =>
      "Är du säker på att du vill lägga till @${username} som administratör för gemenskapen?";

  static m7(username) => "Är du säker på att du vill banna @${username}?";

  static m8(maxLength) =>
      "Beskrivningen kan inte vara längre än ${maxLength} tecken.";

  static m9(username) =>
      "Är du säker på att du vill lägga till @${username} som gemenskapsmoderator?";

  static m10(maxLength) =>
      "Namnet får inte vara längre än ${maxLength} tecken.";

  static m11(min) => "Du måste välja åtminstone ${min} kategorier.";

  static m12(min) => "Du måste välja åtminstone ${min} kategori.";

  static m13(max) => "Välj upp till ${max} kategorier";

  static m14(maxLength) =>
      "Reglerna får inte vara längre än ${maxLength} tecken.";

  static m15(takenName) => "Gemenskapsnamnet \'${takenName}\' är upptaget";

  static m16(maxLength) =>
      "Titeln får inte vara längre än ${maxLength} tecken.";

  static m17(categoryName) => "Trendiga i ${categoryName}";

  static m18(currentUserLanguage) => "Språk (${currentUserLanguage})";

  static m19(resourceCount, resourceName) =>
      "Visa alla ${resourceCount} ${resourceName}";

  static m20(postCommentText) =>
      "[name] [username] kommenterade också: ${postCommentText}";

  static m21(postCommentText) =>
      "[name] [username] kommenterade på ditt inlägg: ${postCommentText}";

  static m22(postCommentText) =>
      "[name] [username] svarade också: ${postCommentText}";

  static m23(postCommentText) =>
      "[name] [username] svarade: ${postCommentText}";

  static m24(communityName) =>
      "[name] [username] har bjudit in dig till gemenskapen c/${communityName}.";

  static m25(maxLength) =>
      "En kommentar kan inte vara längre än ${maxLength} tecken.";

  static m26(commentsCount) => "Visa alla ${commentsCount} kommentarer";

  static m27(circlesSearchQuery) =>
      "Inga kretsar hittades som matchar \'${circlesSearchQuery}\'.";

  static m28(name) => "${name} har inte delat något ännu.";

  static m29(postCreatorUsername) => "@${postCreatorUsername}s kretsar";

  static m30(maxLength) =>
      "Kretsens namn får inte vara längre än ${maxLength} tecken.";

  static m31(prettyUsersCount) => "${prettyUsersCount} personer";

  static m32(username) => "Är du säker på att du vill blockera @${username}?";

  static m33(userName) => "Bekräfta ${userName}s kontaktförfrågan";

  static m34(userName) => "Lägg till ${userName} som kontakt";

  static m35(userName) => "Ta bort ${userName} som kontakt";

  static m36(limit) => "Bilden är för stor (gräns: ${limit} MB)";

  static m37(username) => "Användarnamnet @${username} är upptaget";

  static m38(searchQuery) =>
      "Ingen emoji hittades som matchar \'${searchQuery}\'.";

  static m39(searchQuery) => "Inga listor hittades för \'${searchQuery}\'";

  static m40(prettyUsersCount) => "${prettyUsersCount} konton";

  static m41(prettyUsersCount) => "${prettyUsersCount} Konton";

  static m42(groupName) => "Visa alla ${groupName}";

  static m43(iosLink, androidLink, inviteLink) =>
      "Hej, jag vill bjuda in dig till Somus. Först, ladda ner appen från iTunes (${iosLink}) eller Play Store (${androidLink}). Sedan klistrar du in din personliga inbjudningslänk i \'Registrera dig\'-formuläret i Somus-appen: ${inviteLink}";

  static m44(username) => "Gick med under användarnamnet @${username}";

  static m45(email) => "Väntande, inbjudan skickad till ${email}";

  static m46(maxLength) =>
      "Listans namn får inte vara längre än ${maxLength} tecken.";

  static m47(maxLength) => "Bion kan inte vara längre än ${maxLength} tecken.";

  static m48(maxLength) =>
      "En plats kan inte vara längre än ${maxLength} tecken.";

  static m49(takenConnectionsCircleName) =>
      "Kretsnamnet \'${takenConnectionsCircleName}\' är upptaget";

  static m50(listName) => "Listnamnet \'${listName}\' är upptaget";

  static m51(searchQuery) => "Inga resultat hittades för \'${searchQuery}\'.";

  static m52(resourcePluralName) => "Inga ${resourcePluralName} hittades.";

  static m53(resourcePluralName) => "Sök ${resourcePluralName} ...";

  static m54(searchQuery) =>
      "Inga gemenskaper hittades för \'${searchQuery}\'.";

  static m55(searchQuery) => "Inga resultat hittades för \'${searchQuery}\'.";

  static m56(searchQuery) => "Inga användare hittades för \'${searchQuery}\'.";

  static m57(searchQuery) => "Söker efter \'${searchQuery}\'";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "auth__change_password_current_pwd":
            MessageLookupByLibrary.simpleMessage("Nuvarande lösenord"),
        "auth__change_password_current_pwd_hint":
            MessageLookupByLibrary.simpleMessage(
                "Ange ditt nuvarande lösenord"),
        "auth__change_password_current_pwd_incorrect":
            MessageLookupByLibrary.simpleMessage(
                "Det angivna lösenordet var felaktigt"),
        "auth__change_password_new_pwd":
            MessageLookupByLibrary.simpleMessage("Nytt lösenord"),
        "auth__change_password_new_pwd_error": MessageLookupByLibrary.simpleMessage(
            "Vänligen se till att lösenordet är mellan 10 och 100 tecken långt"),
        "auth__change_password_new_pwd_hint":
            MessageLookupByLibrary.simpleMessage("Ange ditt nya lösenord"),
        "auth__change_password_save_success":
            MessageLookupByLibrary.simpleMessage(
                "Allt klart! Ditt lösenord har uppdaterats"),
        "auth__change_password_save_text":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "auth__change_password_title":
            MessageLookupByLibrary.simpleMessage("Ändra lösenord"),
        "auth__create_acc__almost_there":
            MessageLookupByLibrary.simpleMessage("Nästan klart..."),
        "auth__create_acc__are_you_legal_age":
            MessageLookupByLibrary.simpleMessage("Är du äldre än 16 år?"),
        "auth__create_acc__avatar_choose_camera":
            MessageLookupByLibrary.simpleMessage("Ta ett foto"),
        "auth__create_acc__avatar_choose_gallery":
            MessageLookupByLibrary.simpleMessage("Använd ett existerande foto"),
        "auth__create_acc__avatar_remove_photo":
            MessageLookupByLibrary.simpleMessage("Ta bort foto"),
        "auth__create_acc__avatar_tap_to_change":
            MessageLookupByLibrary.simpleMessage("Tryck för att ändra"),
        "auth__create_acc__can_change_username":
            MessageLookupByLibrary.simpleMessage(
                "Om du vill så kan du ändra det när som helst från din profilsida."),
        "auth__create_acc__congratulations":
            MessageLookupByLibrary.simpleMessage("Gratulerar!"),
        "auth__create_acc__create_account":
            MessageLookupByLibrary.simpleMessage("Skapa konto"),
        "auth__create_acc__done":
            MessageLookupByLibrary.simpleMessage("Skapa konto"),
        "auth__create_acc__done_continue":
            MessageLookupByLibrary.simpleMessage("Logga in"),
        "auth__create_acc__done_created": MessageLookupByLibrary.simpleMessage(
            "Ditt konto har skapats med användarnamnet "),
        "auth__create_acc__done_description":
            MessageLookupByLibrary.simpleMessage("Ditt konto har skapats."),
        "auth__create_acc__done_subtext": MessageLookupByLibrary.simpleMessage(
            "Du kan ändra detta i dina profilinställningar."),
        "auth__create_acc__done_title":
            MessageLookupByLibrary.simpleMessage("Hurra!"),
        "auth__create_acc__email_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "😱 Du måste ange en e-postadress"),
        "auth__create_acc__email_invalid_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Vänligen ange en giltig e-postadress."),
        "auth__create_acc__email_placeholder":
            MessageLookupByLibrary.simpleMessage("john_travolta@mail.com"),
        "auth__create_acc__email_server_error":
            MessageLookupByLibrary.simpleMessage(
                "😭 Vi har serverproblem, vänligen försök igen om några minuter."),
        "auth__create_acc__email_taken_error":
            MessageLookupByLibrary.simpleMessage(
                "🤔 Det finns redan ett konto med den e-postadressen."),
        "auth__create_acc__lets_get_started":
            MessageLookupByLibrary.simpleMessage("Låt oss komma igång"),
        "auth__create_acc__link_empty_error":
            MessageLookupByLibrary.simpleMessage("Du måste ange en länk."),
        "auth__create_acc__link_invalid_error":
            MessageLookupByLibrary.simpleMessage("Länken verkar vara ogiltig."),
        "auth__create_acc__name_characters_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Ett namn kan bara innehålla alfanumeriska tecken (för tillfället)."),
        "auth__create_acc__name_empty_error":
            MessageLookupByLibrary.simpleMessage("😱 Du måste ange ett namn."),
        "auth__create_acc__name_length_error": MessageLookupByLibrary.simpleMessage(
            "😱 Ditt namn får inte vara längre än 50 tecken. (Vi är ledsna om det är det.)"),
        "auth__create_acc__name_placeholder":
            MessageLookupByLibrary.simpleMessage("James Bond"),
        "auth__create_acc__next": MessageLookupByLibrary.simpleMessage("Nästa"),
        "auth__create_acc__one_last_thing":
            MessageLookupByLibrary.simpleMessage("En sista sak..."),
        "auth__create_acc__password_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "😱 Du måste ange ett lösenord"),
        "auth__create_acc__password_length_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Ett lösenord måste vara mellan 8 och 64 tecken."),
        "auth__create_acc__paste_link": MessageLookupByLibrary.simpleMessage(
            "Klistra in din registreringslänk nedan"),
        "auth__create_acc__paste_link_help_text":
            MessageLookupByLibrary.simpleMessage(
                "Använd länken från Join Somus-knappen i din inbjudan."),
        "auth__create_acc__paste_password_reset_link":
            MessageLookupByLibrary.simpleMessage(
                "Klistra in din lösenordsåterställningslänk nedan"),
        "auth__create_acc__previous":
            MessageLookupByLibrary.simpleMessage("Tillbaka"),
        "auth__create_acc__register":
            MessageLookupByLibrary.simpleMessage("Registrera"),
        "auth__create_acc__request_invite":
            MessageLookupByLibrary.simpleMessage(
                "Ingen inbjudan? Be om en här."),
        "auth__create_acc__submit_error_desc_server":
            MessageLookupByLibrary.simpleMessage(
                "😭 Vi har serverproblem, vänligen försök igen om några minuter."),
        "auth__create_acc__submit_error_desc_validation":
            MessageLookupByLibrary.simpleMessage(
                "😅 Det ser ut som att en del av informationen var felaktig, vänligen kontrollera den och försök igen."),
        "auth__create_acc__submit_error_title":
            MessageLookupByLibrary.simpleMessage("Åh, nej..."),
        "auth__create_acc__submit_loading_desc":
            MessageLookupByLibrary.simpleMessage("Vi skapar ditt konto."),
        "auth__create_acc__submit_loading_title":
            MessageLookupByLibrary.simpleMessage("Håll ut!"),
        "auth__create_acc__subscribe":
            MessageLookupByLibrary.simpleMessage("Begär"),
        "auth__create_acc__subscribe_to_waitlist_text":
            MessageLookupByLibrary.simpleMessage("Be om en inbjudan!"),
        "auth__create_acc__username_characters_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Ett användarnamn kan bara innehålla alfanumeriska tecken och understreck."),
        "auth__create_acc__username_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "😱 Du måste ange ett användarnamn."),
        "auth__create_acc__username_length_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Ett användarnamn kan inte vara längre än 30 tecken."),
        "auth__create_acc__username_placeholder":
            MessageLookupByLibrary.simpleMessage("pablopicasso"),
        "auth__create_acc__username_server_error":
            MessageLookupByLibrary.simpleMessage(
                "😭 Vi har serverproblem, vänligen försök igen om några minuter."),
        "auth__create_acc__username_taken_error":
            MessageLookupByLibrary.simpleMessage(
                "😩 Användarnamnet @%s är upptaget."),
        "auth__create_acc__welcome_to_beta":
            MessageLookupByLibrary.simpleMessage("Välkommen till betan!"),
        "auth__create_acc__what_avatar":
            MessageLookupByLibrary.simpleMessage("Välj en profilbild"),
        "auth__create_acc__what_email":
            MessageLookupByLibrary.simpleMessage("Vad är din e-post?"),
        "auth__create_acc__what_name":
            MessageLookupByLibrary.simpleMessage("Vad heter du?"),
        "auth__create_acc__what_password":
            MessageLookupByLibrary.simpleMessage("Välj ett lösenord"),
        "auth__create_acc__what_password_subtext":
            MessageLookupByLibrary.simpleMessage("(minst 10 tecken)"),
        "auth__create_acc__what_username":
            MessageLookupByLibrary.simpleMessage("Välj ett användarnamn"),
        "auth__create_acc__your_subscribed":
            MessageLookupByLibrary.simpleMessage("Du är {0} på väntelistan."),
        "auth__create_acc__your_username_is":
            MessageLookupByLibrary.simpleMessage("Ditt användarnamn är "),
        "auth__create_acc_password_hint_text": m0,
        "auth__create_account":
            MessageLookupByLibrary.simpleMessage("Registrera dig"),
        "auth__description_empty_error": MessageLookupByLibrary.simpleMessage(
            "Du måste skriva en beskrivning."),
        "auth__description_range_error": m1,
        "auth__email_empty_error": MessageLookupByLibrary.simpleMessage(
            "Du måste ange en e-postadress."),
        "auth__email_invalid_error": MessageLookupByLibrary.simpleMessage(
            "Vänligen ange en giltig e-postadress."),
        "auth__headline":
            MessageLookupByLibrary.simpleMessage("Bättre socialt."),
        "auth__login": MessageLookupByLibrary.simpleMessage("Logga in"),
        "auth__login__connection_error": MessageLookupByLibrary.simpleMessage(
            "Vi kan inte nå våra servrar. Är du uppkopplad mot internet?"),
        "auth__login__credentials_mismatch_error":
            MessageLookupByLibrary.simpleMessage(
                "De angivna uppgifterna matchar inte."),
        "auth__login__email_label":
            MessageLookupByLibrary.simpleMessage("E-postadress"),
        "auth__login__forgot_password":
            MessageLookupByLibrary.simpleMessage("Glömt lösenordet"),
        "auth__login__forgot_password_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Ange ditt användarnamn eller e-postadress"),
        "auth__login__login": MessageLookupByLibrary.simpleMessage("Fortsätt"),
        "auth__login__or_text": MessageLookupByLibrary.simpleMessage("Eller"),
        "auth__login__password_empty_error":
            MessageLookupByLibrary.simpleMessage("Ett lösenord krävs."),
        "auth__login__password_label":
            MessageLookupByLibrary.simpleMessage("Lösenord"),
        "auth__login__password_length_error":
            MessageLookupByLibrary.simpleMessage(
                "Lösenordet måste vara mellan 8 och 64 tecken."),
        "auth__login__previous":
            MessageLookupByLibrary.simpleMessage("Tillbaka"),
        "auth__login__server_error": MessageLookupByLibrary.simpleMessage(
            "Åh nej.. Vi har serverproblem. Vänligen försök igen om några minuter."),
        "auth__login__subtitle": MessageLookupByLibrary.simpleMessage(
            "Ange dina inloggningsuppgifter för att fortsätta."),
        "auth__login__title":
            MessageLookupByLibrary.simpleMessage("Välkommen tillbaka!"),
        "auth__login__username_characters_error":
            MessageLookupByLibrary.simpleMessage(
                "Användarnamnet kan bara innehålla alfanumeriska tecken och understreck."),
        "auth__login__username_empty_error":
            MessageLookupByLibrary.simpleMessage("Ett användarnamn krävs."),
        "auth__login__username_label":
            MessageLookupByLibrary.simpleMessage("Användarnamn"),
        "auth__login__username_length_error":
            MessageLookupByLibrary.simpleMessage(
                "Användarnamnet kan inte vara längre än 30 tecken."),
        "auth__name_empty_error":
            MessageLookupByLibrary.simpleMessage("Du måste ange ett namn."),
        "auth__name_range_error": m2,
        "auth__password_empty_error":
            MessageLookupByLibrary.simpleMessage("Du måste ange ett lösenord."),
        "auth__password_range_error": m3,
        "auth__reset_password_success_info":
            MessageLookupByLibrary.simpleMessage(
                "Ditt lösenord har uppdaterats"),
        "auth__reset_password_success_title":
            MessageLookupByLibrary.simpleMessage("Allt klart!"),
        "auth__username_characters_error": MessageLookupByLibrary.simpleMessage(
            "Ett användarnamn kan bara innehålla alfanumeriska tecken och understreck."),
        "auth__username_empty_error": MessageLookupByLibrary.simpleMessage(
            "Du måste ange ett användarnamn."),
        "auth__username_maxlength_error": m4,
        "community__about": MessageLookupByLibrary.simpleMessage("Om"),
        "community__actions_invite_people_title":
            MessageLookupByLibrary.simpleMessage(
                "Bjud in folk till gemenskapen"),
        "community__actions_manage_text":
            MessageLookupByLibrary.simpleMessage("Hantera"),
        "community__add_administrators_title":
            MessageLookupByLibrary.simpleMessage("Lägg till administratör."),
        "community__add_moderator_title":
            MessageLookupByLibrary.simpleMessage("Lägg till moderator"),
        "community__adjectives_range_error": m5,
        "community__admin_add_confirmation": m6,
        "community__admin_desc": MessageLookupByLibrary.simpleMessage(
            "Detta kommer tillåta medlemmen att redigera gemenskapens information, administratörer, moderatorer och bannade användare."),
        "community__administrated_communities":
            MessageLookupByLibrary.simpleMessage("administrerade gemenskaper"),
        "community__administrated_community":
            MessageLookupByLibrary.simpleMessage("administrerad gemenskap"),
        "community__administrated_title":
            MessageLookupByLibrary.simpleMessage("Administrerade"),
        "community__administrator_plural":
            MessageLookupByLibrary.simpleMessage("administratörer"),
        "community__administrator_text":
            MessageLookupByLibrary.simpleMessage("administratör"),
        "community__administrator_you":
            MessageLookupByLibrary.simpleMessage("Du"),
        "community__administrators_title":
            MessageLookupByLibrary.simpleMessage("Administratörer"),
        "community__ban_confirmation": m7,
        "community__ban_desc": MessageLookupByLibrary.simpleMessage(
            "Detta kommer ta bort användaren från gemenskapen och hindra dem från att gå med igen."),
        "community__ban_user_title":
            MessageLookupByLibrary.simpleMessage("Banna användare"),
        "community__banned_user_text":
            MessageLookupByLibrary.simpleMessage("bannad användare"),
        "community__banned_users_text":
            MessageLookupByLibrary.simpleMessage("bannade användare"),
        "community__banned_users_title":
            MessageLookupByLibrary.simpleMessage("Bannade användare"),
        "community__button_rules":
            MessageLookupByLibrary.simpleMessage("Regler"),
        "community__button_staff":
            MessageLookupByLibrary.simpleMessage("Personal"),
        "community__categories":
            MessageLookupByLibrary.simpleMessage("kategorier."),
        "community__category":
            MessageLookupByLibrary.simpleMessage("kategori."),
        "community__communities":
            MessageLookupByLibrary.simpleMessage("gemenskaper"),
        "community__communities_all_text":
            MessageLookupByLibrary.simpleMessage("Alla"),
        "community__communities_no_category_found":
            MessageLookupByLibrary.simpleMessage(
                "Inga kategorier hittades. Vänligen försök igen om några minuter."),
        "community__communities_refresh_text":
            MessageLookupByLibrary.simpleMessage("Uppdatera"),
        "community__communities_title":
            MessageLookupByLibrary.simpleMessage("Gemenskaper"),
        "community__community":
            MessageLookupByLibrary.simpleMessage("gemenskap"),
        "community__community_members":
            MessageLookupByLibrary.simpleMessage("Gemenskapens medlemmar"),
        "community__community_staff":
            MessageLookupByLibrary.simpleMessage("Gemenskapens personal"),
        "community__confirmation_title":
            MessageLookupByLibrary.simpleMessage("Bekräftelse"),
        "community__delete_confirmation": MessageLookupByLibrary.simpleMessage(
            "Är du säker på att du vill ta bort gemenskapen?"),
        "community__delete_desc": MessageLookupByLibrary.simpleMessage(
            "Du kommer inte se dess inlägg i din tidslinje eller kunna skapa nya inlägg i den längre."),
        "community__description_range_error": m8,
        "community__favorite_action": MessageLookupByLibrary.simpleMessage(
            "Markera gemenskap som favorit"),
        "community__favorite_communities":
            MessageLookupByLibrary.simpleMessage("favoritgemenskaper"),
        "community__favorite_community":
            MessageLookupByLibrary.simpleMessage("favoritgemenskap"),
        "community__favorites_title":
            MessageLookupByLibrary.simpleMessage("Favoriter"),
        "community__invite_to_community_resource_plural":
            MessageLookupByLibrary.simpleMessage("kontakter och följare"),
        "community__invite_to_community_resource_singular":
            MessageLookupByLibrary.simpleMessage("kontakt eller följare"),
        "community__invite_to_community_title":
            MessageLookupByLibrary.simpleMessage("Bjud in till gemenskapen"),
        "community__invited_by_member": MessageLookupByLibrary.simpleMessage(
            "Du måste bli inbjuden av en medlem."),
        "community__invited_by_moderator": MessageLookupByLibrary.simpleMessage(
            "Du måste bli inbjuden av en moderator."),
        "community__is_private": MessageLookupByLibrary.simpleMessage(
            "Den här gemenskapen är privat."),
        "community__join_communities_desc": MessageLookupByLibrary.simpleMessage(
            "Gå med i gemenskaper för att se den här fliken komma till liv!"),
        "community__join_community":
            MessageLookupByLibrary.simpleMessage("Gå med"),
        "community__joined_communities":
            MessageLookupByLibrary.simpleMessage("gemenskaper du är medlem i"),
        "community__joined_community":
            MessageLookupByLibrary.simpleMessage("gemenskap du är medlem i"),
        "community__joined_title":
            MessageLookupByLibrary.simpleMessage("Medlem i"),
        "community__leave_community":
            MessageLookupByLibrary.simpleMessage("Lämna"),
        "community__leave_confirmation": MessageLookupByLibrary.simpleMessage(
            "Är du säker på att du vill lämna gemenskapen?"),
        "community__leave_desc": MessageLookupByLibrary.simpleMessage(
            "Du kommer inte se dess inlägg i din tidslinje eller kunna skapa nya inlägg i den längre."),
        "community__manage_add_favourite": MessageLookupByLibrary.simpleMessage(
            "Lägg till gemenskapen bland dina favoriter"),
        "community__manage_admins_desc": MessageLookupByLibrary.simpleMessage(
            "Se, lägg till och ta bort administratörer."),
        "community__manage_admins_title":
            MessageLookupByLibrary.simpleMessage("Administratörer"),
        "community__manage_banned_desc": MessageLookupByLibrary.simpleMessage(
            "Se, lägg till och ta bort bannade användare."),
        "community__manage_banned_title":
            MessageLookupByLibrary.simpleMessage("Bannade användare"),
        "community__manage_closed_posts_desc":
            MessageLookupByLibrary.simpleMessage(
                "Se och hantera stängda inlägg"),
        "community__manage_closed_posts_title":
            MessageLookupByLibrary.simpleMessage("Stängda inlägg"),
        "community__manage_delete_desc": MessageLookupByLibrary.simpleMessage(
            "Ta bort gemenskapen, för alltid."),
        "community__manage_delete_title":
            MessageLookupByLibrary.simpleMessage("Ta bort gemenskapen"),
        "community__manage_details_desc": MessageLookupByLibrary.simpleMessage(
            "Ändra titel, namn, avatar, omslagsfoto och mer."),
        "community__manage_details_title":
            MessageLookupByLibrary.simpleMessage("Detaljer"),
        "community__manage_invite_desc": MessageLookupByLibrary.simpleMessage(
            "Bjud in dina kontakter och följare till gemenskapen."),
        "community__manage_invite_title":
            MessageLookupByLibrary.simpleMessage("Bjud in folk"),
        "community__manage_leave_desc":
            MessageLookupByLibrary.simpleMessage("Lämna gemenskapen."),
        "community__manage_leave_title":
            MessageLookupByLibrary.simpleMessage("Lämna gemenskapen"),
        "community__manage_mod_reports_desc":
            MessageLookupByLibrary.simpleMessage(
                "Granska gemenskapens anmälningar."),
        "community__manage_mod_reports_title":
            MessageLookupByLibrary.simpleMessage("Anmälningar"),
        "community__manage_mods_desc": MessageLookupByLibrary.simpleMessage(
            "Se, lägg till och ta bort moderatorer."),
        "community__manage_mods_title":
            MessageLookupByLibrary.simpleMessage("Moderatorer"),
        "community__manage_remove_favourite":
            MessageLookupByLibrary.simpleMessage(
                "Ta bort gemenskapen från dina favoriter"),
        "community__manage_title":
            MessageLookupByLibrary.simpleMessage("Hantera gemenskap"),
        "community__member": MessageLookupByLibrary.simpleMessage("medlem"),
        "community__member_capitalized":
            MessageLookupByLibrary.simpleMessage("Medlem"),
        "community__member_plural":
            MessageLookupByLibrary.simpleMessage("medlemmar"),
        "community__members_capitalized":
            MessageLookupByLibrary.simpleMessage("Medlemmar"),
        "community__moderated_communities":
            MessageLookupByLibrary.simpleMessage("modererade gemenskaper"),
        "community__moderated_community":
            MessageLookupByLibrary.simpleMessage("modererad gemenskap"),
        "community__moderated_title":
            MessageLookupByLibrary.simpleMessage("Modererade"),
        "community__moderator_add_confirmation": m9,
        "community__moderator_desc": MessageLookupByLibrary.simpleMessage(
            "Detta kommer tillåta medlemmen att redigera gemenskapens information, moderatorer och bannade användare."),
        "community__moderator_resource_name":
            MessageLookupByLibrary.simpleMessage("moderator"),
        "community__moderators_resource_name":
            MessageLookupByLibrary.simpleMessage("moderatorer"),
        "community__moderators_title":
            MessageLookupByLibrary.simpleMessage("Moderatorer"),
        "community__moderators_you": MessageLookupByLibrary.simpleMessage("Du"),
        "community__name_characters_error": MessageLookupByLibrary.simpleMessage(
            "Ett namn kan bara innehålla alfanumeriska tecken och understreck."),
        "community__name_empty_error":
            MessageLookupByLibrary.simpleMessage("Du måste ange ett namn."),
        "community__name_range_error": m10,
        "community__no": MessageLookupByLibrary.simpleMessage("Nej"),
        "community__pick_atleast_min_categories": m11,
        "community__pick_atleast_min_category": m12,
        "community__pick_upto_max": m13,
        "community__post_plural":
            MessageLookupByLibrary.simpleMessage("inlägg"),
        "community__post_singular":
            MessageLookupByLibrary.simpleMessage("inlägg"),
        "community__posts": MessageLookupByLibrary.simpleMessage("Inlägg"),
        "community__refresh_text":
            MessageLookupByLibrary.simpleMessage("Uppdatera"),
        "community__refreshing":
            MessageLookupByLibrary.simpleMessage("Uppdaterar gemenskap"),
        "community__rules_empty_error": MessageLookupByLibrary.simpleMessage(
            "Regelfältet kan inte vara tomt."),
        "community__rules_range_error": m14,
        "community__rules_text": MessageLookupByLibrary.simpleMessage("Regler"),
        "community__rules_title":
            MessageLookupByLibrary.simpleMessage("Gemenskapens regler"),
        "community__save_community_create_community":
            MessageLookupByLibrary.simpleMessage("Skapa gemenskap"),
        "community__save_community_create_text":
            MessageLookupByLibrary.simpleMessage("Skapa"),
        "community__save_community_edit_community":
            MessageLookupByLibrary.simpleMessage("Redigera gemenskap"),
        "community__save_community_label_title":
            MessageLookupByLibrary.simpleMessage("Titel"),
        "community__save_community_label_title_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "t. ex. Resor, Fotografering, Datorspel."),
        "community__save_community_name_category":
            MessageLookupByLibrary.simpleMessage("Kategori"),
        "community__save_community_name_label_color":
            MessageLookupByLibrary.simpleMessage("Färg"),
        "community__save_community_name_label_color_hint_text":
            MessageLookupByLibrary.simpleMessage("(Tryck för att ändra)"),
        "community__save_community_name_label_desc_optional":
            MessageLookupByLibrary.simpleMessage("Beskrivning · Valfri"),
        "community__save_community_name_label_desc_optional_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "Vad handlar din gemenskap om?"),
        "community__save_community_name_label_member_adjective":
            MessageLookupByLibrary.simpleMessage("Medlem-adjektiv · Valfritt"),
        "community__save_community_name_label_member_adjective_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "t. ex. resenär, fotograf, gamer."),
        "community__save_community_name_label_members_adjective":
            MessageLookupByLibrary.simpleMessage(
                "Medlemmar-adjektiv · Valfritt"),
        "community__save_community_name_label_members_adjective_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "t. ex. resenärer, fotografer, gamers."),
        "community__save_community_name_label_rules_optional":
            MessageLookupByLibrary.simpleMessage("Regler · Valfritt"),
        "community__save_community_name_label_rules_optional_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "Finns det något som du vill att dina användare känner till?"),
        "community__save_community_name_label_type":
            MessageLookupByLibrary.simpleMessage("Typ"),
        "community__save_community_name_label_type_hint_text":
            MessageLookupByLibrary.simpleMessage("(Tryck för att ändra)"),
        "community__save_community_name_member_invites":
            MessageLookupByLibrary.simpleMessage("Medlemsinbjudningar"),
        "community__save_community_name_member_invites_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Medlemmar kan bjuda in folk till gemenskapen"),
        "community__save_community_name_taken": m15,
        "community__save_community_name_title":
            MessageLookupByLibrary.simpleMessage("Namn"),
        "community__save_community_name_title_hint_text":
            MessageLookupByLibrary.simpleMessage(
                " t. ex. resor, fotografering, datorspel."),
        "community__save_community_save_text":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "community__title_empty_error":
            MessageLookupByLibrary.simpleMessage("Du måste ange en titel."),
        "community__title_range_error": m16,
        "community__trending_in_all": MessageLookupByLibrary.simpleMessage(
            "Trendiga från alla kategorier"),
        "community__trending_in_category": m17,
        "community__trending_none_found": MessageLookupByLibrary.simpleMessage(
            "Inga trendiga gemenskaper hittades. Försök igen om några minuter."),
        "community__trending_refresh":
            MessageLookupByLibrary.simpleMessage("Uppdatera"),
        "community__type_private":
            MessageLookupByLibrary.simpleMessage("Privat"),
        "community__type_public":
            MessageLookupByLibrary.simpleMessage("Offentlig"),
        "community__unfavorite_action": MessageLookupByLibrary.simpleMessage(
            "Ta bort gemenskap från favoriter"),
        "community__user_you_text": MessageLookupByLibrary.simpleMessage("Du"),
        "community__yes": MessageLookupByLibrary.simpleMessage("Ja"),
        "drawer__account_settings":
            MessageLookupByLibrary.simpleMessage("Kontoinställningar"),
        "drawer__account_settings_blocked_users":
            MessageLookupByLibrary.simpleMessage("Blockerade användare"),
        "drawer__account_settings_change_email":
            MessageLookupByLibrary.simpleMessage("Ändra e-post"),
        "drawer__account_settings_change_password":
            MessageLookupByLibrary.simpleMessage("Ändra lösenord"),
        "drawer__account_settings_delete_account":
            MessageLookupByLibrary.simpleMessage("Ta bort konto"),
        "drawer__account_settings_language": m18,
        "drawer__account_settings_language_text":
            MessageLookupByLibrary.simpleMessage("Språk"),
        "drawer__account_settings_notifications":
            MessageLookupByLibrary.simpleMessage("Aviseringar"),
        "drawer__app_account_text":
            MessageLookupByLibrary.simpleMessage("App & Konto"),
        "drawer__application_settings":
            MessageLookupByLibrary.simpleMessage("Programinställningar"),
        "drawer__connections":
            MessageLookupByLibrary.simpleMessage("Mina kontakter"),
        "drawer__customize": MessageLookupByLibrary.simpleMessage("Anpassa"),
        "drawer__global_moderation":
            MessageLookupByLibrary.simpleMessage("Global moderering"),
        "drawer__help":
            MessageLookupByLibrary.simpleMessage("Hjälp och feedback"),
        "drawer__lists": MessageLookupByLibrary.simpleMessage("Mina listor"),
        "drawer__logout": MessageLookupByLibrary.simpleMessage("Logga ut"),
        "drawer__main_title":
            MessageLookupByLibrary.simpleMessage("Mitt Somus"),
        "drawer__menu_title": MessageLookupByLibrary.simpleMessage("Meny"),
        "drawer__my_circles":
            MessageLookupByLibrary.simpleMessage("Mina cirklar"),
        "drawer__my_followers":
            MessageLookupByLibrary.simpleMessage("Mina följare"),
        "drawer__my_following":
            MessageLookupByLibrary.simpleMessage("Mitt följande"),
        "drawer__my_invites":
            MessageLookupByLibrary.simpleMessage("Mina inbjudningar"),
        "drawer__my_lists": MessageLookupByLibrary.simpleMessage("Mina listor"),
        "drawer__my_mod_penalties":
            MessageLookupByLibrary.simpleMessage("Mina modereringsstraff"),
        "drawer__my_pending_mod_tasks": MessageLookupByLibrary.simpleMessage(
            "Mina väntande modereringsuppgifter"),
        "drawer__profile": MessageLookupByLibrary.simpleMessage("Profil"),
        "drawer__settings":
            MessageLookupByLibrary.simpleMessage("Inställningar"),
        "drawer__themes": MessageLookupByLibrary.simpleMessage("Teman"),
        "drawer__useful_links_guidelines":
            MessageLookupByLibrary.simpleMessage("Somuss riktlinjer"),
        "drawer__useful_links_guidelines_bug_tracker":
            MessageLookupByLibrary.simpleMessage("Felrapportering"),
        "drawer__useful_links_guidelines_bug_tracker_desc":
            MessageLookupByLibrary.simpleMessage(
                "Rapportera ett fel eller rösta för existerande rapporter"),
        "drawer__useful_links_guidelines_desc":
            MessageLookupByLibrary.simpleMessage(
                "Riktlinjerna vi alla förväntas att följa för en hälsosam och vänlig samvaro."),
        "drawer__useful_links_guidelines_feature_requests":
            MessageLookupByLibrary.simpleMessage("Funktionsförslag"),
        "drawer__useful_links_guidelines_feature_requests_desc":
            MessageLookupByLibrary.simpleMessage(
                "Föreslå en ny funktion eller rösta för existerande förslag"),
        "drawer__useful_links_guidelines_github":
            MessageLookupByLibrary.simpleMessage("Projekttavla på Github"),
        "drawer__useful_links_guidelines_github_desc":
            MessageLookupByLibrary.simpleMessage(
                "Ta en titt på vad vi arbetar på just nu"),
        "drawer__useful_links_guidelines_handbook":
            MessageLookupByLibrary.simpleMessage("Somuss handbok"),
        "drawer__useful_links_guidelines_handbook_desc":
            MessageLookupByLibrary.simpleMessage(
                "En bok med allt du behöver veta om att använda plattformen"),
        "drawer__useful_links_slack_channel":
            MessageLookupByLibrary.simpleMessage("Gemenskapens Slack-kanal"),
        "drawer__useful_links_slack_channel_desc":
            MessageLookupByLibrary.simpleMessage(
                "En plats för diskussioner om allt om Somus"),
        "drawer__useful_links_support":
            MessageLookupByLibrary.simpleMessage("Stöd Somus"),
        "drawer__useful_links_support_desc":
            MessageLookupByLibrary.simpleMessage(
                "Hitta ett sätt på vilket du kan hjälpa oss under vår resa!"),
        "drawer__useful_links_title":
            MessageLookupByLibrary.simpleMessage("Användbara länkar"),
        "error__no_internet_connection":
            MessageLookupByLibrary.simpleMessage("Ingen internetuppkoppling"),
        "error__unknown_error":
            MessageLookupByLibrary.simpleMessage("Okänt fel"),
        "moderation__actions_chat_with_team":
            MessageLookupByLibrary.simpleMessage("Chatta med teamet"),
        "moderation__actions_review":
            MessageLookupByLibrary.simpleMessage("Granska"),
        "moderation__category_text":
            MessageLookupByLibrary.simpleMessage("Kategori"),
        "moderation__community_moderated_objects":
            MessageLookupByLibrary.simpleMessage(
                "Gemenskapens modererade objekt"),
        "moderation__community_review_approve":
            MessageLookupByLibrary.simpleMessage("Godkänn"),
        "moderation__community_review_item_verified":
            MessageLookupByLibrary.simpleMessage(
                "Den här anmälan har verifierats"),
        "moderation__community_review_object":
            MessageLookupByLibrary.simpleMessage("Objekt"),
        "moderation__community_review_reject":
            MessageLookupByLibrary.simpleMessage("avvisa"),
        "moderation__community_review_title":
            MessageLookupByLibrary.simpleMessage("Granska modererat objekt"),
        "moderation__confirm_report_community_reported":
            MessageLookupByLibrary.simpleMessage("Gemenskap anmäld"),
        "moderation__confirm_report_item_reported":
            MessageLookupByLibrary.simpleMessage("Objekt anmält"),
        "moderation__confirm_report_post_comment_reported":
            MessageLookupByLibrary.simpleMessage("Inläggskommentar anmäld"),
        "moderation__confirm_report_post_reported":
            MessageLookupByLibrary.simpleMessage("Inlägg anmält"),
        "moderation__confirm_report_provide_details":
            MessageLookupByLibrary.simpleMessage(
                "Kan du delge extra information som kan vara relevant för anmälan?"),
        "moderation__confirm_report_provide_happen_next":
            MessageLookupByLibrary.simpleMessage("Detta kommer hända härnäst:"),
        "moderation__confirm_report_provide_happen_next_desc":
            MessageLookupByLibrary.simpleMessage(
                "- Din anmälan skickas in anonymt.\n- Om du anmäler ett inlägg eller en kommentar så kommer anmälan skickas till Somuss personal och, om tillämpligt, gemenskapens moderatorer, och inlägget kommer döljas från ditt flöde.\n- Om du anmäler ett konto eller en gemenskap kommer anmälan skickas till Somuss personal.\n- Vi granskar anmälan och om den godkänns kommer innehållet tas bort och straff utmätas till de som är inblandade, från tillfällig avstängning till borttagning av konto beroende på hur allvarlig överträdelsen var.\n- Om anmälan bedöms vara gjord för att försöka skada en annan medlem eller gemenskap på plattformen utan att den angivna överträdelsen har skett kommer straff istället utmätas mot dig. \n"),
        "moderation__confirm_report_provide_optional_hint_text":
            MessageLookupByLibrary.simpleMessage("Skriv här..."),
        "moderation__confirm_report_provide_optional_info":
            MessageLookupByLibrary.simpleMessage("(Valfritt)"),
        "moderation__confirm_report_submit":
            MessageLookupByLibrary.simpleMessage("Jag förstår, skicka."),
        "moderation__confirm_report_title":
            MessageLookupByLibrary.simpleMessage("Skicka anmälan"),
        "moderation__confirm_report_user_reported":
            MessageLookupByLibrary.simpleMessage("Användare anmäld"),
        "moderation__description_text":
            MessageLookupByLibrary.simpleMessage("Beskrivning"),
        "moderation__filters_apply":
            MessageLookupByLibrary.simpleMessage("Applicera filter"),
        "moderation__filters_other":
            MessageLookupByLibrary.simpleMessage("Övrigt"),
        "moderation__filters_reset":
            MessageLookupByLibrary.simpleMessage("Återställ"),
        "moderation__filters_status":
            MessageLookupByLibrary.simpleMessage("Status"),
        "moderation__filters_title":
            MessageLookupByLibrary.simpleMessage("Modereringsfilter"),
        "moderation__filters_type": MessageLookupByLibrary.simpleMessage("Typ"),
        "moderation__filters_verified":
            MessageLookupByLibrary.simpleMessage("Verifierad"),
        "moderation__global_review_object_text":
            MessageLookupByLibrary.simpleMessage("Objekt"),
        "moderation__global_review_title":
            MessageLookupByLibrary.simpleMessage("Granska modererat objekt"),
        "moderation__global_review_unverify_text":
            MessageLookupByLibrary.simpleMessage("Av-verifiera"),
        "moderation__global_review_verify_text":
            MessageLookupByLibrary.simpleMessage("Verifiera"),
        "moderation__globally_moderated_objects":
            MessageLookupByLibrary.simpleMessage("Globalt modererade objekt"),
        "moderation__moderated_object_false_text":
            MessageLookupByLibrary.simpleMessage("Falskt"),
        "moderation__moderated_object_reports_count":
            MessageLookupByLibrary.simpleMessage("Antal anmälningar"),
        "moderation__moderated_object_status":
            MessageLookupByLibrary.simpleMessage("Status"),
        "moderation__moderated_object_title":
            MessageLookupByLibrary.simpleMessage("Objekt"),
        "moderation__moderated_object_true_text":
            MessageLookupByLibrary.simpleMessage("Sant"),
        "moderation__moderated_object_verified":
            MessageLookupByLibrary.simpleMessage("Verifierad"),
        "moderation__moderated_object_verified_by_staff":
            MessageLookupByLibrary.simpleMessage(
                "Verifierad av Somuss personal"),
        "moderation__my_moderation_penalties_resouce_singular":
            MessageLookupByLibrary.simpleMessage("modereringsstraff"),
        "moderation__my_moderation_penalties_resource_plural":
            MessageLookupByLibrary.simpleMessage("modereringsstraff"),
        "moderation__my_moderation_penalties_title":
            MessageLookupByLibrary.simpleMessage("Modereringsstraff"),
        "moderation__my_moderation_tasks_title":
            MessageLookupByLibrary.simpleMessage(
                "Väntande modereringsuppgifter"),
        "moderation__no_description_text":
            MessageLookupByLibrary.simpleMessage("Ingen beskrivning"),
        "moderation__object_status_title":
            MessageLookupByLibrary.simpleMessage("Status"),
        "moderation__pending_moderation_tasks_plural":
            MessageLookupByLibrary.simpleMessage(
                "väntande modereringsuppgifter"),
        "moderation__pending_moderation_tasks_singular":
            MessageLookupByLibrary.simpleMessage("väntande modereringsuppgift"),
        "moderation__report_account_text":
            MessageLookupByLibrary.simpleMessage("Anmäl konto"),
        "moderation__report_comment_text":
            MessageLookupByLibrary.simpleMessage("Anmäl kommentar"),
        "moderation__report_community_text":
            MessageLookupByLibrary.simpleMessage("Anmäl gemenskap"),
        "moderation__report_post_text":
            MessageLookupByLibrary.simpleMessage("Anmäl inlägg"),
        "moderation__reporter_text":
            MessageLookupByLibrary.simpleMessage("Anmälare"),
        "moderation__reports_preview_resource_reports":
            MessageLookupByLibrary.simpleMessage("anmälningar"),
        "moderation__reports_preview_title":
            MessageLookupByLibrary.simpleMessage("Anmälningar"),
        "moderation__reports_see_all": m19,
        "moderation__tap_to_retry": MessageLookupByLibrary.simpleMessage(
            "Tryck för att försöka läsa in poster igen"),
        "moderation__update_category_save":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "moderation__update_category_title":
            MessageLookupByLibrary.simpleMessage("Uppdatera kategori"),
        "moderation__update_description_report_desc":
            MessageLookupByLibrary.simpleMessage("Anmäl beskrivning"),
        "moderation__update_description_report_hint_text":
            MessageLookupByLibrary.simpleMessage("t. ex. anmälan var..."),
        "moderation__update_description_save":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "moderation__update_description_title":
            MessageLookupByLibrary.simpleMessage("Redigera beskrivning"),
        "moderation__update_status_save":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "moderation__update_status_title":
            MessageLookupByLibrary.simpleMessage("Uppdatera status"),
        "moderation__you_have_reported_account_text":
            MessageLookupByLibrary.simpleMessage(
                "Du har anmält det här kontot"),
        "moderation__you_have_reported_comment_text":
            MessageLookupByLibrary.simpleMessage(
                "Du har anmält den här kommentaren"),
        "moderation__you_have_reported_community_text":
            MessageLookupByLibrary.simpleMessage(
                "Du har anmält den här gemenskapen"),
        "moderation__you_have_reported_post_text":
            MessageLookupByLibrary.simpleMessage(
                "Du har anmält det här inlägget"),
        "notifications__accepted_connection_request_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] accepterade din kontaktförfrågan."),
        "notifications__comment_comment_notification_tile_user_also_commented":
            m20,
        "notifications__comment_comment_notification_tile_user_commented": m21,
        "notifications__comment_desc": MessageLookupByLibrary.simpleMessage(
            "Bli meddelad när någon kommenterar på ett av dina inlägg eller ett inlägg du också kommenterat på."),
        "notifications__comment_reaction_desc":
            MessageLookupByLibrary.simpleMessage(
                "Bli meddelad när någon reagerar på en av dina inläggskommentarer."),
        "notifications__comment_reaction_title":
            MessageLookupByLibrary.simpleMessage("Reaktion på kommentar"),
        "notifications__comment_reply_desc": MessageLookupByLibrary.simpleMessage(
            "Bli meddelad när någon svarar på en av dina kommentarer eller en kommentar du också svarat på."),
        "notifications__comment_reply_notification_tile_user_also_replied": m22,
        "notifications__comment_reply_notification_tile_user_replied": m23,
        "notifications__comment_reply_title":
            MessageLookupByLibrary.simpleMessage("Svar på kommentar på inlägg"),
        "notifications__comment_title":
            MessageLookupByLibrary.simpleMessage("Kommentar på inlägg"),
        "notifications__community_invite_desc":
            MessageLookupByLibrary.simpleMessage(
                "Bli meddelad när någon bjuder in dig till en gemenskap."),
        "notifications__community_invite_title":
            MessageLookupByLibrary.simpleMessage("Gemenskapsinbjudan"),
        "notifications__connection_desc": MessageLookupByLibrary.simpleMessage(
            "Bli meddelad när någon vill ha dig som kontakt"),
        "notifications__connection_request_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] vill knyta kontakt med dig."),
        "notifications__connection_title":
            MessageLookupByLibrary.simpleMessage("Kontaktförfrågan"),
        "notifications__follow_desc": MessageLookupByLibrary.simpleMessage(
            "Bli meddelad när någon börjar följa dig"),
        "notifications__follow_title":
            MessageLookupByLibrary.simpleMessage("Följare"),
        "notifications__following_you_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] har börjat följa dig."),
        "notifications__general_desc": MessageLookupByLibrary.simpleMessage(
            "Bli meddelad när något händer"),
        "notifications__general_title":
            MessageLookupByLibrary.simpleMessage("Aviseringar"),
        "notifications__mute_post_turn_off_post_comment_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Inaktivera aviseringar för inläggskommentarer"),
        "notifications__mute_post_turn_off_post_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Inaktivera aviseringar för inlägg"),
        "notifications__mute_post_turn_on_post_comment_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Aktivera aviseringar för inläggskommentarer"),
        "notifications__mute_post_turn_on_post_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Aktivera aviseringar för inlägg"),
        "notifications__post_reaction_desc":
            MessageLookupByLibrary.simpleMessage(
                "Bli meddelad när någon reagerar på ett av dina inlägg."),
        "notifications__post_reaction_title":
            MessageLookupByLibrary.simpleMessage("Reaktion på inlägg"),
        "notifications__reacted_to_post_comment_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] reagerade på din inläggskommentar."),
        "notifications__reacted_to_post_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] reagerade på ditt inlägg."),
        "notifications__settings_title":
            MessageLookupByLibrary.simpleMessage("Aviseringsinställningar"),
        "notifications__user_community_invite_tile": m24,
        "post__action_comment":
            MessageLookupByLibrary.simpleMessage("Kommentera"),
        "post__action_react": MessageLookupByLibrary.simpleMessage("Reagera"),
        "post__action_reply": MessageLookupByLibrary.simpleMessage("Svara"),
        "post__actions_comment_deleted":
            MessageLookupByLibrary.simpleMessage("Kommentar borttagen"),
        "post__actions_delete":
            MessageLookupByLibrary.simpleMessage("Ta bort inlägg"),
        "post__actions_delete_comment":
            MessageLookupByLibrary.simpleMessage("Ta bort kommentar"),
        "post__actions_deleted":
            MessageLookupByLibrary.simpleMessage("Inlägg borttaget"),
        "post__actions_edit_comment":
            MessageLookupByLibrary.simpleMessage("Redigera kommentar"),
        "post__actions_report_text":
            MessageLookupByLibrary.simpleMessage("Anmäl"),
        "post__actions_reported_text":
            MessageLookupByLibrary.simpleMessage("Anmäld"),
        "post__actions_show_more_text":
            MessageLookupByLibrary.simpleMessage("Visa mer"),
        "post__close_post":
            MessageLookupByLibrary.simpleMessage("Stäng inlägg"),
        "post__comment_maxlength_error": m25,
        "post__comment_reply_expanded_post":
            MessageLookupByLibrary.simpleMessage("Skicka"),
        "post__comment_reply_expanded_reply_comment":
            MessageLookupByLibrary.simpleMessage("Svar på kommentar"),
        "post__comment_reply_expanded_reply_hint_text":
            MessageLookupByLibrary.simpleMessage("Ditt svar..."),
        "post__comment_required_error": MessageLookupByLibrary.simpleMessage(
            "Kommentaren kan inte vara tom."),
        "post__commenter_expanded_edit_comment":
            MessageLookupByLibrary.simpleMessage("Redigera kommentar"),
        "post__commenter_expanded_join_conversation":
            MessageLookupByLibrary.simpleMessage("Gå med i konversationen..."),
        "post__commenter_expanded_save":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "post__commenter_expanded_start_conversation":
            MessageLookupByLibrary.simpleMessage("Starta en konversation..."),
        "post__commenter_post_text":
            MessageLookupByLibrary.simpleMessage("Skicka"),
        "post__commenter_write_something":
            MessageLookupByLibrary.simpleMessage("Skriv något..."),
        "post__comments_closed_post":
            MessageLookupByLibrary.simpleMessage("Stängt inlägg"),
        "post__comments_disabled":
            MessageLookupByLibrary.simpleMessage("Kommentarsfältet avstängt"),
        "post__comments_disabled_message": MessageLookupByLibrary.simpleMessage(
            "Kommentarer inaktiverade för inlägget"),
        "post__comments_enabled_message": MessageLookupByLibrary.simpleMessage(
            "Kommentarer aktiverade för inlägget"),
        "post__comments_header_be_the_first_comments":
            MessageLookupByLibrary.simpleMessage(
                "Bli den första som skriver en kommentar"),
        "post__comments_header_be_the_first_replies":
            MessageLookupByLibrary.simpleMessage(
                "Bli den första som skriver ett svar"),
        "post__comments_header_newer":
            MessageLookupByLibrary.simpleMessage("Senare"),
        "post__comments_header_newest_comments":
            MessageLookupByLibrary.simpleMessage("Senaste kommentarerna"),
        "post__comments_header_newest_replies":
            MessageLookupByLibrary.simpleMessage("Senaste svaren"),
        "post__comments_header_older":
            MessageLookupByLibrary.simpleMessage("Äldre"),
        "post__comments_header_oldest_comments":
            MessageLookupByLibrary.simpleMessage("Äldsta kommentarerna"),
        "post__comments_header_oldest_replies":
            MessageLookupByLibrary.simpleMessage("Äldsta svaren"),
        "post__comments_header_see_newest_comments":
            MessageLookupByLibrary.simpleMessage(
                "Visa de senaste kommentarerna"),
        "post__comments_header_see_newest_replies":
            MessageLookupByLibrary.simpleMessage("Visa de senaste svaren"),
        "post__comments_header_see_oldest_comments":
            MessageLookupByLibrary.simpleMessage(
                "Visa de äldsta kommentarerna"),
        "post__comments_header_see_oldest_replies":
            MessageLookupByLibrary.simpleMessage("Visa de äldsta svaren"),
        "post__comments_header_view_newest_comments":
            MessageLookupByLibrary.simpleMessage(
                "Visa de senaste kommentarerna"),
        "post__comments_header_view_newest_replies":
            MessageLookupByLibrary.simpleMessage("Visa de senaste svaren"),
        "post__comments_header_view_oldest_comments":
            MessageLookupByLibrary.simpleMessage(
                "Visa de äldsta kommentarerna"),
        "post__comments_header_view_oldest_replies":
            MessageLookupByLibrary.simpleMessage("Visa de äldsta svaren"),
        "post__comments_page_no_more_replies_to_load":
            MessageLookupByLibrary.simpleMessage("Inga fler svar att läsa in"),
        "post__comments_page_no_more_to_load":
            MessageLookupByLibrary.simpleMessage(
                "Inga fler kommentarer att läsa in"),
        "post__comments_page_replies_title":
            MessageLookupByLibrary.simpleMessage("Inläggssvar"),
        "post__comments_page_tap_to_retry":
            MessageLookupByLibrary.simpleMessage(
                "Tryck för att försöka läsa in kommentarerna igen."),
        "post__comments_page_tap_to_retry_replies":
            MessageLookupByLibrary.simpleMessage(
                "Tryck för att försöka läsa in svaren igen."),
        "post__comments_page_title":
            MessageLookupByLibrary.simpleMessage("Inläggskommentarer"),
        "post__comments_view_all_comments": m26,
        "post__create_new": MessageLookupByLibrary.simpleMessage("Nytt inlägg"),
        "post__create_next": MessageLookupByLibrary.simpleMessage("Nästa"),
        "post__create_photo": MessageLookupByLibrary.simpleMessage("Foto"),
        "post__disable_post_comments":
            MessageLookupByLibrary.simpleMessage("Stäng kommentarsfältet"),
        "post__edit_save": MessageLookupByLibrary.simpleMessage("Spara"),
        "post__edit_title":
            MessageLookupByLibrary.simpleMessage("Redigera inlägg"),
        "post__enable_post_comments":
            MessageLookupByLibrary.simpleMessage("Öppna kommentarsfältet"),
        "post__have_not_shared_anything": MessageLookupByLibrary.simpleMessage(
            "Du har inte delat något ännu."),
        "post__is_closed":
            MessageLookupByLibrary.simpleMessage("Stängt inlägg"),
        "post__my_circles":
            MessageLookupByLibrary.simpleMessage("Mina kretsar"),
        "post__my_circles_desc": MessageLookupByLibrary.simpleMessage(
            "Dela inlägget med en eller flera av dina kretsar."),
        "post__no_circles_for": m27,
        "post__open_post": MessageLookupByLibrary.simpleMessage("Öppna inlägg"),
        "post__post_closed":
            MessageLookupByLibrary.simpleMessage("Inlägg stängt "),
        "post__post_opened":
            MessageLookupByLibrary.simpleMessage("Inlägg öppnat"),
        "post__post_reactions_title":
            MessageLookupByLibrary.simpleMessage("Reaktioner på inlägget"),
        "post__profile_counts_follower":
            MessageLookupByLibrary.simpleMessage(" Följare"),
        "post__profile_counts_followers":
            MessageLookupByLibrary.simpleMessage(" Följare"),
        "post__profile_counts_following":
            MessageLookupByLibrary.simpleMessage(" Följer"),
        "post__profile_counts_post":
            MessageLookupByLibrary.simpleMessage(" Inlägg"),
        "post__profile_counts_posts":
            MessageLookupByLibrary.simpleMessage(" Inlägg"),
        "post__reaction_list_tap_retry": MessageLookupByLibrary.simpleMessage(
            "Tryck för att försöka läsa in reaktionerna igen."),
        "post__search_circles":
            MessageLookupByLibrary.simpleMessage("Sök kretsar..."),
        "post__share": MessageLookupByLibrary.simpleMessage("Dela"),
        "post__share_community": MessageLookupByLibrary.simpleMessage("Dela"),
        "post__share_community_desc": MessageLookupByLibrary.simpleMessage(
            "Dela inlägget med en gemenskap du är del av."),
        "post__share_community_title":
            MessageLookupByLibrary.simpleMessage("En gemenskap"),
        "post__share_to": MessageLookupByLibrary.simpleMessage("Dela med"),
        "post__share_to_circles":
            MessageLookupByLibrary.simpleMessage("Dela med kretsar"),
        "post__share_to_community":
            MessageLookupByLibrary.simpleMessage("Dela med en gemenskap"),
        "post__shared_privately_on":
            MessageLookupByLibrary.simpleMessage("Delat privat i"),
        "post__sharing_post_to":
            MessageLookupByLibrary.simpleMessage("Delar inlägg med"),
        "post__text_copied":
            MessageLookupByLibrary.simpleMessage("Text kopierad!"),
        "post__time_short_days": MessageLookupByLibrary.simpleMessage("d"),
        "post__time_short_hours": MessageLookupByLibrary.simpleMessage("h"),
        "post__time_short_minutes": MessageLookupByLibrary.simpleMessage("m"),
        "post__time_short_now_text": MessageLookupByLibrary.simpleMessage("nu"),
        "post__time_short_one_day": MessageLookupByLibrary.simpleMessage("1d"),
        "post__time_short_one_hour": MessageLookupByLibrary.simpleMessage("1h"),
        "post__time_short_one_minute":
            MessageLookupByLibrary.simpleMessage("1m"),
        "post__time_short_one_week": MessageLookupByLibrary.simpleMessage("1v"),
        "post__time_short_one_year": MessageLookupByLibrary.simpleMessage("1å"),
        "post__time_short_seconds": MessageLookupByLibrary.simpleMessage("s"),
        "post__time_short_weeks": MessageLookupByLibrary.simpleMessage("v"),
        "post__time_short_years": MessageLookupByLibrary.simpleMessage("å"),
        "post__timeline_posts_all_loaded":
            MessageLookupByLibrary.simpleMessage("🎉 Alla inlägg inlästa"),
        "post__timeline_posts_default_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Försök läsa in tidslinjen igen."),
        "post__timeline_posts_default_drhoo_title":
            MessageLookupByLibrary.simpleMessage(
                "Det är något som inte stämmer."),
        "post__timeline_posts_failed_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Försök igen om några sekunder"),
        "post__timeline_posts_failed_drhoo_title":
            MessageLookupByLibrary.simpleMessage(
                "Din tidslinje kunde inte läsas in."),
        "post__timeline_posts_no_more_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Följ användare eller gå med i en gemenskap för att komma igång!"),
        "post__timeline_posts_no_more_drhoo_title":
            MessageLookupByLibrary.simpleMessage("Din tidslinje är tom."),
        "post__timeline_posts_refresh_posts":
            MessageLookupByLibrary.simpleMessage("Läs in inlägg"),
        "post__timeline_posts_refreshing_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage("Läser in din tidslinje."),
        "post__timeline_posts_refreshing_drhoo_title":
            MessageLookupByLibrary.simpleMessage("Håll ut!"),
        "post__trending_posts_no_trending_posts":
            MessageLookupByLibrary.simpleMessage(
                "Det finns inga trendiga inlägg. Försök uppdatera om några sekunder."),
        "post__trending_posts_refresh":
            MessageLookupByLibrary.simpleMessage("Uppdatera"),
        "post__trending_posts_title":
            MessageLookupByLibrary.simpleMessage("Trendiga inlägg"),
        "post__user_has_not_shared_anything": m28,
        "post__usernames_circles": m29,
        "post__world_circle_name":
            MessageLookupByLibrary.simpleMessage("Världen"),
        "post__you_shared_with":
            MessageLookupByLibrary.simpleMessage("Du delade med"),
        "user__add_account_done": MessageLookupByLibrary.simpleMessage("Klar"),
        "user__add_account_save": MessageLookupByLibrary.simpleMessage("Spara"),
        "user__add_account_success":
            MessageLookupByLibrary.simpleMessage("Kontot lades till"),
        "user__add_account_to_lists":
            MessageLookupByLibrary.simpleMessage("Lägg till konto i lista"),
        "user__add_account_update_account_lists":
            MessageLookupByLibrary.simpleMessage("Uppdatera kontolistor"),
        "user__add_account_update_lists":
            MessageLookupByLibrary.simpleMessage("Uppdatera listor"),
        "user__billion_postfix": MessageLookupByLibrary.simpleMessage("md"),
        "user__block_user":
            MessageLookupByLibrary.simpleMessage("Blockera användare"),
        "user__change_email_email_text":
            MessageLookupByLibrary.simpleMessage("E-post"),
        "user__change_email_error": MessageLookupByLibrary.simpleMessage(
            "E-postadressen är redan registrerad"),
        "user__change_email_hint_text":
            MessageLookupByLibrary.simpleMessage("Ange din nya e-postadress"),
        "user__change_email_save":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "user__change_email_success_info": MessageLookupByLibrary.simpleMessage(
            "Vi har skickat en bekräftelselänk till din nya e-postadress, klicka på den för att verifiera din nya e-post"),
        "user__change_email_title":
            MessageLookupByLibrary.simpleMessage("Ändra e-postadress"),
        "user__circle_name_empty_error": MessageLookupByLibrary.simpleMessage(
            "Du måste ge kretsen ett namn."),
        "user__circle_name_range_error": m30,
        "user__circle_peoples_count": m31,
        "user__clear_app_preferences_cleared_successfully":
            MessageLookupByLibrary.simpleMessage("Inställningarna har rensats"),
        "user__clear_app_preferences_desc": MessageLookupByLibrary.simpleMessage(
            "Rensa applikationsinställningarna. Just nu är detta enbart den föredragna kommentarsordningen."),
        "user__clear_app_preferences_error":
            MessageLookupByLibrary.simpleMessage(
                "Inställningarna kunde inte rensas"),
        "user__clear_app_preferences_title":
            MessageLookupByLibrary.simpleMessage("Rensa inställningar"),
        "user__clear_application_cache_desc":
            MessageLookupByLibrary.simpleMessage(
                "Rensa cachelagrade inlägg, konton, bilder & mer."),
        "user__clear_application_cache_failure":
            MessageLookupByLibrary.simpleMessage(
                "Kunde inte rensa cacheminnet"),
        "user__clear_application_cache_success":
            MessageLookupByLibrary.simpleMessage("Cacheminnet har rensats"),
        "user__clear_application_cache_text":
            MessageLookupByLibrary.simpleMessage("Rensa cacheminnet"),
        "user__confirm_block_user_blocked":
            MessageLookupByLibrary.simpleMessage("Användare blockerad."),
        "user__confirm_block_user_info": MessageLookupByLibrary.simpleMessage(
            "Ni kommer inte kunna se varandras inlägg eller kunna interagera med varandra."),
        "user__confirm_block_user_no":
            MessageLookupByLibrary.simpleMessage("Nej"),
        "user__confirm_block_user_question": m32,
        "user__confirm_block_user_title":
            MessageLookupByLibrary.simpleMessage("Bekräftelse"),
        "user__confirm_block_user_yes":
            MessageLookupByLibrary.simpleMessage("Ja"),
        "user__confirm_connection_add_connection":
            MessageLookupByLibrary.simpleMessage("Lägg till kontakt i krets"),
        "user__confirm_connection_confirm_text":
            MessageLookupByLibrary.simpleMessage("Bekräfta"),
        "user__confirm_connection_connection_confirmed":
            MessageLookupByLibrary.simpleMessage("Kontaktförfrågan bekräftad"),
        "user__confirm_connection_with": m33,
        "user__confirm_guidelines_reject_chat_community":
            MessageLookupByLibrary.simpleMessage("Chatta med gemenskapen."),
        "user__confirm_guidelines_reject_chat_immediately":
            MessageLookupByLibrary.simpleMessage("Starta en chat direkt."),
        "user__confirm_guidelines_reject_chat_with_team":
            MessageLookupByLibrary.simpleMessage("Chatta med teamet."),
        "user__confirm_guidelines_reject_delete_account":
            MessageLookupByLibrary.simpleMessage("Ta bort konto"),
        "user__confirm_guidelines_reject_go_back":
            MessageLookupByLibrary.simpleMessage("Tillbaka"),
        "user__confirm_guidelines_reject_info":
            MessageLookupByLibrary.simpleMessage(
                "Du kan inte använda Somus förrän du har godkänt riktlinjerna."),
        "user__confirm_guidelines_reject_join_slack":
            MessageLookupByLibrary.simpleMessage("Gå med i Slack-kanalen."),
        "user__confirm_guidelines_reject_title":
            MessageLookupByLibrary.simpleMessage("Avvisande av riktlinjer"),
        "user__connect_to_user_add_connection":
            MessageLookupByLibrary.simpleMessage("Lägg till kontakt i krets"),
        "user__connect_to_user_connect_with_username": m34,
        "user__connect_to_user_done":
            MessageLookupByLibrary.simpleMessage("Klar"),
        "user__connect_to_user_request_sent":
            MessageLookupByLibrary.simpleMessage("Kontaktförfrågan skickad"),
        "user__connection_circle_edit":
            MessageLookupByLibrary.simpleMessage("Redigera"),
        "user__connection_pending":
            MessageLookupByLibrary.simpleMessage("Väntande"),
        "user__connections_circle_delete":
            MessageLookupByLibrary.simpleMessage("Ta bort"),
        "user__connections_header_circle_desc":
            MessageLookupByLibrary.simpleMessage(
                "Kretsen alla dina kontakter läggs till i."),
        "user__connections_header_users":
            MessageLookupByLibrary.simpleMessage("Användare"),
        "user__delete_account_confirmation_desc":
            MessageLookupByLibrary.simpleMessage(
                "Är du säker på att du vill ta bort ditt konto?"),
        "user__delete_account_confirmation_desc_info":
            MessageLookupByLibrary.simpleMessage(
                "Detta är permanent och kan inte ångras senare."),
        "user__delete_account_confirmation_goodbye":
            MessageLookupByLibrary.simpleMessage("Hej då 😢"),
        "user__delete_account_confirmation_no":
            MessageLookupByLibrary.simpleMessage("Nej"),
        "user__delete_account_confirmation_title":
            MessageLookupByLibrary.simpleMessage("Bekräftelse"),
        "user__delete_account_confirmation_yes":
            MessageLookupByLibrary.simpleMessage("Ja"),
        "user__delete_account_current_pwd":
            MessageLookupByLibrary.simpleMessage("Nuvarande lösenord"),
        "user__delete_account_current_pwd_hint":
            MessageLookupByLibrary.simpleMessage(
                "Ange ditt nuvarande lösenord"),
        "user__delete_account_next":
            MessageLookupByLibrary.simpleMessage("Nästa"),
        "user__delete_account_title":
            MessageLookupByLibrary.simpleMessage("Ta bort konto"),
        "user__disconnect_from_user": m35,
        "user__disconnect_from_user_success":
            MessageLookupByLibrary.simpleMessage("Er kontakt har brutits"),
        "user__edit_profile_bio": MessageLookupByLibrary.simpleMessage("Bio"),
        "user__edit_profile_delete":
            MessageLookupByLibrary.simpleMessage("Ta bort"),
        "user__edit_profile_followers_count":
            MessageLookupByLibrary.simpleMessage("Följarantal"),
        "user__edit_profile_location":
            MessageLookupByLibrary.simpleMessage("Plats"),
        "user__edit_profile_name": MessageLookupByLibrary.simpleMessage("Namn"),
        "user__edit_profile_pick_image":
            MessageLookupByLibrary.simpleMessage("Välj bild"),
        "user__edit_profile_pick_image_error_too_large": m36,
        "user__edit_profile_save_text":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "user__edit_profile_title":
            MessageLookupByLibrary.simpleMessage("Redigera profil"),
        "user__edit_profile_url": MessageLookupByLibrary.simpleMessage("Url"),
        "user__edit_profile_user_name_taken": m37,
        "user__edit_profile_username":
            MessageLookupByLibrary.simpleMessage("Användarnamn"),
        "user__email_verification_error": MessageLookupByLibrary.simpleMessage(
            "Hoppsan! Din kod är ogiltigt eller har gått ut, vänligen försök igen"),
        "user__email_verification_successful":
            MessageLookupByLibrary.simpleMessage(
                "Häftigt! Din e-post har verifierats"),
        "user__emoji_field_none_selected":
            MessageLookupByLibrary.simpleMessage("Ingen emoji vald"),
        "user__emoji_search_none_found": m38,
        "user__follow_button_follow_text":
            MessageLookupByLibrary.simpleMessage("Följ"),
        "user__follow_button_unfollow_text":
            MessageLookupByLibrary.simpleMessage("Sluta följa"),
        "user__follow_lists_no_list_found":
            MessageLookupByLibrary.simpleMessage("Inga listor hittades."),
        "user__follow_lists_no_list_found_for": m39,
        "user__follow_lists_search_for":
            MessageLookupByLibrary.simpleMessage("Sök efter en lista..."),
        "user__follow_lists_title":
            MessageLookupByLibrary.simpleMessage("Mina listor"),
        "user__follower_plural":
            MessageLookupByLibrary.simpleMessage("följare"),
        "user__follower_singular":
            MessageLookupByLibrary.simpleMessage("följare"),
        "user__followers_title":
            MessageLookupByLibrary.simpleMessage("Följare"),
        "user__following_resource_name":
            MessageLookupByLibrary.simpleMessage("följda användare"),
        "user__following_text": MessageLookupByLibrary.simpleMessage("Följer"),
        "user__follows_list_accounts_count": m40,
        "user__follows_list_edit":
            MessageLookupByLibrary.simpleMessage("Redigera"),
        "user__follows_list_header_title":
            MessageLookupByLibrary.simpleMessage("Användare"),
        "user__follows_lists_account":
            MessageLookupByLibrary.simpleMessage("1 Konto"),
        "user__follows_lists_accounts": m41,
        "user__groups_see_all": m42,
        "user__guidelines_accept":
            MessageLookupByLibrary.simpleMessage("Godkänn"),
        "user__guidelines_desc": MessageLookupByLibrary.simpleMessage(
            "Vänligen lägg en stund på att läsa igenom och godkänna våra riktlinjer."),
        "user__guidelines_reject":
            MessageLookupByLibrary.simpleMessage("Avvisa"),
        "user__invite": MessageLookupByLibrary.simpleMessage("Bjud in"),
        "user__invite_member": MessageLookupByLibrary.simpleMessage("Medlem"),
        "user__invite_someone_message": m43,
        "user__invites_accepted_group_item_name":
            MessageLookupByLibrary.simpleMessage("accepterad inbjudan"),
        "user__invites_accepted_group_name":
            MessageLookupByLibrary.simpleMessage("accepterade inbjudningar"),
        "user__invites_accepted_title":
            MessageLookupByLibrary.simpleMessage("Accepterad"),
        "user__invites_create_create":
            MessageLookupByLibrary.simpleMessage("Skapa"),
        "user__invites_create_create_title":
            MessageLookupByLibrary.simpleMessage("Skapa inbjudan"),
        "user__invites_create_edit_title":
            MessageLookupByLibrary.simpleMessage("Redigera inbjudan"),
        "user__invites_create_name_hint":
            MessageLookupByLibrary.simpleMessage("t. ex. Sven Svensson"),
        "user__invites_create_name_title":
            MessageLookupByLibrary.simpleMessage("Smeknamn"),
        "user__invites_create_save":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "user__invites_delete": MessageLookupByLibrary.simpleMessage("Ta bort"),
        "user__invites_edit_text":
            MessageLookupByLibrary.simpleMessage("Redigera"),
        "user__invites_email_hint": MessageLookupByLibrary.simpleMessage(
            "t. ex. svensvensson@email.com"),
        "user__invites_email_invite_text":
            MessageLookupByLibrary.simpleMessage("E-postinbjudan"),
        "user__invites_email_send_text":
            MessageLookupByLibrary.simpleMessage("Skicka"),
        "user__invites_email_sent_text":
            MessageLookupByLibrary.simpleMessage("E-postinbjudan skickad"),
        "user__invites_email_text":
            MessageLookupByLibrary.simpleMessage("E-post"),
        "user__invites_invite_a_friend":
            MessageLookupByLibrary.simpleMessage("Bjud in en vän"),
        "user__invites_invite_text":
            MessageLookupByLibrary.simpleMessage("Bjud in"),
        "user__invites_joined_with": m44,
        "user__invites_none_left": MessageLookupByLibrary.simpleMessage(
            "Du har inga inbjudningar tillgängliga."),
        "user__invites_none_used": MessageLookupByLibrary.simpleMessage(
            "Det ser ut som att du inte använt några inbjudningar."),
        "user__invites_pending":
            MessageLookupByLibrary.simpleMessage("Väntande"),
        "user__invites_pending_email": m45,
        "user__invites_pending_group_item_name":
            MessageLookupByLibrary.simpleMessage("väntande inbjudan"),
        "user__invites_pending_group_name":
            MessageLookupByLibrary.simpleMessage("väntande inbjudningar"),
        "user__invites_refresh":
            MessageLookupByLibrary.simpleMessage("Uppdatera"),
        "user__invites_share_email":
            MessageLookupByLibrary.simpleMessage("Dela inbjudan via e-post"),
        "user__invites_share_email_desc": MessageLookupByLibrary.simpleMessage(
            "Vi kommer skicka en inbjudan med instruktioner å dina vägnar"),
        "user__invites_share_yourself":
            MessageLookupByLibrary.simpleMessage("Dela inbjudan själv"),
        "user__invites_share_yourself_desc":
            MessageLookupByLibrary.simpleMessage(
                "Välj mellan meddelandeappar, etc."),
        "user__invites_title":
            MessageLookupByLibrary.simpleMessage("Mina inbjudningar"),
        "user__language_settings_save":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "user__language_settings_saved_success":
            MessageLookupByLibrary.simpleMessage("Språket har uppdaterats"),
        "user__language_settings_title":
            MessageLookupByLibrary.simpleMessage("Språkinställningar"),
        "user__list_name_empty_error": MessageLookupByLibrary.simpleMessage(
            "Du måste ge listan ett namn."),
        "user__list_name_range_error": m46,
        "user__million_postfix": MessageLookupByLibrary.simpleMessage("mn"),
        "user__profile_action_cancel_connection":
            MessageLookupByLibrary.simpleMessage("Avbryt kontaktförfrågan"),
        "user__profile_action_deny_connection":
            MessageLookupByLibrary.simpleMessage("Neka kontaktförfrågan"),
        "user__profile_action_user_blocked":
            MessageLookupByLibrary.simpleMessage("Användare blockerad"),
        "user__profile_action_user_unblocked":
            MessageLookupByLibrary.simpleMessage("Användare avblockerad"),
        "user__profile_bio_length_error": m47,
        "user__profile_location_length_error": m48,
        "user__profile_url_invalid_error": MessageLookupByLibrary.simpleMessage(
            "Vänligen ange en giltig URL."),
        "user__remove_account_from_list":
            MessageLookupByLibrary.simpleMessage("Ta bort konto från listor"),
        "user__remove_account_from_list_success":
            MessageLookupByLibrary.simpleMessage("Konto borttaget från listor"),
        "user__save_connection_circle_color_hint":
            MessageLookupByLibrary.simpleMessage("(Tryck för att ändra)"),
        "user__save_connection_circle_color_name":
            MessageLookupByLibrary.simpleMessage("Färg"),
        "user__save_connection_circle_create":
            MessageLookupByLibrary.simpleMessage("Skapa krets"),
        "user__save_connection_circle_edit":
            MessageLookupByLibrary.simpleMessage("Redigera krets"),
        "user__save_connection_circle_hint":
            MessageLookupByLibrary.simpleMessage(
                "t. ex. Vänner, Familj, Jobb."),
        "user__save_connection_circle_name":
            MessageLookupByLibrary.simpleMessage("Namn"),
        "user__save_connection_circle_name_taken": m49,
        "user__save_connection_circle_save":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "user__save_connection_circle_users":
            MessageLookupByLibrary.simpleMessage("Användare"),
        "user__save_follows_list_create":
            MessageLookupByLibrary.simpleMessage("Skapa lista"),
        "user__save_follows_list_edit":
            MessageLookupByLibrary.simpleMessage("Redigera lista"),
        "user__save_follows_list_emoji":
            MessageLookupByLibrary.simpleMessage("Emoji"),
        "user__save_follows_list_emoji_required_error":
            MessageLookupByLibrary.simpleMessage("En emoji krävs"),
        "user__save_follows_list_hint_text":
            MessageLookupByLibrary.simpleMessage("t. ex. Resor, Fotografering"),
        "user__save_follows_list_name":
            MessageLookupByLibrary.simpleMessage("Namn"),
        "user__save_follows_list_name_taken": m50,
        "user__save_follows_list_save":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "user__save_follows_list_users":
            MessageLookupByLibrary.simpleMessage("Användare"),
        "user__thousand_postfix": MessageLookupByLibrary.simpleMessage("t"),
        "user__tile_delete": MessageLookupByLibrary.simpleMessage("Ta bort"),
        "user__tile_following":
            MessageLookupByLibrary.simpleMessage(" · Följer"),
        "user__timeline_filters_apply_all":
            MessageLookupByLibrary.simpleMessage("Applicera filter"),
        "user__timeline_filters_circles":
            MessageLookupByLibrary.simpleMessage("Kretsar"),
        "user__timeline_filters_clear_all":
            MessageLookupByLibrary.simpleMessage("Återställ"),
        "user__timeline_filters_lists":
            MessageLookupByLibrary.simpleMessage("Listor"),
        "user__timeline_filters_no_match": m51,
        "user__timeline_filters_search_desc":
            MessageLookupByLibrary.simpleMessage(
                "Sök efter kretsar och listor..."),
        "user__timeline_filters_title":
            MessageLookupByLibrary.simpleMessage("Tidslinjefilter"),
        "user__translate_see_translation":
            MessageLookupByLibrary.simpleMessage("Visa översättning"),
        "user__translate_show_original":
            MessageLookupByLibrary.simpleMessage("Visa original"),
        "user__unblock_user":
            MessageLookupByLibrary.simpleMessage("Avblockera användare"),
        "user__uninvite":
            MessageLookupByLibrary.simpleMessage("Avbryt inbjudan"),
        "user__update_connection_circle_save":
            MessageLookupByLibrary.simpleMessage("Spara"),
        "user__update_connection_circle_updated":
            MessageLookupByLibrary.simpleMessage("Kontakt uppdaterad"),
        "user__update_connection_circles_title":
            MessageLookupByLibrary.simpleMessage("Uppdatera kontaktkretsar"),
        "user_search__cancel": MessageLookupByLibrary.simpleMessage("Avbryt"),
        "user_search__communities":
            MessageLookupByLibrary.simpleMessage("Gemenskaper"),
        "user_search__list_no_results_found": m52,
        "user_search__list_refresh_text":
            MessageLookupByLibrary.simpleMessage("Uppdatera"),
        "user_search__list_retry":
            MessageLookupByLibrary.simpleMessage("Tryck för att försöka igen."),
        "user_search__list_search_text": m53,
        "user_search__no_communities_for": m54,
        "user_search__no_results_for": m55,
        "user_search__no_users_for": m56,
        "user_search__search_text":
            MessageLookupByLibrary.simpleMessage("Sök..."),
        "user_search__searching_for": m57,
        "user_search__users": MessageLookupByLibrary.simpleMessage("Användare")
      };
}
