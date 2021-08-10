// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  get localeName => 'es';

  static m0(minLength, maxLength) => "(${minLength}-${maxLength} caracteres)";

  static m1(minLength, maxLength) =>
      "La descripción debe tener entre ${minLength} y ${maxLength} caracteres.";

  static m2(minLength, maxLength) =>
      "El nombre debe tener entre ${minLength} y ${maxLength} caracteres.";

  static m3(minLength, maxLength) =>
      "La contraseña debe tener entre ${minLength} y ${maxLength} caracteres.";

  static m4(maxLength) =>
      "El nombre de usuario no puede tener más de ${maxLength} caracteres.";

  static m5(maxLength) =>
      "Los adjetivos no pueden ser más largos que ${maxLength} caracteres.";

  static m6(username) =>
      "¿Seguro que quieres añadir @${username} como administrador de la comunidad?";

  static m7(username) => "¿Seguro que quieres banear a @${username}?";

  static m8(maxLength) =>
      "La descripción no puede ser más larga que ${maxLength} caracteres.";

  static m9(username) =>
      "¿Seguro que quieres añadir a @${username} como administrador de la comunidad?";

  static m10(maxLength) =>
      "El nombre no puede tener más de ${maxLength} caracteres.";

  static m11(min) => "Debes elegir al menos ${min} categorías.";

  static m12(min) => "Debes elegir al menos ${min} categoría.";

  static m13(max) => "Escoge hasta ${max} categorías";

  static m14(maxLength) =>
      "Las reglas no pueden tener más de ${maxLength} caracteres.";

  static m15(takenName) => "El nombre \'${takenName}\' esta tomado";

  static m16(maxLength) =>
      "El título no puede ser más largo que ${maxLength} caracteres.";

  static m17(categoryName) => "Trending en ${categoryName}";

  static m18(currentUserLanguage) => "Idioma (${currentUserLanguage})";

  static m19(resourceCount, resourceName) =>
      "Ver todos los ${resourceCount} ${resourceName}";

  static m20(postCommentText) =>
      "[name] [username] también comentó: ${postCommentText}";

  static m21(postCommentText) =>
      "[name] [username] comentó en tu post: ${postCommentText}";

  static m22(postCommentText) =>
      "[name] [username] también respondió: ${postCommentText}";

  static m23(postCommentText) =>
      "[name] [username] respondió: ${postCommentText}";

  static m24(communityName) =>
      "[name] [username] te ha invitado a unirte a la comunidad c/${communityName}.";

  static m25(maxLength) =>
      "Un comentario no puede ser más largo que ${maxLength} caracteres.";

  static m26(commentsCount) => "Ver los ${commentsCount} comentarios";

  static m27(circlesSearchQuery) =>
      "\'No se han encontrado círculos que coincidan con \'${circlesSearchQuery}\'.";

  static m28(name) => "${name} aún no ha compartido nada.";

  static m29(postCreatorUsername) =>
      "los círculos de @${postCreatorUsername}\'s";

  static m30(maxLength) =>
      "El nombre del círculo no debe tener más de ${maxLength} caracteres.";

  static m31(prettyUsersCount) => "${prettyUsersCount} gente";

  static m32(username) => "¿Seguro que quieres banear a @${username}?";

  static m33(userName) => "Confirmar conexión con ${userName}";

  static m34(userName) => "Conectar con ${userName}";

  static m35(userName) => "Desconectarse de ${userName}";

  static m36(limit) => "Imagen demasiado grande (límite: ${limit} MB)";

  static m37(username) => "El nombre de usuario @${username} ya existe";

  static m38(searchQuery) =>
      "No se encontró un Emoji similar a \'${searchQuery}\'.";

  static m39(searchQuery) => "No se encontró lista con \'${searchQuery}\'";

  static m40(prettyUsersCount) => "${prettyUsersCount} cuentas";

  static m41(prettyUsersCount) => "${prettyUsersCount} Cuentas";

  static m42(groupName) => "Ver ${groupName}";

  static m43(iosLink, androidLink, inviteLink) =>
      "Hola, me gustaría invitarte a Somus. Primero, descarga la aplicación en iTunes (${iosLink}) on la PlayStore (${androidLink}). En segundo lugar, pega este enlace de invitación personalizado en el formulario \'Registrarse\' en la aplicación Somus: ${inviteLink}";

  static m44(username) => "Se unió con el nombre de usuario @${username}";

  static m45(email) => "Pendiente, email de invitación enviado a ${email}";

  static m46(maxLength) =>
      "El nombre de la lista no debe tener más de ${maxLength} caracteres.";

  static m47(maxLength) =>
      "La biografía no puede contener más de ${maxLength} caracteres.";

  static m48(maxLength) =>
      "La ubicación no puede contener más de ${maxLength} caracteres.";

  static m49(takenConnectionsCircleName) =>
      "El nombre de lista \'${takenConnectionsCircleName}\' esta tomado";

  static m50(listName) => "El nombre de lista \'${listName}\' esta tomado";

  static m51(searchQuery) => "Sin resultados para \'${searchQuery}\'.";

  static m52(resourcePluralName) =>
      "No se encontró ningun ${resourcePluralName}.";

  static m53(resourcePluralName) => "Buscar ${resourcePluralName}...";

  static m54(searchQuery) =>
      "No se encontraron comunidades para \'${searchQuery}\'.";

  static m55(searchQuery) => "Sin resultados para \"${searchQuery}\".";

  static m56(searchQuery) =>
      "No se encontraron usuarios para \'${searchQuery}\'.";

  static m57(searchQuery) => "Buscando \'${searchQuery}\'";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "auth__change_password_current_pwd":
            MessageLookupByLibrary.simpleMessage("Contraseña actual"),
        "auth__change_password_current_pwd_hint":
            MessageLookupByLibrary.simpleMessage(
                "Introduce tu contraseña actual"),
        "auth__change_password_current_pwd_incorrect":
            MessageLookupByLibrary.simpleMessage(
                "La contraseña introducida fue incorrecta"),
        "auth__change_password_new_pwd":
            MessageLookupByLibrary.simpleMessage("Nueva contraseña"),
        "auth__change_password_new_pwd_error": MessageLookupByLibrary.simpleMessage(
            "Por favor, asegúrate de que la contraseña tenga entre 10 y 100 caracteres"),
        "auth__change_password_new_pwd_hint":
            MessageLookupByLibrary.simpleMessage(
                "Introduzca su nueva contraseña"),
        "auth__change_password_save_success":
            MessageLookupByLibrary.simpleMessage(
                "¡Todo bien! Tu contraseña ha sido actualizada"),
        "auth__change_password_save_text":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "auth__change_password_title":
            MessageLookupByLibrary.simpleMessage("Cambiar contraseña"),
        "auth__create_acc__almost_there":
            MessageLookupByLibrary.simpleMessage("¡Ya casi!"),
        "auth__create_acc__are_you_legal_age":
            MessageLookupByLibrary.simpleMessage("¿Tienes más de 16 años?"),
        "auth__create_acc__avatar_choose_camera":
            MessageLookupByLibrary.simpleMessage("Toma una foto"),
        "auth__create_acc__avatar_choose_gallery":
            MessageLookupByLibrary.simpleMessage("Usar una foto existente"),
        "auth__create_acc__avatar_remove_photo":
            MessageLookupByLibrary.simpleMessage("Eliminar foto"),
        "auth__create_acc__avatar_tap_to_change":
            MessageLookupByLibrary.simpleMessage("Tocar para cambiar"),
        "auth__create_acc__can_change_username":
            MessageLookupByLibrary.simpleMessage(
                "Puedes cambiarlo en cualquier momento en la configuración de tu perfil."),
        "auth__create_acc__congratulations":
            MessageLookupByLibrary.simpleMessage("¡Felicidades!"),
        "auth__create_acc__create_account":
            MessageLookupByLibrary.simpleMessage("Crear cuenta"),
        "auth__create_acc__done":
            MessageLookupByLibrary.simpleMessage("Crear cuenta"),
        "auth__create_acc__done_continue":
            MessageLookupByLibrary.simpleMessage("Entrar"),
        "auth__create_acc__done_created": MessageLookupByLibrary.simpleMessage(
            "Tu cuenta ha sido creada con el nombre de usuario "),
        "auth__create_acc__done_description":
            MessageLookupByLibrary.simpleMessage("Tu cuenta ha sido creada."),
        "auth__create_acc__done_subtext": MessageLookupByLibrary.simpleMessage(
            "Puedes cambiar esto en cualquier momento en la configuración de tu perfil."),
        "auth__create_acc__done_title":
            MessageLookupByLibrary.simpleMessage("¡Wohoo!"),
        "auth__create_acc__email_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "😱 Tu correo electrónico no puede estar vacío"),
        "auth__create_acc__email_invalid_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Por favor, proporcione una dirección de correo electrónico válida."),
        "auth__create_acc__email_placeholder":
            MessageLookupByLibrary.simpleMessage("marc_anthony@salsa.com"),
        "auth__create_acc__email_server_error":
            MessageLookupByLibrary.simpleMessage(
                "😭 Estamos experimentando problemas con nuestros servidores, por favor inténtalo de nuevo en un par de minutos."),
        "auth__create_acc__email_taken_error":
            MessageLookupByLibrary.simpleMessage(
                "🤔 Una cuenta ya existe para ese correo electrónico."),
        "auth__create_acc__lets_get_started":
            MessageLookupByLibrary.simpleMessage("¡Empecemos!"),
        "auth__create_acc__link_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "La dirección no puede estar vacía."),
        "auth__create_acc__link_invalid_error":
            MessageLookupByLibrary.simpleMessage(
                "Este enlace parece ser inválido."),
        "auth__create_acc__name_characters_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Un nombre sólo puede contener caracteres alfanuméricos (por ahora)."),
        "auth__create_acc__name_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "😱 Tu nombre no puede estar vacío."),
        "auth__create_acc__name_length_error": MessageLookupByLibrary.simpleMessage(
            "😱 Tu nombre no puede tener más de 50 caracteres. (Si es así, lo sentimos)"),
        "auth__create_acc__name_placeholder":
            MessageLookupByLibrary.simpleMessage("Luis Miguel"),
        "auth__create_acc__next":
            MessageLookupByLibrary.simpleMessage("Siguiente"),
        "auth__create_acc__one_last_thing":
            MessageLookupByLibrary.simpleMessage("Una última cosa..."),
        "auth__create_acc__password_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "😱 La contraseña no puede estar vacía"),
        "auth__create_acc__password_length_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 La contraseña debe tener entre 8 y 64 caracteres."),
        "auth__create_acc__paste_link": MessageLookupByLibrary.simpleMessage(
            "Pega el enlace de registro a continuación"),
        "auth__create_acc__paste_link_help_text":
            MessageLookupByLibrary.simpleMessage(
                "Utiliza el link en tu correo de invitación a Somus."),
        "auth__create_acc__paste_password_reset_link":
            MessageLookupByLibrary.simpleMessage(
                "Pega el enlace de restablecimiento de contraseña a continuación"),
        "auth__create_acc__previous":
            MessageLookupByLibrary.simpleMessage("Atrás"),
        "auth__create_acc__register":
            MessageLookupByLibrary.simpleMessage("Registro"),
        "auth__create_acc__request_invite":
            MessageLookupByLibrary.simpleMessage(
                "¿No tienes invitación? Solicita una aquí."),
        "auth__create_acc__submit_error_desc_server":
            MessageLookupByLibrary.simpleMessage(
                "😭 Estamos experimentando problemas con nuestros servidores, por favor inténtalo de nuevo en un par de minutos."),
        "auth__create_acc__submit_error_desc_validation":
            MessageLookupByLibrary.simpleMessage(
                "😅 Parece que algunos de los datos no son correctos, por favor comprueba e intenta de nuevo."),
        "auth__create_acc__submit_error_title":
            MessageLookupByLibrary.simpleMessage("Oh no..."),
        "auth__create_acc__submit_loading_desc":
            MessageLookupByLibrary.simpleMessage("Estamos creando tu cuenta."),
        "auth__create_acc__submit_loading_title":
            MessageLookupByLibrary.simpleMessage("¡Ya casi!"),
        "auth__create_acc__subscribe":
            MessageLookupByLibrary.simpleMessage("Solicitar"),
        "auth__create_acc__subscribe_to_waitlist_text":
            MessageLookupByLibrary.simpleMessage("¡Solicitar una invitación!"),
        "auth__create_acc__username_characters_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Un nombre de usuario sólo puede contener caracteres alfanuméricos y guiones bajos."),
        "auth__create_acc__username_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "😱 El nombre de usuario no puede estar vacío."),
        "auth__create_acc__username_length_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Un nombre de usuario no puede tener más de 30 caracteres."),
        "auth__create_acc__username_placeholder":
            MessageLookupByLibrary.simpleMessage("juanga"),
        "auth__create_acc__username_server_error":
            MessageLookupByLibrary.simpleMessage(
                "😭 Estamos experimentando problemas con nuestros servidores, por favor inténtalo de nuevo en un par de minutos."),
        "auth__create_acc__username_taken_error":
            MessageLookupByLibrary.simpleMessage(
                "😩 El nombre de usuario @%s ya está tomado."),
        "auth__create_acc__welcome_to_beta":
            MessageLookupByLibrary.simpleMessage("¡Bienvenido a la Beta!"),
        "auth__create_acc__what_avatar":
            MessageLookupByLibrary.simpleMessage("Sube una foto de perfil"),
        "auth__create_acc__what_email": MessageLookupByLibrary.simpleMessage(
            "¿Cuál es tu correo electrónico?"),
        "auth__create_acc__what_name":
            MessageLookupByLibrary.simpleMessage("Como te llamas?"),
        "auth__create_acc__what_password":
            MessageLookupByLibrary.simpleMessage("Elige una contraseña"),
        "auth__create_acc__what_password_subtext":
            MessageLookupByLibrary.simpleMessage("(min 10 caracteres)"),
        "auth__create_acc__what_username": MessageLookupByLibrary.simpleMessage(
            "Que usuario te gustaria tener?"),
        "auth__create_acc__your_subscribed":
            MessageLookupByLibrary.simpleMessage(
                "Eres el número {0} en la lista de espera."),
        "auth__create_acc__your_username_is":
            MessageLookupByLibrary.simpleMessage("Tu nombre de usuario es "),
        "auth__create_acc_password_hint_text": m0,
        "auth__create_account":
            MessageLookupByLibrary.simpleMessage("Registro"),
        "auth__description_empty_error": MessageLookupByLibrary.simpleMessage(
            "La descripción no puede estar vacía."),
        "auth__description_range_error": m1,
        "auth__email_empty_error": MessageLookupByLibrary.simpleMessage(
            "Correo electrónico no puede estar vacío."),
        "auth__email_invalid_error":
            MessageLookupByLibrary.simpleMessage("Ingresa un email válido."),
        "auth__headline":
            MessageLookupByLibrary.simpleMessage("🕊 Una red social mejor."),
        "auth__login": MessageLookupByLibrary.simpleMessage("Entrar"),
        "auth__login__connection_error": MessageLookupByLibrary.simpleMessage(
            "No podemos llegar a nuestros servidores. ¿Estás conectado a Internet?"),
        "auth__login__credentials_mismatch_error":
            MessageLookupByLibrary.simpleMessage(
                "Las credenciales proporcionadas no coinciden."),
        "auth__login__email_label":
            MessageLookupByLibrary.simpleMessage("Correo electrónico"),
        "auth__login__forgot_password":
            MessageLookupByLibrary.simpleMessage("Olvidé mi contraseña"),
        "auth__login__forgot_password_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Introduce tu nombre de usuario o email"),
        "auth__login__login": MessageLookupByLibrary.simpleMessage("Continuar"),
        "auth__login__or_text": MessageLookupByLibrary.simpleMessage("O"),
        "auth__login__password_empty_error":
            MessageLookupByLibrary.simpleMessage("La contraseña es requerida."),
        "auth__login__password_label":
            MessageLookupByLibrary.simpleMessage("Contraseña"),
        "auth__login__password_length_error":
            MessageLookupByLibrary.simpleMessage(
                "La contraseña debe tener entre 8 y 64 caracteres."),
        "auth__login__previous":
            MessageLookupByLibrary.simpleMessage("Anterior"),
        "auth__login__server_error": MessageLookupByLibrary.simpleMessage(
            "Uh oh.. Estamos experimentando problemas del servidor. Por favor, inténtalo de nuevo en unos minutos."),
        "auth__login__subtitle": MessageLookupByLibrary.simpleMessage(
            "Introduce tus credenciales para continuar."),
        "auth__login__title":
            MessageLookupByLibrary.simpleMessage("¡Bienvenido de nuevo!"),
        "auth__login__username_characters_error":
            MessageLookupByLibrary.simpleMessage(
                "El nombre de usuario sólo puede contener caracteres alfanuméricos y guiones bajos."),
        "auth__login__username_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "El nombre de usuario es requerido."),
        "auth__login__username_label":
            MessageLookupByLibrary.simpleMessage("Usuario"),
        "auth__login__username_length_error":
            MessageLookupByLibrary.simpleMessage(
                "El nombre de usuario no puede tener más de 30 caracteres."),
        "auth__name_empty_error": MessageLookupByLibrary.simpleMessage(
            "El nombre no puede estar vacío."),
        "auth__name_range_error": m2,
        "auth__password_empty_error": MessageLookupByLibrary.simpleMessage(
            "La contraseña no puede estar vacía."),
        "auth__password_range_error": m3,
        "auth__reset_password_success_info":
            MessageLookupByLibrary.simpleMessage(
                "Su contraseña ha sido actualizada correctamente"),
        "auth__reset_password_success_title":
            MessageLookupByLibrary.simpleMessage("¡Todo Listo!"),
        "auth__username_characters_error": MessageLookupByLibrary.simpleMessage(
            "Un nombre de usuario sólo puede contener caracteres alfanuméricos y guiones bajos."),
        "auth__username_empty_error": MessageLookupByLibrary.simpleMessage(
            "El nombre de usuario no puede estar vacío."),
        "auth__username_maxlength_error": m4,
        "community__about": MessageLookupByLibrary.simpleMessage("Acerca de"),
        "community__actions_invite_people_title":
            MessageLookupByLibrary.simpleMessage("Invitar a la comunidad"),
        "community__actions_manage_text":
            MessageLookupByLibrary.simpleMessage("Gestionar"),
        "community__add_administrators_title":
            MessageLookupByLibrary.simpleMessage("Añadir administrador."),
        "community__add_moderator_title":
            MessageLookupByLibrary.simpleMessage("Añadir moderador"),
        "community__adjectives_range_error": m5,
        "community__admin_add_confirmation": m6,
        "community__admin_desc": MessageLookupByLibrary.simpleMessage(
            "Esto permitirá al miembro editar los detalles de la comunidad, administradores, moderadores y usuarios baneados."),
        "community__administrated_communities":
            MessageLookupByLibrary.simpleMessage("comunidades administradas"),
        "community__administrated_community":
            MessageLookupByLibrary.simpleMessage("comunidad administrada"),
        "community__administrated_title":
            MessageLookupByLibrary.simpleMessage("Administradas"),
        "community__administrator_plural":
            MessageLookupByLibrary.simpleMessage("administradores"),
        "community__administrator_text":
            MessageLookupByLibrary.simpleMessage("administrador"),
        "community__administrator_you":
            MessageLookupByLibrary.simpleMessage("Tú"),
        "community__administrators_title":
            MessageLookupByLibrary.simpleMessage("Administradores"),
        "community__ban_confirmation": m7,
        "community__ban_desc": MessageLookupByLibrary.simpleMessage(
            "Esto removera al usuario de la comunidad y no le permitirá volver a unirse."),
        "community__ban_user_title":
            MessageLookupByLibrary.simpleMessage("Banear usuario"),
        "community__banned_user_text":
            MessageLookupByLibrary.simpleMessage("usuario baneado"),
        "community__banned_users_text":
            MessageLookupByLibrary.simpleMessage("usuarios baneados"),
        "community__banned_users_title":
            MessageLookupByLibrary.simpleMessage("Usuarios baneados"),
        "community__button_rules":
            MessageLookupByLibrary.simpleMessage("Reglas"),
        "community__button_staff":
            MessageLookupByLibrary.simpleMessage("Equipo"),
        "community__categories":
            MessageLookupByLibrary.simpleMessage("categorías."),
        "community__category":
            MessageLookupByLibrary.simpleMessage("categoría."),
        "community__communities":
            MessageLookupByLibrary.simpleMessage("comunidades"),
        "community__communities_all_text":
            MessageLookupByLibrary.simpleMessage("Todo"),
        "community__communities_no_category_found":
            MessageLookupByLibrary.simpleMessage(
                "No se encontraron categorías. Por favor, inténtalo de nuevo en unos minutos."),
        "community__communities_refresh_text":
            MessageLookupByLibrary.simpleMessage("Refrescar"),
        "community__communities_title":
            MessageLookupByLibrary.simpleMessage("Comunidades"),
        "community__community":
            MessageLookupByLibrary.simpleMessage("comunidad"),
        "community__community_members":
            MessageLookupByLibrary.simpleMessage("Miembros de la comunidad"),
        "community__community_staff":
            MessageLookupByLibrary.simpleMessage("Equipo de la comunidad"),
        "community__confirmation_title":
            MessageLookupByLibrary.simpleMessage("Confirmación"),
        "community__delete_confirmation": MessageLookupByLibrary.simpleMessage(
            "¿Estás seguro de que deseas eliminar la comunidad?"),
        "community__delete_desc": MessageLookupByLibrary.simpleMessage(
            "No verás sus posts en tus líneas de tiempo ni podrás publicar a la comunidad."),
        "community__description_range_error": m8,
        "community__favorite_action":
            MessageLookupByLibrary.simpleMessage("Favorizar comunidad"),
        "community__favorite_communities":
            MessageLookupByLibrary.simpleMessage("comunidades favoritas"),
        "community__favorite_community":
            MessageLookupByLibrary.simpleMessage("favorizar comunidad"),
        "community__favorites_title":
            MessageLookupByLibrary.simpleMessage("Favoritas"),
        "community__invite_to_community_resource_plural":
            MessageLookupByLibrary.simpleMessage("conexiones y seguidores"),
        "community__invite_to_community_resource_singular":
            MessageLookupByLibrary.simpleMessage("conexión o seguidor"),
        "community__invite_to_community_title":
            MessageLookupByLibrary.simpleMessage("Invitar a la comunidad"),
        "community__invited_by_member": MessageLookupByLibrary.simpleMessage(
            "Debes ser invitado por un miembro."),
        "community__invited_by_moderator": MessageLookupByLibrary.simpleMessage(
            "Debes ser invitado por un moderador."),
        "community__is_private":
            MessageLookupByLibrary.simpleMessage("Esta comunidad es privada."),
        "community__join_communities_desc":
            MessageLookupByLibrary.simpleMessage(
                "¡Únete a comunidades para llenar esta pestaña!"),
        "community__join_community":
            MessageLookupByLibrary.simpleMessage("Unirse"),
        "community__joined_communities":
            MessageLookupByLibrary.simpleMessage("comunidades parte de"),
        "community__joined_community":
            MessageLookupByLibrary.simpleMessage("comunidad parte de"),
        "community__joined_title":
            MessageLookupByLibrary.simpleMessage("Parte de"),
        "community__leave_community":
            MessageLookupByLibrary.simpleMessage("Dejar"),
        "community__leave_confirmation": MessageLookupByLibrary.simpleMessage(
            "¿Está seguro de que deseas abandonar la comunidad?"),
        "community__leave_desc": MessageLookupByLibrary.simpleMessage(
            "No verás sus posts en tus líneas de tiempo ni podrás publicar a la comunidad."),
        "community__manage_add_favourite": MessageLookupByLibrary.simpleMessage(
            "Añadir la comunidad a tus favoritos"),
        "community__manage_admins_desc": MessageLookupByLibrary.simpleMessage(
            "Ver, añadir y eliminar administradores."),
        "community__manage_admins_title":
            MessageLookupByLibrary.simpleMessage("Administradores"),
        "community__manage_banned_desc": MessageLookupByLibrary.simpleMessage(
            "Ver, añadir y eliminar usuarios baneados."),
        "community__manage_banned_title":
            MessageLookupByLibrary.simpleMessage("Usuarios baneados"),
        "community__manage_closed_posts_desc":
            MessageLookupByLibrary.simpleMessage(
                "Ver y administrar posts cerrados"),
        "community__manage_closed_posts_title":
            MessageLookupByLibrary.simpleMessage("Posts cerrados"),
        "community__manage_delete_desc": MessageLookupByLibrary.simpleMessage(
            "Eliminar la comunidad, para siempre."),
        "community__manage_delete_title":
            MessageLookupByLibrary.simpleMessage("Eliminar comunidad"),
        "community__manage_details_desc": MessageLookupByLibrary.simpleMessage(
            "Cambia el título, nombre, avatar, foto de portada y más."),
        "community__manage_details_title":
            MessageLookupByLibrary.simpleMessage("Detalles"),
        "community__manage_invite_desc": MessageLookupByLibrary.simpleMessage(
            "Invita a tus conexiones y seguidores a unirse a la comunidad."),
        "community__manage_invite_title":
            MessageLookupByLibrary.simpleMessage("Invitar a personas"),
        "community__manage_leave_desc":
            MessageLookupByLibrary.simpleMessage("Dejar la comunidad."),
        "community__manage_leave_title":
            MessageLookupByLibrary.simpleMessage("Dejar comunidad"),
        "community__manage_mod_reports_desc":
            MessageLookupByLibrary.simpleMessage(
                "Revisa los reportes de moderación de la comunidad."),
        "community__manage_mod_reports_title":
            MessageLookupByLibrary.simpleMessage("Reportes de moderación"),
        "community__manage_mods_desc": MessageLookupByLibrary.simpleMessage(
            "Ver, añadir y eliminar administradores."),
        "community__manage_mods_title":
            MessageLookupByLibrary.simpleMessage("Moderadores"),
        "community__manage_remove_favourite":
            MessageLookupByLibrary.simpleMessage(
                "Remover la comunidad a tus favoritos"),
        "community__manage_title":
            MessageLookupByLibrary.simpleMessage("Gestionar comunidad"),
        "community__member": MessageLookupByLibrary.simpleMessage("miembro"),
        "community__member_capitalized":
            MessageLookupByLibrary.simpleMessage("Miembro"),
        "community__member_plural":
            MessageLookupByLibrary.simpleMessage("miembros"),
        "community__members_capitalized":
            MessageLookupByLibrary.simpleMessage("Miembros"),
        "community__moderated_communities":
            MessageLookupByLibrary.simpleMessage("comunidades moderadas"),
        "community__moderated_community":
            MessageLookupByLibrary.simpleMessage("comunidad moderada"),
        "community__moderated_title":
            MessageLookupByLibrary.simpleMessage("Moderadas"),
        "community__moderator_add_confirmation": m9,
        "community__moderator_desc": MessageLookupByLibrary.simpleMessage(
            "Esto permitirá al miembro editar los detalles de la comunidad, administradores, moderadores y usuarios baneados."),
        "community__moderator_resource_name":
            MessageLookupByLibrary.simpleMessage("moderador"),
        "community__moderators_resource_name":
            MessageLookupByLibrary.simpleMessage("moderadores"),
        "community__moderators_title":
            MessageLookupByLibrary.simpleMessage("Moderadores"),
        "community__moderators_you": MessageLookupByLibrary.simpleMessage("Tú"),
        "community__name_characters_error": MessageLookupByLibrary.simpleMessage(
            "El nombre sólo puede contener caracteres alfanuméricos y guiones bajos."),
        "community__name_empty_error": MessageLookupByLibrary.simpleMessage(
            "El nombre no puede estar vacío."),
        "community__name_range_error": m10,
        "community__no": MessageLookupByLibrary.simpleMessage("No"),
        "community__pick_atleast_min_categories": m11,
        "community__pick_atleast_min_category": m12,
        "community__pick_upto_max": m13,
        "community__post_plural": MessageLookupByLibrary.simpleMessage("posts"),
        "community__post_singular":
            MessageLookupByLibrary.simpleMessage("post"),
        "community__posts": MessageLookupByLibrary.simpleMessage("Posts"),
        "community__refresh_text":
            MessageLookupByLibrary.simpleMessage("Refrescar"),
        "community__refreshing":
            MessageLookupByLibrary.simpleMessage("Refrescando comunidad"),
        "community__rules_empty_error": MessageLookupByLibrary.simpleMessage(
            "Las reglas no pueden estar vacías."),
        "community__rules_range_error": m14,
        "community__rules_text": MessageLookupByLibrary.simpleMessage("Reglas"),
        "community__rules_title":
            MessageLookupByLibrary.simpleMessage("Reglas de la comunidad"),
        "community__save_community_create_community":
            MessageLookupByLibrary.simpleMessage("Crear comunidad"),
        "community__save_community_create_text":
            MessageLookupByLibrary.simpleMessage("Crear"),
        "community__save_community_edit_community":
            MessageLookupByLibrary.simpleMessage("Editar comunidad"),
        "community__save_community_label_title":
            MessageLookupByLibrary.simpleMessage("Título"),
        "community__save_community_label_title_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "por ejemplo, Viajes, Fotografía, Gaming."),
        "community__save_community_name_category":
            MessageLookupByLibrary.simpleMessage("Categoría"),
        "community__save_community_name_label_color":
            MessageLookupByLibrary.simpleMessage("Color"),
        "community__save_community_name_label_color_hint_text":
            MessageLookupByLibrary.simpleMessage("(Tocar para cambiar)"),
        "community__save_community_name_label_desc_optional":
            MessageLookupByLibrary.simpleMessage("Descripción · Opcional"),
        "community__save_community_name_label_desc_optional_hint_text":
            MessageLookupByLibrary.simpleMessage("¿De qué trata tu comunidad?"),
        "community__save_community_name_label_member_adjective":
            MessageLookupByLibrary.simpleMessage(
                "Adjetivo de miembro · Opcional"),
        "community__save_community_name_label_member_adjective_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "por ejemplo, viajero, fotógrafo, jugador."),
        "community__save_community_name_label_members_adjective":
            MessageLookupByLibrary.simpleMessage(
                "Adjetivo de miembros · Opcional"),
        "community__save_community_name_label_members_adjective_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "por ejemplo, viajeros, fotógrafos, jugadores."),
        "community__save_community_name_label_rules_optional":
            MessageLookupByLibrary.simpleMessage("Reglas · Opcional"),
        "community__save_community_name_label_rules_optional_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "¿Hay algo que te gustaría que tus miembros sepan?"),
        "community__save_community_name_label_type":
            MessageLookupByLibrary.simpleMessage("Tipo"),
        "community__save_community_name_label_type_hint_text":
            MessageLookupByLibrary.simpleMessage("(Tocar para cambiar)"),
        "community__save_community_name_member_invites":
            MessageLookupByLibrary.simpleMessage("Invitaciones de miembros"),
        "community__save_community_name_member_invites_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Los miembros pueden invitar a gente a la comunidad"),
        "community__save_community_name_taken": m15,
        "community__save_community_name_title":
            MessageLookupByLibrary.simpleMessage("Nombre"),
        "community__save_community_name_title_hint_text":
            MessageLookupByLibrary.simpleMessage(
                " por ejemplo, viajes, fotografía, juegos."),
        "community__save_community_save_text":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "community__title_empty_error": MessageLookupByLibrary.simpleMessage(
            "El título no puede estar vacío."),
        "community__title_range_error": m16,
        "community__trending_in_all": MessageLookupByLibrary.simpleMessage(
            "Trending en todas las categorías"),
        "community__trending_in_category": m17,
        "community__trending_none_found": MessageLookupByLibrary.simpleMessage(
            "No se encontraron comunidades trending. Inténtalo de nuevo en unos minutos."),
        "community__trending_refresh":
            MessageLookupByLibrary.simpleMessage("Refrescar"),
        "community__type_private":
            MessageLookupByLibrary.simpleMessage("Privada"),
        "community__type_public":
            MessageLookupByLibrary.simpleMessage("Pública"),
        "community__unfavorite_action":
            MessageLookupByLibrary.simpleMessage("Desfavorizar comunidad"),
        "community__user_you_text": MessageLookupByLibrary.simpleMessage("Tú"),
        "community__yes": MessageLookupByLibrary.simpleMessage("Si"),
        "drawer__account_settings":
            MessageLookupByLibrary.simpleMessage("Configuración de cuenta"),
        "drawer__account_settings_blocked_users":
            MessageLookupByLibrary.simpleMessage("Usuarios bloqueados"),
        "drawer__account_settings_change_email":
            MessageLookupByLibrary.simpleMessage("Cambiar email"),
        "drawer__account_settings_change_password":
            MessageLookupByLibrary.simpleMessage("Cambiar contraseña"),
        "drawer__account_settings_delete_account":
            MessageLookupByLibrary.simpleMessage("Eliminar cuenta"),
        "drawer__account_settings_language": m18,
        "drawer__account_settings_language_text":
            MessageLookupByLibrary.simpleMessage("Idioma"),
        "drawer__account_settings_notifications":
            MessageLookupByLibrary.simpleMessage("Notificaciones"),
        "drawer__app_account_text":
            MessageLookupByLibrary.simpleMessage("App & cuenta"),
        "drawer__application_settings": MessageLookupByLibrary.simpleMessage(
            "Configuración de la aplicación"),
        "drawer__connections":
            MessageLookupByLibrary.simpleMessage("Mis conexiones"),
        "drawer__customize":
            MessageLookupByLibrary.simpleMessage("Personalizar"),
        "drawer__global_moderation":
            MessageLookupByLibrary.simpleMessage("Moderación global"),
        "drawer__help":
            MessageLookupByLibrary.simpleMessage("Asistencia y comentarios"),
        "drawer__lists": MessageLookupByLibrary.simpleMessage("Mis listas"),
        "drawer__logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
        "drawer__main_title": MessageLookupByLibrary.simpleMessage("Mi Somus"),
        "drawer__menu_title": MessageLookupByLibrary.simpleMessage("Menú"),
        "drawer__my_circles":
            MessageLookupByLibrary.simpleMessage("Mis círculos"),
        "drawer__my_followers":
            MessageLookupByLibrary.simpleMessage("Mis seguidores"),
        "drawer__my_following":
            MessageLookupByLibrary.simpleMessage("Mis seguidos"),
        "drawer__my_invites":
            MessageLookupByLibrary.simpleMessage("Mis invitaciones"),
        "drawer__my_lists": MessageLookupByLibrary.simpleMessage("Mis listas"),
        "drawer__my_mod_penalties": MessageLookupByLibrary.simpleMessage(
            "Mis penalizaciones de moderación"),
        "drawer__my_pending_mod_tasks": MessageLookupByLibrary.simpleMessage(
            "Mis tareas de moderación pendientes"),
        "drawer__profile": MessageLookupByLibrary.simpleMessage("Perfil"),
        "drawer__settings":
            MessageLookupByLibrary.simpleMessage("Configuración"),
        "drawer__themes": MessageLookupByLibrary.simpleMessage("Temas"),
        "drawer__useful_links_guidelines":
            MessageLookupByLibrary.simpleMessage("Reglas de Somus"),
        "drawer__useful_links_guidelines_bug_tracker":
            MessageLookupByLibrary.simpleMessage("Rastreador de errores"),
        "drawer__useful_links_guidelines_bug_tracker_desc":
            MessageLookupByLibrary.simpleMessage(
                "Reportar un error o votar errores existentes"),
        "drawer__useful_links_guidelines_desc":
            MessageLookupByLibrary.simpleMessage(
                "Las reglas que todos esperamos sigan para una coexistencia sana y amistosa."),
        "drawer__useful_links_guidelines_feature_requests":
            MessageLookupByLibrary.simpleMessage(
                "Solicitudes de funcionalidad"),
        "drawer__useful_links_guidelines_feature_requests_desc":
            MessageLookupByLibrary.simpleMessage(
                "Solicitar una función o votar peticiones existentes"),
        "drawer__useful_links_guidelines_github":
            MessageLookupByLibrary.simpleMessage("Tabla de proyectos Github"),
        "drawer__useful_links_guidelines_github_desc":
            MessageLookupByLibrary.simpleMessage(
                "Echa un vistazo a lo que estamos trabajando actualmente"),
        "drawer__useful_links_guidelines_handbook":
            MessageLookupByLibrary.simpleMessage("Manual de usuario"),
        "drawer__useful_links_guidelines_handbook_desc":
            MessageLookupByLibrary.simpleMessage(
                "Un libro con todo lo que hay que saber sobre el uso de la plataforma"),
        "drawer__useful_links_slack_channel":
            MessageLookupByLibrary.simpleMessage("Slack de la comunidad"),
        "drawer__useful_links_slack_channel_desc":
            MessageLookupByLibrary.simpleMessage(
                "Un lugar para discutir todo sobre Somus"),
        "drawer__useful_links_support":
            MessageLookupByLibrary.simpleMessage("Soporte Somus"),
        "drawer__useful_links_support_desc":
            MessageLookupByLibrary.simpleMessage(
                "Encuentra una forma de ayudarnos en nuestro viaje!"),
        "drawer__useful_links_title":
            MessageLookupByLibrary.simpleMessage("Enlaces útiles"),
        "error__no_internet_connection":
            MessageLookupByLibrary.simpleMessage("Sin conexión al internet"),
        "error__unknown_error":
            MessageLookupByLibrary.simpleMessage("Error desconocido"),
        "moderation__actions_chat_with_team":
            MessageLookupByLibrary.simpleMessage("Chatear con el equipo"),
        "moderation__actions_review":
            MessageLookupByLibrary.simpleMessage("Revisar"),
        "moderation__category_text":
            MessageLookupByLibrary.simpleMessage("Categoria"),
        "moderation__community_moderated_objects":
            MessageLookupByLibrary.simpleMessage(
                "Objectos moderados de la comunidad"),
        "moderation__community_review_approve":
            MessageLookupByLibrary.simpleMessage("Aprobar"),
        "moderation__community_review_item_verified":
            MessageLookupByLibrary.simpleMessage(
                "Este elemento ha sido verificado"),
        "moderation__community_review_object":
            MessageLookupByLibrary.simpleMessage("Objeto"),
        "moderation__community_review_reject":
            MessageLookupByLibrary.simpleMessage("rechazar"),
        "moderation__community_review_title":
            MessageLookupByLibrary.simpleMessage("Revisar objeto moderado"),
        "moderation__confirm_report_community_reported":
            MessageLookupByLibrary.simpleMessage("Comunidad reportada"),
        "moderation__confirm_report_item_reported":
            MessageLookupByLibrary.simpleMessage("Objeto reportado"),
        "moderation__confirm_report_post_comment_reported":
            MessageLookupByLibrary.simpleMessage("Comentario reportado"),
        "moderation__confirm_report_post_reported":
            MessageLookupByLibrary.simpleMessage("Post reportado"),
        "moderation__confirm_report_provide_details":
            MessageLookupByLibrary.simpleMessage(
                "¿Puedes proporcionar detalles adicionales que puedan ser relevantes para el reporte?"),
        "moderation__confirm_report_provide_happen_next":
            MessageLookupByLibrary.simpleMessage(
                "Esto es lo que sucederá a continuación:"),
        "moderation__confirm_report_provide_happen_next_desc":
            MessageLookupByLibrary.simpleMessage(
                "- El reporte se enviará de forma anónima. \n- Si estas reportando un post o comentario, el reporte se enviará al staff de Somus y si aplicable, los moderadores de la comunidad donde el contenido se encuentra y se removerá de tu linea de tiempo.\n- Si estas reportando una cuenta, se enviará al staff de Somus.\n- Lo revisaremos, si es aprobado, el contenido será eliminado y las penalidades serán entregadas a las personas involucradas, desde una suspensión temporal hasta la eliminación de la cuenta, dependiendo de la gravedad de la transgresión. \n- Si se descubre que el informe se ha realizado en un intento de dañar a otro miembro o comunidad de la plataforma sin infringir el motivo indicado, se te aplicarán sanciones.\n"),
        "moderation__confirm_report_provide_optional_hint_text":
            MessageLookupByLibrary.simpleMessage("Escribe aquí..."),
        "moderation__confirm_report_provide_optional_info":
            MessageLookupByLibrary.simpleMessage("(Opcional)"),
        "moderation__confirm_report_submit":
            MessageLookupByLibrary.simpleMessage("Entiendo, enviar."),
        "moderation__confirm_report_title":
            MessageLookupByLibrary.simpleMessage("Enviar reporte"),
        "moderation__confirm_report_user_reported":
            MessageLookupByLibrary.simpleMessage("Usuario reportado"),
        "moderation__description_text":
            MessageLookupByLibrary.simpleMessage("Descripción"),
        "moderation__filters_apply":
            MessageLookupByLibrary.simpleMessage("Aplicar los filtros"),
        "moderation__filters_other":
            MessageLookupByLibrary.simpleMessage("Otro"),
        "moderation__filters_reset":
            MessageLookupByLibrary.simpleMessage("Resetear"),
        "moderation__filters_status":
            MessageLookupByLibrary.simpleMessage("Estado"),
        "moderation__filters_title":
            MessageLookupByLibrary.simpleMessage("Filtros de moderación"),
        "moderation__filters_type":
            MessageLookupByLibrary.simpleMessage("Tipo"),
        "moderation__filters_verified":
            MessageLookupByLibrary.simpleMessage("Verificado"),
        "moderation__global_review_object_text":
            MessageLookupByLibrary.simpleMessage("Objeto"),
        "moderation__global_review_title":
            MessageLookupByLibrary.simpleMessage("Revisar objeto moderado"),
        "moderation__global_review_unverify_text":
            MessageLookupByLibrary.simpleMessage("Desverificar"),
        "moderation__global_review_verify_text":
            MessageLookupByLibrary.simpleMessage("Verificar"),
        "moderation__globally_moderated_objects":
            MessageLookupByLibrary.simpleMessage(
                "Objetos moderados globalmente"),
        "moderation__moderated_object_false_text":
            MessageLookupByLibrary.simpleMessage("Falso"),
        "moderation__moderated_object_reports_count":
            MessageLookupByLibrary.simpleMessage("Cantidad de denuncias"),
        "moderation__moderated_object_status":
            MessageLookupByLibrary.simpleMessage("Estado"),
        "moderation__moderated_object_title":
            MessageLookupByLibrary.simpleMessage("Objeto"),
        "moderation__moderated_object_true_text":
            MessageLookupByLibrary.simpleMessage("Cierto"),
        "moderation__moderated_object_verified":
            MessageLookupByLibrary.simpleMessage("Verificado"),
        "moderation__moderated_object_verified_by_staff":
            MessageLookupByLibrary.simpleMessage(
                "Verificado por el equipo de Somus"),
        "moderation__my_moderation_penalties_resouce_singular":
            MessageLookupByLibrary.simpleMessage("penalizacion de moderación"),
        "moderation__my_moderation_penalties_resource_plural":
            MessageLookupByLibrary.simpleMessage(
                "penalizaciones de moderación"),
        "moderation__my_moderation_penalties_title":
            MessageLookupByLibrary.simpleMessage(
                "Penalizaciones de moderación"),
        "moderation__my_moderation_tasks_title":
            MessageLookupByLibrary.simpleMessage(
                "Tareas de moderación pendientes"),
        "moderation__no_description_text":
            MessageLookupByLibrary.simpleMessage("Sin descripción"),
        "moderation__object_status_title":
            MessageLookupByLibrary.simpleMessage("Estado"),
        "moderation__pending_moderation_tasks_plural":
            MessageLookupByLibrary.simpleMessage(
                "tareas de moderación pendientes"),
        "moderation__pending_moderation_tasks_singular":
            MessageLookupByLibrary.simpleMessage(
                "tarea de moderación pendiente"),
        "moderation__report_account_text":
            MessageLookupByLibrary.simpleMessage("Reportar cuenta"),
        "moderation__report_comment_text":
            MessageLookupByLibrary.simpleMessage("Reportar comentario"),
        "moderation__report_community_text":
            MessageLookupByLibrary.simpleMessage("Reportar comunidad"),
        "moderation__report_post_text":
            MessageLookupByLibrary.simpleMessage("Reportar post"),
        "moderation__reporter_text":
            MessageLookupByLibrary.simpleMessage("Reportero"),
        "moderation__reports_preview_resource_reports":
            MessageLookupByLibrary.simpleMessage("reportes"),
        "moderation__reports_preview_title":
            MessageLookupByLibrary.simpleMessage("Reportes"),
        "moderation__reports_see_all": m19,
        "moderation__tap_to_retry": MessageLookupByLibrary.simpleMessage(
            "Toca para reintentar la carga de elementos"),
        "moderation__update_category_save":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "moderation__update_category_title":
            MessageLookupByLibrary.simpleMessage("Actualizar categoría"),
        "moderation__update_description_report_desc":
            MessageLookupByLibrary.simpleMessage("Descripción del reporte"),
        "moderation__update_description_report_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "por ejemplo, el contenido fue encontrado que..."),
        "moderation__update_description_save":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "moderation__update_description_title":
            MessageLookupByLibrary.simpleMessage("Editar descripción"),
        "moderation__update_status_save":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "moderation__update_status_title":
            MessageLookupByLibrary.simpleMessage("Actualizar el estado"),
        "moderation__you_have_reported_account_text":
            MessageLookupByLibrary.simpleMessage("Has reportado esta cuenta"),
        "moderation__you_have_reported_comment_text":
            MessageLookupByLibrary.simpleMessage(
                "Has reportado este comentario"),
        "moderation__you_have_reported_community_text":
            MessageLookupByLibrary.simpleMessage(
                "Has reportado esta comunidad"),
        "moderation__you_have_reported_post_text":
            MessageLookupByLibrary.simpleMessage(
                "Has reportado a este usuario"),
        "notifications__accepted_connection_request_tile":
            MessageLookupByLibrary.simpleMessage(
                ". [name] [username] aceptó tu solicitud de conexión."),
        "notifications__comment_comment_notification_tile_user_also_commented":
            m20,
        "notifications__comment_comment_notification_tile_user_commented": m21,
        "notifications__comment_desc": MessageLookupByLibrary.simpleMessage(
            "Se notificado cuando alguien comente en uno de tus posts o en uno que tu también comentaste."),
        "notifications__comment_reaction_desc":
            MessageLookupByLibrary.simpleMessage(
                "Se notificado cuando alguien reacciona en uno de tus comentarios."),
        "notifications__comment_reaction_title":
            MessageLookupByLibrary.simpleMessage("Reacción a comentario"),
        "notifications__comment_reply_desc": MessageLookupByLibrary.simpleMessage(
            "Se notificado cuando alguien responde a uno de tus comentarios o a uno que tu también comentaste."),
        "notifications__comment_reply_notification_tile_user_also_replied": m22,
        "notifications__comment_reply_notification_tile_user_replied": m23,
        "notifications__comment_reply_title":
            MessageLookupByLibrary.simpleMessage("Respuestas"),
        "notifications__comment_title":
            MessageLookupByLibrary.simpleMessage("Comentario"),
        "notifications__community_invite_desc":
            MessageLookupByLibrary.simpleMessage(
                "Se notificado cuando alguien te invita a unirte a una comunidad."),
        "notifications__community_invite_title":
            MessageLookupByLibrary.simpleMessage("Invitación a comunidad"),
        "notifications__connection_desc": MessageLookupByLibrary.simpleMessage(
            "Se notificado cuando alguien quiere conectar contigo"),
        "notifications__connection_request_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] quiere conectar contigo."),
        "notifications__connection_title":
            MessageLookupByLibrary.simpleMessage("Solicitud de conexión"),
        "notifications__follow_desc": MessageLookupByLibrary.simpleMessage(
            "Se notificado cuando alguien comienza a seguirte"),
        "notifications__follow_title":
            MessageLookupByLibrary.simpleMessage("Seguir"),
        "notifications__following_you_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] ahora te sigue."),
        "notifications__general_desc": MessageLookupByLibrary.simpleMessage(
            "Se notificado cuando ocurra algo"),
        "notifications__general_title":
            MessageLookupByLibrary.simpleMessage("Notificaciones"),
        "notifications__mute_post_turn_off_post_comment_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Desactivar notificaciones de comentarios"),
        "notifications__mute_post_turn_off_post_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Desactivar notificaciones de post"),
        "notifications__mute_post_turn_on_post_comment_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Activar notificaciones de comentarios"),
        "notifications__mute_post_turn_on_post_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Activar notifications de post"),
        "notifications__post_reaction_desc":
            MessageLookupByLibrary.simpleMessage(
                "Se notificado cuando alguien reacciona en uno de tus posts."),
        "notifications__post_reaction_title":
            MessageLookupByLibrary.simpleMessage("Reacción a post"),
        "notifications__reacted_to_post_comment_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] reaccionó a tu comentario."),
        "notifications__reacted_to_post_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] reaccionó a tu post."),
        "notifications__settings_title": MessageLookupByLibrary.simpleMessage(
            "Configuración de notificaciones"),
        "notifications__user_community_invite_tile": m24,
        "post__action_comment":
            MessageLookupByLibrary.simpleMessage("Comentar"),
        "post__action_react":
            MessageLookupByLibrary.simpleMessage("Reaccionar"),
        "post__action_reply": MessageLookupByLibrary.simpleMessage("Responder"),
        "post__actions_comment_deleted":
            MessageLookupByLibrary.simpleMessage("Comentario eliminado"),
        "post__actions_delete":
            MessageLookupByLibrary.simpleMessage("Eliminar post"),
        "post__actions_delete_comment":
            MessageLookupByLibrary.simpleMessage("Eliminar comentario"),
        "post__actions_deleted":
            MessageLookupByLibrary.simpleMessage("Post eliminado"),
        "post__actions_edit_comment":
            MessageLookupByLibrary.simpleMessage("Editar comentario"),
        "post__actions_report_text":
            MessageLookupByLibrary.simpleMessage("Reportar"),
        "post__actions_reported_text":
            MessageLookupByLibrary.simpleMessage("Reportado"),
        "post__actions_show_more_text":
            MessageLookupByLibrary.simpleMessage("Ver más"),
        "post__close_post": MessageLookupByLibrary.simpleMessage("Cerrar post"),
        "post__comment_maxlength_error": m25,
        "post__comment_reply_expanded_post":
            MessageLookupByLibrary.simpleMessage("Post"),
        "post__comment_reply_expanded_reply_comment":
            MessageLookupByLibrary.simpleMessage("Responder a comentario"),
        "post__comment_reply_expanded_reply_hint_text":
            MessageLookupByLibrary.simpleMessage("Tu respuesta..."),
        "post__comment_required_error": MessageLookupByLibrary.simpleMessage(
            "El comentario no puede estar vacío."),
        "post__commenter_expanded_edit_comment":
            MessageLookupByLibrary.simpleMessage("Editar comentario"),
        "post__commenter_expanded_join_conversation":
            MessageLookupByLibrary.simpleMessage("Únete a la conversación.."),
        "post__commenter_expanded_save":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "post__commenter_expanded_start_conversation":
            MessageLookupByLibrary.simpleMessage("Inicia la conversación.."),
        "post__commenter_post_text":
            MessageLookupByLibrary.simpleMessage("Publicar"),
        "post__commenter_write_something":
            MessageLookupByLibrary.simpleMessage("Escribe algo..."),
        "post__comments_closed_post":
            MessageLookupByLibrary.simpleMessage("Post cerrado"),
        "post__comments_disabled":
            MessageLookupByLibrary.simpleMessage("Comentarios deshabilitados"),
        "post__comments_disabled_message":
            MessageLookupByLibrary.simpleMessage("Comentarios deshabilitados"),
        "post__comments_enabled_message":
            MessageLookupByLibrary.simpleMessage("Comentarios habilitados"),
        "post__comments_header_be_the_first_comments":
            MessageLookupByLibrary.simpleMessage("Ser el primero en comentar"),
        "post__comments_header_be_the_first_replies":
            MessageLookupByLibrary.simpleMessage("Sé el primero en responder"),
        "post__comments_header_newer":
            MessageLookupByLibrary.simpleMessage("Más reciente"),
        "post__comments_header_newest_comments":
            MessageLookupByLibrary.simpleMessage("Más recientes"),
        "post__comments_header_newest_replies":
            MessageLookupByLibrary.simpleMessage("Respuestas más recientes"),
        "post__comments_header_older":
            MessageLookupByLibrary.simpleMessage("Más antiguo"),
        "post__comments_header_oldest_comments":
            MessageLookupByLibrary.simpleMessage("Más antiguos"),
        "post__comments_header_oldest_replies":
            MessageLookupByLibrary.simpleMessage("Respuestas más antiguas"),
        "post__comments_header_see_newest_comments":
            MessageLookupByLibrary.simpleMessage(
                "Ver comentarios más recientes"),
        "post__comments_header_see_newest_replies":
            MessageLookupByLibrary.simpleMessage(
                "Ver respuestas más recientes"),
        "post__comments_header_see_oldest_comments":
            MessageLookupByLibrary.simpleMessage(
                "Ver comentarios más antiguos"),
        "post__comments_header_see_oldest_replies":
            MessageLookupByLibrary.simpleMessage("Ver respuestas más antiguas"),
        "post__comments_header_view_newest_comments":
            MessageLookupByLibrary.simpleMessage(
                "Ver comentarios más recientes"),
        "post__comments_header_view_newest_replies":
            MessageLookupByLibrary.simpleMessage(
                "Ver respuestas más recientes"),
        "post__comments_header_view_oldest_comments":
            MessageLookupByLibrary.simpleMessage(
                "Ver comentarios más antiguos"),
        "post__comments_header_view_oldest_replies":
            MessageLookupByLibrary.simpleMessage("Ver respuestas más antiguas"),
        "post__comments_page_no_more_replies_to_load":
            MessageLookupByLibrary.simpleMessage(
                "No hay más comentarios que cargar"),
        "post__comments_page_no_more_to_load":
            MessageLookupByLibrary.simpleMessage(
                "No hay más comentarios que cargar"),
        "post__comments_page_replies_title":
            MessageLookupByLibrary.simpleMessage("Respuestas"),
        "post__comments_page_tap_to_retry":
            MessageLookupByLibrary.simpleMessage(
                "Toca para reintentar cargar comentarios."),
        "post__comments_page_tap_to_retry_replies":
            MessageLookupByLibrary.simpleMessage(
                "Toca para reintentar cargar las respuestas."),
        "post__comments_page_title":
            MessageLookupByLibrary.simpleMessage("Comentarios"),
        "post__comments_view_all_comments": m26,
        "post__create_new": MessageLookupByLibrary.simpleMessage("Nuevo post"),
        "post__create_next": MessageLookupByLibrary.simpleMessage("Siguiente"),
        "post__create_photo": MessageLookupByLibrary.simpleMessage("Foto"),
        "post__disable_post_comments":
            MessageLookupByLibrary.simpleMessage("Deshabilitar comentarios"),
        "post__edit_save": MessageLookupByLibrary.simpleMessage("Guardar"),
        "post__edit_title": MessageLookupByLibrary.simpleMessage("Editar post"),
        "post__enable_post_comments":
            MessageLookupByLibrary.simpleMessage("Habilitar comentarios"),
        "post__have_not_shared_anything": MessageLookupByLibrary.simpleMessage(
            "Todavía no has compartido nada."),
        "post__is_closed": MessageLookupByLibrary.simpleMessage("Post cerrado"),
        "post__my_circles":
            MessageLookupByLibrary.simpleMessage("Mis círculos"),
        "post__my_circles_desc": MessageLookupByLibrary.simpleMessage(
            "Compartir con uno o varios de tus círculos."),
        "post__no_circles_for": m27,
        "post__open_post": MessageLookupByLibrary.simpleMessage("Abrir post"),
        "post__post_closed":
            MessageLookupByLibrary.simpleMessage("Post cerrado "),
        "post__post_opened":
            MessageLookupByLibrary.simpleMessage("Post abierto"),
        "post__post_reactions_title":
            MessageLookupByLibrary.simpleMessage("Reacciones del post"),
        "post__profile_counts_follower":
            MessageLookupByLibrary.simpleMessage(" Seguidor"),
        "post__profile_counts_followers":
            MessageLookupByLibrary.simpleMessage(" Seguidores"),
        "post__profile_counts_following":
            MessageLookupByLibrary.simpleMessage(" Siguiendo"),
        "post__profile_counts_post":
            MessageLookupByLibrary.simpleMessage(" Publicar"),
        "post__profile_counts_posts":
            MessageLookupByLibrary.simpleMessage(" Posts"),
        "post__reaction_list_tap_retry": MessageLookupByLibrary.simpleMessage(
            "Toca para reintentar cargar las reacciones."),
        "post__search_circles":
            MessageLookupByLibrary.simpleMessage("Buscar círculos..."),
        "post__share": MessageLookupByLibrary.simpleMessage("Compartir"),
        "post__share_community":
            MessageLookupByLibrary.simpleMessage("Compartir"),
        "post__share_community_desc": MessageLookupByLibrary.simpleMessage(
            "Compartir con una comunidad de la que eres parte."),
        "post__share_community_title":
            MessageLookupByLibrary.simpleMessage("A una comunidad"),
        "post__share_to": MessageLookupByLibrary.simpleMessage("Compartir con"),
        "post__share_to_circles":
            MessageLookupByLibrary.simpleMessage("Compartir en círculos"),
        "post__share_to_community":
            MessageLookupByLibrary.simpleMessage("Compartir con comunidad"),
        "post__shared_privately_on":
            MessageLookupByLibrary.simpleMessage("Compartido en privado en"),
        "post__sharing_post_to":
            MessageLookupByLibrary.simpleMessage("Compartiendo post a"),
        "post__text_copied":
            MessageLookupByLibrary.simpleMessage("Texto copiado!"),
        "post__time_short_days": MessageLookupByLibrary.simpleMessage("d"),
        "post__time_short_hours": MessageLookupByLibrary.simpleMessage("h"),
        "post__time_short_minutes": MessageLookupByLibrary.simpleMessage("m"),
        "post__time_short_now_text":
            MessageLookupByLibrary.simpleMessage("ahora"),
        "post__time_short_one_day": MessageLookupByLibrary.simpleMessage("1d"),
        "post__time_short_one_hour": MessageLookupByLibrary.simpleMessage("1h"),
        "post__time_short_one_minute":
            MessageLookupByLibrary.simpleMessage("1m"),
        "post__time_short_one_week": MessageLookupByLibrary.simpleMessage("1s"),
        "post__time_short_one_year": MessageLookupByLibrary.simpleMessage("1a"),
        "post__time_short_seconds": MessageLookupByLibrary.simpleMessage("s"),
        "post__time_short_weeks": MessageLookupByLibrary.simpleMessage("s"),
        "post__time_short_years": MessageLookupByLibrary.simpleMessage("a"),
        "post__timeline_posts_all_loaded":
            MessageLookupByLibrary.simpleMessage("🎉 Todos los posts cargados"),
        "post__timeline_posts_default_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Intenta refrescar la linea de tiempo."),
        "post__timeline_posts_default_drhoo_title":
            MessageLookupByLibrary.simpleMessage("Algo no está bien."),
        "post__timeline_posts_failed_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Inténtalo de nuevo en un par de segundos"),
        "post__timeline_posts_failed_drhoo_title":
            MessageLookupByLibrary.simpleMessage(
                "No se pudo cargar tu línea de tiempo."),
        "post__timeline_posts_no_more_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "¡Sigue a usuarios o únete a una comunidad para empezar!"),
        "post__timeline_posts_no_more_drhoo_title":
            MessageLookupByLibrary.simpleMessage(
                "Tu línea de tiempo está vacía."),
        "post__timeline_posts_refresh_posts":
            MessageLookupByLibrary.simpleMessage("Refrescar posts"),
        "post__timeline_posts_refreshing_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Cargando tu línea de tiempo."),
        "post__timeline_posts_refreshing_drhoo_title":
            MessageLookupByLibrary.simpleMessage("¡Ya casi!"),
        "post__trending_posts_no_trending_posts":
            MessageLookupByLibrary.simpleMessage(
                "No hay posts trending. Intenta refrescar en un par de segundos."),
        "post__trending_posts_refresh":
            MessageLookupByLibrary.simpleMessage("Refrescar"),
        "post__trending_posts_title":
            MessageLookupByLibrary.simpleMessage("Posts trending"),
        "post__user_has_not_shared_anything": m28,
        "post__usernames_circles": m29,
        "post__world_circle_name":
            MessageLookupByLibrary.simpleMessage("Mundo"),
        "post__you_shared_with":
            MessageLookupByLibrary.simpleMessage("Has compartido con"),
        "user__add_account_done": MessageLookupByLibrary.simpleMessage("Listo"),
        "user__add_account_save":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "user__add_account_success":
            MessageLookupByLibrary.simpleMessage("Listo"),
        "user__add_account_to_lists":
            MessageLookupByLibrary.simpleMessage("Agregar cuenta a lista"),
        "user__add_account_update_account_lists":
            MessageLookupByLibrary.simpleMessage(
                "Actualizar listas de cuentas"),
        "user__add_account_update_lists":
            MessageLookupByLibrary.simpleMessage("Actualizar listas"),
        "user__billion_postfix": MessageLookupByLibrary.simpleMessage("b"),
        "user__block_user":
            MessageLookupByLibrary.simpleMessage("Bloquear usuario"),
        "user__change_email_email_text":
            MessageLookupByLibrary.simpleMessage("Email"),
        "user__change_email_error":
            MessageLookupByLibrary.simpleMessage("Email ya está registrado"),
        "user__change_email_hint_text":
            MessageLookupByLibrary.simpleMessage("Ingresa tu email nuevo"),
        "user__change_email_save":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "user__change_email_success_info": MessageLookupByLibrary.simpleMessage(
            "Hemos enviado un enlace de confirmación a su nueva dirección de email, haz clic para verificar tu nuevo email"),
        "user__change_email_title":
            MessageLookupByLibrary.simpleMessage("Cambiar email"),
        "user__circle_name_empty_error": MessageLookupByLibrary.simpleMessage(
            "El nombre del círculo no puede estar vacío."),
        "user__circle_name_range_error": m30,
        "user__circle_peoples_count": m31,
        "user__clear_app_preferences_cleared_successfully":
            MessageLookupByLibrary.simpleMessage(
                "Preferencias borradas con éxito"),
        "user__clear_app_preferences_desc": MessageLookupByLibrary.simpleMessage(
            "Borrar las preferencias de la aplicación. Actualmente, este es sólo el orden preferido de comentarios."),
        "user__clear_app_preferences_error":
            MessageLookupByLibrary.simpleMessage(
                "No se pudieron borrar las preferencias"),
        "user__clear_app_preferences_title":
            MessageLookupByLibrary.simpleMessage("Borrar preferencias"),
        "user__clear_application_cache_desc":
            MessageLookupByLibrary.simpleMessage(
                "Limpiar posts, cuentas, imágenes & más del caché."),
        "user__clear_application_cache_failure":
            MessageLookupByLibrary.simpleMessage(
                "No se ha podido limpiar el caché"),
        "user__clear_application_cache_success":
            MessageLookupByLibrary.simpleMessage("Caché limpiada con éxito"),
        "user__clear_application_cache_text":
            MessageLookupByLibrary.simpleMessage("Limpiar caché"),
        "user__confirm_block_user_blocked":
            MessageLookupByLibrary.simpleMessage("Usuario bloqueado."),
        "user__confirm_block_user_info": MessageLookupByLibrary.simpleMessage(
            "No verán las publicaciones del otro ni podrán interactuar de ninguna manera."),
        "user__confirm_block_user_no":
            MessageLookupByLibrary.simpleMessage("No"),
        "user__confirm_block_user_question": m32,
        "user__confirm_block_user_title":
            MessageLookupByLibrary.simpleMessage("Confirmación"),
        "user__confirm_block_user_yes":
            MessageLookupByLibrary.simpleMessage("Sí"),
        "user__confirm_connection_add_connection":
            MessageLookupByLibrary.simpleMessage("Añadir conexión al círculo"),
        "user__confirm_connection_confirm_text":
            MessageLookupByLibrary.simpleMessage("Confirmar"),
        "user__confirm_connection_connection_confirmed":
            MessageLookupByLibrary.simpleMessage("Conexión confirmada"),
        "user__confirm_connection_with": m33,
        "user__confirm_guidelines_reject_chat_community":
            MessageLookupByLibrary.simpleMessage("Chatear con la comunidad."),
        "user__confirm_guidelines_reject_chat_immediately":
            MessageLookupByLibrary.simpleMessage(
                "Iniciar un chat inmediatamente."),
        "user__confirm_guidelines_reject_chat_with_team":
            MessageLookupByLibrary.simpleMessage("Chatear con el equipo."),
        "user__confirm_guidelines_reject_delete_account":
            MessageLookupByLibrary.simpleMessage("Eliminar cuenta"),
        "user__confirm_guidelines_reject_go_back":
            MessageLookupByLibrary.simpleMessage("Volver"),
        "user__confirm_guidelines_reject_info":
            MessageLookupByLibrary.simpleMessage(
                "No puedes usar Somus hasta que aceptes las reglas."),
        "user__confirm_guidelines_reject_join_slack":
            MessageLookupByLibrary.simpleMessage("Únete al canal Slack."),
        "user__confirm_guidelines_reject_title":
            MessageLookupByLibrary.simpleMessage("Rechazo de reglas"),
        "user__connect_to_user_add_connection":
            MessageLookupByLibrary.simpleMessage("Añadir conexión al círculo"),
        "user__connect_to_user_connect_with_username": m34,
        "user__connect_to_user_done":
            MessageLookupByLibrary.simpleMessage("Listo"),
        "user__connect_to_user_request_sent":
            MessageLookupByLibrary.simpleMessage(
                "Solicitud de conexión enviada"),
        "user__connection_circle_edit":
            MessageLookupByLibrary.simpleMessage("Editar"),
        "user__connection_pending":
            MessageLookupByLibrary.simpleMessage("Pendiente"),
        "user__connections_circle_delete":
            MessageLookupByLibrary.simpleMessage("Eliminar"),
        "user__connections_header_circle_desc":
            MessageLookupByLibrary.simpleMessage(
                "El círculo al que se agregan todas tus conexiones."),
        "user__connections_header_users":
            MessageLookupByLibrary.simpleMessage("Usuarios"),
        "user__delete_account_confirmation_desc":
            MessageLookupByLibrary.simpleMessage(
                "¿Seguro que deseas eliminar tu cuenta?"),
        "user__delete_account_confirmation_desc_info":
            MessageLookupByLibrary.simpleMessage(
                "Ésta acción es permanente y no se puede deshacer."),
        "user__delete_account_confirmation_goodbye":
            MessageLookupByLibrary.simpleMessage("Adiós 😢"),
        "user__delete_account_confirmation_no":
            MessageLookupByLibrary.simpleMessage("No"),
        "user__delete_account_confirmation_title":
            MessageLookupByLibrary.simpleMessage("Confirmación"),
        "user__delete_account_confirmation_yes":
            MessageLookupByLibrary.simpleMessage("Sí"),
        "user__delete_account_current_pwd":
            MessageLookupByLibrary.simpleMessage("Contraseña actual"),
        "user__delete_account_current_pwd_hint":
            MessageLookupByLibrary.simpleMessage(
                "Ingresa tu contraseña actual"),
        "user__delete_account_next":
            MessageLookupByLibrary.simpleMessage("Siguiente"),
        "user__delete_account_title":
            MessageLookupByLibrary.simpleMessage("Eliminar cuenta"),
        "user__disconnect_from_user": m35,
        "user__disconnect_from_user_success":
            MessageLookupByLibrary.simpleMessage("Desconectado exitosamente"),
        "user__edit_profile_bio": MessageLookupByLibrary.simpleMessage("Bio"),
        "user__edit_profile_delete":
            MessageLookupByLibrary.simpleMessage("Eliminar"),
        "user__edit_profile_followers_count":
            MessageLookupByLibrary.simpleMessage("Número de seguidores"),
        "user__edit_profile_location":
            MessageLookupByLibrary.simpleMessage("Ubicación"),
        "user__edit_profile_name":
            MessageLookupByLibrary.simpleMessage("Nombre"),
        "user__edit_profile_pick_image":
            MessageLookupByLibrary.simpleMessage("Elegir imagen"),
        "user__edit_profile_pick_image_error_too_large": m36,
        "user__edit_profile_save_text":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "user__edit_profile_title":
            MessageLookupByLibrary.simpleMessage("Editar perfil"),
        "user__edit_profile_url":
            MessageLookupByLibrary.simpleMessage("Enlace"),
        "user__edit_profile_user_name_taken": m37,
        "user__edit_profile_username":
            MessageLookupByLibrary.simpleMessage("Nombre de usuario"),
        "user__email_verification_error": MessageLookupByLibrary.simpleMessage(
            "¡Uy! Tu token no fue válido o ha expirado, por favor intentar de nuevo"),
        "user__email_verification_successful":
            MessageLookupByLibrary.simpleMessage(
                "¡Genial! Tu email ya está verificado"),
        "user__emoji_field_none_selected":
            MessageLookupByLibrary.simpleMessage("No hay emoji seleccionado"),
        "user__emoji_search_none_found": m38,
        "user__follow_button_follow_text":
            MessageLookupByLibrary.simpleMessage("Seguir"),
        "user__follow_button_unfollow_text":
            MessageLookupByLibrary.simpleMessage("Siguiendo"),
        "user__follow_lists_no_list_found":
            MessageLookupByLibrary.simpleMessage("No se encontraron listas."),
        "user__follow_lists_no_list_found_for": m39,
        "user__follow_lists_search_for":
            MessageLookupByLibrary.simpleMessage("Buscar una lista..."),
        "user__follow_lists_title":
            MessageLookupByLibrary.simpleMessage("Mis listas"),
        "user__follower_plural":
            MessageLookupByLibrary.simpleMessage("seguidores"),
        "user__follower_singular":
            MessageLookupByLibrary.simpleMessage("seguidor"),
        "user__followers_title":
            MessageLookupByLibrary.simpleMessage("Seguidores"),
        "user__following_resource_name":
            MessageLookupByLibrary.simpleMessage("usuarios seguidos"),
        "user__following_text":
            MessageLookupByLibrary.simpleMessage("Siguiendo"),
        "user__follows_list_accounts_count": m40,
        "user__follows_list_edit":
            MessageLookupByLibrary.simpleMessage("Editar"),
        "user__follows_list_header_title":
            MessageLookupByLibrary.simpleMessage("Usuarios"),
        "user__follows_lists_account":
            MessageLookupByLibrary.simpleMessage("1 Cuenta"),
        "user__follows_lists_accounts": m41,
        "user__groups_see_all": m42,
        "user__guidelines_accept":
            MessageLookupByLibrary.simpleMessage("Aceptar"),
        "user__guidelines_desc": MessageLookupByLibrary.simpleMessage(
            "Por favor, tómate un momento para leer y aceptar nuestras reglas."),
        "user__guidelines_reject":
            MessageLookupByLibrary.simpleMessage("Rechazar"),
        "user__invite": MessageLookupByLibrary.simpleMessage("Invitar"),
        "user__invite_member": MessageLookupByLibrary.simpleMessage("Miembro"),
        "user__invite_someone_message": m43,
        "user__invites_accepted_group_item_name":
            MessageLookupByLibrary.simpleMessage("invitación aceptada"),
        "user__invites_accepted_group_name":
            MessageLookupByLibrary.simpleMessage("invitaciones aceptadas"),
        "user__invites_accepted_title":
            MessageLookupByLibrary.simpleMessage("Aceptada"),
        "user__invites_create_create":
            MessageLookupByLibrary.simpleMessage("Crear"),
        "user__invites_create_create_title":
            MessageLookupByLibrary.simpleMessage("Crear invitación"),
        "user__invites_create_edit_title":
            MessageLookupByLibrary.simpleMessage("Editar invitación"),
        "user__invites_create_name_hint":
            MessageLookupByLibrary.simpleMessage("por ejemplo Juan Gabriel"),
        "user__invites_create_name_title":
            MessageLookupByLibrary.simpleMessage("Nickname"),
        "user__invites_create_save":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "user__invites_delete":
            MessageLookupByLibrary.simpleMessage("Eliminar"),
        "user__invites_edit_text":
            MessageLookupByLibrary.simpleMessage("Editar"),
        "user__invites_email_hint": MessageLookupByLibrary.simpleMessage(
            "por ejemplo juanga@email.com"),
        "user__invites_email_invite_text":
            MessageLookupByLibrary.simpleMessage("Invitación por email"),
        "user__invites_email_send_text":
            MessageLookupByLibrary.simpleMessage("Enviar"),
        "user__invites_email_sent_text":
            MessageLookupByLibrary.simpleMessage("Email de invitación enviado"),
        "user__invites_email_text":
            MessageLookupByLibrary.simpleMessage("Email"),
        "user__invites_invite_a_friend":
            MessageLookupByLibrary.simpleMessage("Invitar a un amigo"),
        "user__invites_invite_text":
            MessageLookupByLibrary.simpleMessage("Invitar"),
        "user__invites_joined_with": m44,
        "user__invites_none_left": MessageLookupByLibrary.simpleMessage(
            "No tienes invitaciones disponibles."),
        "user__invites_none_used": MessageLookupByLibrary.simpleMessage(
            "Parece que no has usado ninguna invitación."),
        "user__invites_pending":
            MessageLookupByLibrary.simpleMessage("Pendiente"),
        "user__invites_pending_email": m45,
        "user__invites_pending_group_item_name":
            MessageLookupByLibrary.simpleMessage("invitación pendiente"),
        "user__invites_pending_group_name":
            MessageLookupByLibrary.simpleMessage("invitaciones pendientes"),
        "user__invites_refresh":
            MessageLookupByLibrary.simpleMessage("Refrescar"),
        "user__invites_share_email": MessageLookupByLibrary.simpleMessage(
            "Compartir invitación por correo"),
        "user__invites_share_email_desc": MessageLookupByLibrary.simpleMessage(
            "Enviaremos un correo electrónico de invitación con instrucciones en tu nombre"),
        "user__invites_share_yourself":
            MessageLookupByLibrary.simpleMessage("Compartir invitación"),
        "user__invites_share_yourself_desc":
            MessageLookupByLibrary.simpleMessage(
                "Ecoger de apps de mensajería, etc."),
        "user__invites_title":
            MessageLookupByLibrary.simpleMessage("Mis invitaciones"),
        "user__language_settings_save":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "user__language_settings_saved_success":
            MessageLookupByLibrary.simpleMessage("Idioma cambiado con éxito"),
        "user__language_settings_title":
            MessageLookupByLibrary.simpleMessage("Configuración de idioma"),
        "user__list_name_empty_error": MessageLookupByLibrary.simpleMessage(
            "El nombre de la lista no puede estar vacío."),
        "user__list_name_range_error": m46,
        "user__million_postfix": MessageLookupByLibrary.simpleMessage("m"),
        "user__profile_action_cancel_connection":
            MessageLookupByLibrary.simpleMessage(
                "Cancelar solicitud de conexión"),
        "user__profile_action_deny_connection":
            MessageLookupByLibrary.simpleMessage(
                "Rechazar solicitud de conexión"),
        "user__profile_action_user_blocked":
            MessageLookupByLibrary.simpleMessage("Usuario bloqueado"),
        "user__profile_action_user_unblocked":
            MessageLookupByLibrary.simpleMessage("Usuario desbloqueado"),
        "user__profile_bio_length_error": m47,
        "user__profile_location_length_error": m48,
        "user__profile_url_invalid_error": MessageLookupByLibrary.simpleMessage(
            "Por favor ingresa una url válida."),
        "user__remove_account_from_list":
            MessageLookupByLibrary.simpleMessage("Eliminar cuenta de listas"),
        "user__remove_account_from_list_success":
            MessageLookupByLibrary.simpleMessage("Éxito"),
        "user__save_connection_circle_color_hint":
            MessageLookupByLibrary.simpleMessage("(Toca para cambiar)"),
        "user__save_connection_circle_color_name":
            MessageLookupByLibrary.simpleMessage("Color"),
        "user__save_connection_circle_create":
            MessageLookupByLibrary.simpleMessage("Crear círculo"),
        "user__save_connection_circle_edit":
            MessageLookupByLibrary.simpleMessage("Editar círculo"),
        "user__save_connection_circle_hint":
            MessageLookupByLibrary.simpleMessage(
                "por ejemplo, Amigos, Familia, Trabajo."),
        "user__save_connection_circle_name":
            MessageLookupByLibrary.simpleMessage("Nombre"),
        "user__save_connection_circle_name_taken": m49,
        "user__save_connection_circle_save":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "user__save_connection_circle_users":
            MessageLookupByLibrary.simpleMessage("Usuarios"),
        "user__save_follows_list_create":
            MessageLookupByLibrary.simpleMessage("Crear lista"),
        "user__save_follows_list_edit":
            MessageLookupByLibrary.simpleMessage("Editar lista"),
        "user__save_follows_list_emoji":
            MessageLookupByLibrary.simpleMessage("Emoji"),
        "user__save_follows_list_emoji_required_error":
            MessageLookupByLibrary.simpleMessage("Emoji es requerido"),
        "user__save_follows_list_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "por ejemplo, Viajes, Fotografía, Gaming"),
        "user__save_follows_list_name":
            MessageLookupByLibrary.simpleMessage("Nombre"),
        "user__save_follows_list_name_taken": m50,
        "user__save_follows_list_save":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "user__save_follows_list_users":
            MessageLookupByLibrary.simpleMessage("Usuarios"),
        "user__thousand_postfix": MessageLookupByLibrary.simpleMessage("k"),
        "user__tile_delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "user__tile_following":
            MessageLookupByLibrary.simpleMessage(" · Siguiendo"),
        "user__timeline_filters_apply_all":
            MessageLookupByLibrary.simpleMessage("Aplicar filtros"),
        "user__timeline_filters_circles":
            MessageLookupByLibrary.simpleMessage("Círculos"),
        "user__timeline_filters_clear_all":
            MessageLookupByLibrary.simpleMessage("Borrar todo"),
        "user__timeline_filters_lists":
            MessageLookupByLibrary.simpleMessage("Listas"),
        "user__timeline_filters_no_match": m51,
        "user__timeline_filters_search_desc":
            MessageLookupByLibrary.simpleMessage("Buscar círculos y listas..."),
        "user__timeline_filters_title":
            MessageLookupByLibrary.simpleMessage("Filtros de línea de tiempo"),
        "user__translate_see_translation":
            MessageLookupByLibrary.simpleMessage("Ver traducción"),
        "user__translate_show_original":
            MessageLookupByLibrary.simpleMessage("Mostrar original"),
        "user__unblock_user":
            MessageLookupByLibrary.simpleMessage("Desbloquear usuario"),
        "user__uninvite": MessageLookupByLibrary.simpleMessage("Invitado"),
        "user__update_connection_circle_save":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "user__update_connection_circle_updated":
            MessageLookupByLibrary.simpleMessage("Conexión actualizada"),
        "user__update_connection_circles_title":
            MessageLookupByLibrary.simpleMessage(
                "Actualizar círculos de conexión"),
        "user_search__cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "user_search__communities":
            MessageLookupByLibrary.simpleMessage("Comunidades"),
        "user_search__list_no_results_found": m52,
        "user_search__list_refresh_text":
            MessageLookupByLibrary.simpleMessage("Refrescar"),
        "user_search__list_retry":
            MessageLookupByLibrary.simpleMessage("Toca para reintentar."),
        "user_search__list_search_text": m53,
        "user_search__no_communities_for": m54,
        "user_search__no_results_for": m55,
        "user_search__no_users_for": m56,
        "user_search__search_text":
            MessageLookupByLibrary.simpleMessage("Buscar..."),
        "user_search__searching_for": m57,
        "user_search__users": MessageLookupByLibrary.simpleMessage("Usuarios")
      };
}
