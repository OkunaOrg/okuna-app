// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_BR locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt_BR';

  static m0(minLength, maxLength) => "(${minLength}-${maxLength} caracteres)";

  static m1(minLength, maxLength) =>
      "A descrição deve ter entre ${minLength} e ${maxLength} caracteres.";

  static m2(minLength, maxLength) =>
      "O nome deve ter entre ${minLength} e ${maxLength} caracteres.";

  static m3(minLength, maxLength) =>
      "A senha deve ter entre ${minLength} e ${maxLength} caracteres.";

  static m4(maxLength) =>
      "Um nome de usuário não pode ser maior que ${maxLength} caracteres.";

  static m5(maxLength) =>
      "Os adjetivos não podem ser mais longos que ${maxLength} caracteres.";

  static m6(username) =>
      "Você tem certeza de que deseja adicionar @${username} como administrador da comunidade?";

  static m7(username) => "Você tem certeza de que deseja banir @${username}?";

  static m8(maxLength) =>
      "A descrição não pode ser maior que ${maxLength} caracteres.";

  static m9(username) =>
      "Você tem certeza de que deseja adicionar @${username} como moderador da comunidade?";

  static m10(maxLength) =>
      "O nome não pode ser maior que ${maxLength} caracteres.";

  static m11(min) => "Você deve escolher pelo menos ${min} categorias.";

  static m12(min) => "Você deve escolher pelo menos ${min} categoria.";

  static m13(max) => "Escolha até ${max} categorias";

  static m14(maxLength) =>
      "As regras não podem ser maiores que ${maxLength} caracteres.";

  static m15(takenName) =>
      "O nome \'${takenName}\' já está sendo usado por outra comunidade";

  static m16(maxLength) =>
      "O título não pode ser maior que ${maxLength} caracteres.";

  static m17(categoryName) => "Populares em ${categoryName}";

  static m18(hashtag) => "Você será o primeiro a usar #${hashtag}";

  static m19(platform) => "Executando em ${platform}";

  static m20(currentUserLanguage) => "Idioma (${currentUserLanguage})";

  static m21(limit) => "Arquivo muito grande (limite: ${limit} MB)";

  static m22(resourceCount, resourceName) =>
      "Ver todas as ${resourceCount} ${resourceName}";

  static m23(postCommentText) =>
      "[name] [username] também comentou: ${postCommentText}";

  static m24(postCommentText) =>
      "[name] [username] comentou no seu post: ${postCommentText}";

  static m25(postCommentText) =>
      "[name] [username] também respondeu: ${postCommentText}";

  static m26(postCommentText) =>
      "[name] [username] respondeu: ${postCommentText}";

  static m27(communityName) => "Houve uma nova postagem em c/${communityName}.";

  static m28(postCommentText) =>
      "[name] [username] mencionou você em um comentário: ${postCommentText}";

  static m29(communityName) =>
      "[name] [username] convidou você para se juntar à comunidade /c/${communityName}.";

  static m30(maxLength) =>
      "Um comentário não pode ter mais de ${maxLength} caracteres.";

  static m31(commentsCount) => "Ver todos os comentários (${commentsCount})";

  static m32(maxHashtags, maxCharacters) =>
      "Please add a maximum of ${maxHashtags} hashtags and keep them under ${maxCharacters} characters.";

  static m33(circlesSearchQuery) =>
      "Nenhum círculo encontrado para \'${circlesSearchQuery}\'.";

  static m34(name) => "${name} ainda não compartilhou nada.";

  static m35(postCreatorUsername) => "círculos de @${postCreatorUsername}";

  static m36(description) =>
      "Falha ao pré-visualizar o link com erro no site: ${description}";

  static m37(maxLength) =>
      "O nome do círculo não deve ter mais de ${maxLength} caracteres.";

  static m38(prettyUsersCount) => "${prettyUsersCount} pessoas";

  static m39(username) => "Tem certeza de que deseja bloquear @${username}?";

  static m40(userName) => "Confirmar a conexão com ${userName}";

  static m41(userName) => "Conectar-se com ${userName}";

  static m42(userName) => "Desconectar-se de ${userName}";

  static m43(limit) => "Imagem muito grande (limite: ${limit} MB)";

  static m44(username) => "O nome de usuário @${username} já está em uso";

  static m45(searchQuery) => "Nenhum emoji encontrado para \'${searchQuery}\'.";

  static m46(searchQuery) => "Nenhuma lista encontrada para \'${searchQuery}\'";

  static m47(prettyUsersCount) => "${prettyUsersCount} contas";

  static m48(prettyUsersCount) => "${prettyUsersCount} Contas";

  static m49(groupName) => "Ver ${groupName}";

  static m50(iosLink, testFlightLink, androidLink, inviteLink) =>
      "Ei, eu gostaria de convidar você para a rede social Somus.\n\nSe tiver iOS, primeiro, baixe o aplicativo TestFlight na App Store (${testFlightLink}) e, em seguida, baixe o aplicativo Somus (${iosLink})\n\nSe tiver Android, faça o download na Play Store (${androidLink}).\n\nDepois, cole este link de convite personalizado no formulário \'Cadastrar-se\' no aplicativo Somus: ${inviteLink}";

  static m51(username) => "Entrou com o nome de usuário @${username}";

  static m52(email) => "Pendente, convite enviado para o email ${email}";

  static m53(maxLength) =>
      "O nome da lista não deve ter mais de ${maxLength} caracteres.";

  static m54(maxLength) =>
      "A bio não pode ser maior que ${maxLength} caracteres.";

  static m55(maxLength) =>
      "O local não pode ser maior que ${maxLength} caracteres.";

  static m56(age) => "Na Somus desde ${age}";

  static m57(takenConnectionsCircleName) =>
      "O nome de círculo \'${takenConnectionsCircleName}\' já está em uso";

  static m58(listName) => "O nome de lista \'${listName}\' já está sendo usado";

  static m59(searchQuery) => "Nada encontrado para \'${searchQuery}\'.";

  static m60(resourcePluralName) => "Sem ${resourcePluralName}.";

  static m61(resourcePluralName) => "Pesquisar ${resourcePluralName} ...";

  static m62(searchQuery) =>
      "Nenhuma comunidade encontrada para \'${searchQuery}\'.";

  static m63(searchQuery) =>
      "Não foram encontradas hashtags para \'${searchQuery}\'.";

  static m64(searchQuery) => "Nenhum resultado para \'${searchQuery}\'.";

  static m65(searchQuery) =>
      "Nenhum usuário encontrado para \'${searchQuery}\'.";

  static m66(searchQuery) => "Procurando por \'${searchQuery}\'";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "application_settings__comment_sort_newest_first":
            MessageLookupByLibrary.simpleMessage("Mais recentes"),
        "application_settings__comment_sort_oldest_first":
            MessageLookupByLibrary.simpleMessage("Mais antigos"),
        "application_settings__link_previews":
            MessageLookupByLibrary.simpleMessage("Prévia do link"),
        "application_settings__link_previews_autoplay_always":
            MessageLookupByLibrary.simpleMessage("Sempre"),
        "application_settings__link_previews_autoplay_never":
            MessageLookupByLibrary.simpleMessage("Nunca"),
        "application_settings__link_previews_autoplay_wifi_only":
            MessageLookupByLibrary.simpleMessage("Somente Wi-Fi"),
        "application_settings__link_previews_show":
            MessageLookupByLibrary.simpleMessage("Mostrar"),
        "application_settings__tap_to_change":
            MessageLookupByLibrary.simpleMessage("(Toque para alterar)"),
        "application_settings__videos":
            MessageLookupByLibrary.simpleMessage("Vídeos"),
        "application_settings__videos_autoplay":
            MessageLookupByLibrary.simpleMessage("Reprodução automática"),
        "application_settings__videos_autoplay_always":
            MessageLookupByLibrary.simpleMessage("Sempre"),
        "application_settings__videos_autoplay_never":
            MessageLookupByLibrary.simpleMessage("Nunca"),
        "application_settings__videos_autoplay_wifi_only":
            MessageLookupByLibrary.simpleMessage("Somente Wi-Fi"),
        "application_settings__videos_sound":
            MessageLookupByLibrary.simpleMessage("Som"),
        "application_settings__videos_sound_disabled":
            MessageLookupByLibrary.simpleMessage("Desabilitado"),
        "application_settings__videos_sound_enabled":
            MessageLookupByLibrary.simpleMessage("Habilitado"),
        "auth__change_password_current_pwd":
            MessageLookupByLibrary.simpleMessage("Senha atual"),
        "auth__change_password_current_pwd_hint":
            MessageLookupByLibrary.simpleMessage("Digite sua senha atual"),
        "auth__change_password_current_pwd_incorrect":
            MessageLookupByLibrary.simpleMessage(
                "A senha inserida está incorreta"),
        "auth__change_password_new_pwd":
            MessageLookupByLibrary.simpleMessage("Nova senha"),
        "auth__change_password_new_pwd_error": MessageLookupByLibrary.simpleMessage(
            "Por favor, certifique-se de que a senha tenha entre 10 e 100 caracteres"),
        "auth__change_password_new_pwd_hint":
            MessageLookupByLibrary.simpleMessage("Digite sua nova senha"),
        "auth__change_password_save_success":
            MessageLookupByLibrary.simpleMessage(
                "Tudo certo! Sua senha foi atualizada"),
        "auth__change_password_save_text":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "auth__change_password_title":
            MessageLookupByLibrary.simpleMessage("Alterar senha"),
        "auth__create_acc__almost_there":
            MessageLookupByLibrary.simpleMessage("Quase lá..."),
        "auth__create_acc__are_you_legal_age":
            MessageLookupByLibrary.simpleMessage("Você tem mais de 16 anos?"),
        "auth__create_acc__avatar_choose_camera":
            MessageLookupByLibrary.simpleMessage("Tirar uma foto"),
        "auth__create_acc__avatar_choose_gallery":
            MessageLookupByLibrary.simpleMessage("Usar uma foto existente"),
        "auth__create_acc__avatar_remove_photo":
            MessageLookupByLibrary.simpleMessage("Remover foto"),
        "auth__create_acc__avatar_tap_to_change":
            MessageLookupByLibrary.simpleMessage("Toque para alterar"),
        "auth__create_acc__can_change_username":
            MessageLookupByLibrary.simpleMessage(
                "Se desejar, você pode alterá-lo a qualquer momento através da sua página de perfil."),
        "auth__create_acc__congratulations":
            MessageLookupByLibrary.simpleMessage("Parabéns!"),
        "auth__create_acc__create_account":
            MessageLookupByLibrary.simpleMessage("Criar uma conta"),
        "auth__create_acc__done":
            MessageLookupByLibrary.simpleMessage("Criar conta"),
        "auth__create_acc__done_continue":
            MessageLookupByLibrary.simpleMessage("Entrar"),
        "auth__create_acc__done_created": MessageLookupByLibrary.simpleMessage(
            "Sua conta foi criada com sucesso."),
        "auth__create_acc__done_description":
            MessageLookupByLibrary.simpleMessage(
                "Sua conta foi criada com sucesso."),
        "auth__create_acc__done_subtext": MessageLookupByLibrary.simpleMessage(
            "Você pode mudar isso nas configurações de perfil."),
        "auth__create_acc__done_title":
            MessageLookupByLibrary.simpleMessage("Aeee!"),
        "auth__create_acc__email_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "😱 Seu email não pode ficar vazio"),
        "auth__create_acc__email_invalid_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Por favor, forneça um endereço de email válido."),
        "auth__create_acc__email_placeholder":
            MessageLookupByLibrary.simpleMessage("gisele_bundchen@mail.com"),
        "auth__create_acc__email_server_error":
            MessageLookupByLibrary.simpleMessage(
                "😭 Estamos com problemas em nossos servidores, por favor tente novamente em alguns minutos."),
        "auth__create_acc__email_taken_error":
            MessageLookupByLibrary.simpleMessage(
                "🤔 Já existe uma conta associada a esse email."),
        "auth__create_acc__invalid_token":
            MessageLookupByLibrary.simpleMessage("Token inválido"),
        "auth__create_acc__lets_get_started":
            MessageLookupByLibrary.simpleMessage("Vamos começar"),
        "auth__create_acc__link_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "O campo de link não pode ficar vazio."),
        "auth__create_acc__link_invalid_error":
            MessageLookupByLibrary.simpleMessage("Este link é inválido."),
        "auth__create_acc__name_characters_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Um nome só pode conter caracteres alfanuméricos (por enquanto)."),
        "auth__create_acc__name_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "😱 Seu nome não pode ficar vazio."),
        "auth__create_acc__name_length_error": MessageLookupByLibrary.simpleMessage(
            "😱 Seu nome não pode ter mais de 50 caracteres. (Se ele tem, lamentamos muito.)"),
        "auth__create_acc__name_placeholder":
            MessageLookupByLibrary.simpleMessage("Ayrton Senna"),
        "auth__create_acc__next":
            MessageLookupByLibrary.simpleMessage("Avançar"),
        "auth__create_acc__one_last_thing":
            MessageLookupByLibrary.simpleMessage("Uma última coisa..."),
        "auth__create_acc__password_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "😱 Sua senha não pode ficar vazia"),
        "auth__create_acc__password_length_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Sua senha precisa ter entre 10 e 100 caracteres."),
        "auth__create_acc__paste_link": MessageLookupByLibrary.simpleMessage(
            "Cole seu link de registro abaixo"),
        "auth__create_acc__paste_link_help_text":
            MessageLookupByLibrary.simpleMessage(
                "Use o link do seu convite recebido por email."),
        "auth__create_acc__paste_password_reset_link":
            MessageLookupByLibrary.simpleMessage(
                "Cole o link de redefinição de senha abaixo"),
        "auth__create_acc__previous":
            MessageLookupByLibrary.simpleMessage("Voltar"),
        "auth__create_acc__register":
            MessageLookupByLibrary.simpleMessage("Criar minha conta"),
        "auth__create_acc__request_invite":
            MessageLookupByLibrary.simpleMessage(
                "Sem convite? Solicite um aqui."),
        "auth__create_acc__submit_error_desc_server":
            MessageLookupByLibrary.simpleMessage(
                "😭 Estamos com problemas em nossos servidores, por favor tente novamente em alguns minutos."),
        "auth__create_acc__submit_error_desc_validation":
            MessageLookupByLibrary.simpleMessage(
                "😅 Parece que algumas das informações não estavam corretas, por favor, verifique e tente novamente."),
        "auth__create_acc__submit_error_title":
            MessageLookupByLibrary.simpleMessage("Ah não..."),
        "auth__create_acc__submit_loading_desc":
            MessageLookupByLibrary.simpleMessage("Estamos criando sua conta."),
        "auth__create_acc__submit_loading_title":
            MessageLookupByLibrary.simpleMessage("Aguenta aí!"),
        "auth__create_acc__subscribe":
            MessageLookupByLibrary.simpleMessage("Solicitar"),
        "auth__create_acc__subscribe_to_waitlist_text":
            MessageLookupByLibrary.simpleMessage("Solicitar um convite!"),
        "auth__create_acc__suggested_communities":
            MessageLookupByLibrary.simpleMessage(
                "🥳 Comece participando das seguintes comunidades."),
        "auth__create_acc__username_characters_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Um nome de usuário deve conter apenas caracteres alfanuméricos e underlines (_)."),
        "auth__create_acc__username_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "😱 O nome de usuário não pode ficar vazio."),
        "auth__create_acc__username_length_error":
            MessageLookupByLibrary.simpleMessage(
                "😅 Um nome de usuário não pode ter mais de 30 caracteres."),
        "auth__create_acc__username_placeholder":
            MessageLookupByLibrary.simpleMessage("santosdumont"),
        "auth__create_acc__username_server_error":
            MessageLookupByLibrary.simpleMessage(
                "😭 Estamos com problemas em nossos servidores, por favor tente novamente em alguns minutos."),
        "auth__create_acc__username_taken_error":
            MessageLookupByLibrary.simpleMessage(
                "😩 O nome de usuário @%s já está em uso."),
        "auth__create_acc__validating_token":
            MessageLookupByLibrary.simpleMessage("Validando token..."),
        "auth__create_acc__welcome_to_beta":
            MessageLookupByLibrary.simpleMessage("Bem-vindo(a) à Beta!"),
        "auth__create_acc__what_avatar": MessageLookupByLibrary.simpleMessage(
            "Escolha uma imagem de perfil"),
        "auth__create_acc__what_email":
            MessageLookupByLibrary.simpleMessage("Qual é o seu email?"),
        "auth__create_acc__what_name":
            MessageLookupByLibrary.simpleMessage("Qual é o seu nome?"),
        "auth__create_acc__what_password":
            MessageLookupByLibrary.simpleMessage("Escolha uma senha"),
        "auth__create_acc__what_password_subtext":
            MessageLookupByLibrary.simpleMessage("(mín. 10 caracteres)"),
        "auth__create_acc__what_username":
            MessageLookupByLibrary.simpleMessage("Escolha um nome de usuário"),
        "auth__create_acc__your_subscribed":
            MessageLookupByLibrary.simpleMessage(
                "Você é o número {0} da lista de espera."),
        "auth__create_acc__your_username_is":
            MessageLookupByLibrary.simpleMessage("Seu nome de usuário é "),
        "auth__create_acc_password_hint_text": m0,
        "auth__create_account":
            MessageLookupByLibrary.simpleMessage("Cadastrar-se"),
        "auth__description_empty_error": MessageLookupByLibrary.simpleMessage(
            "A descrição não pode ficar vazia."),
        "auth__description_range_error": m1,
        "auth__email_empty_error": MessageLookupByLibrary.simpleMessage(
            "O email não pode ficar vazio."),
        "auth__email_invalid_error": MessageLookupByLibrary.simpleMessage(
            "Por favor, forneça um email válido."),
        "auth__headline":
            MessageLookupByLibrary.simpleMessage("Uma rede social melhor."),
        "auth__login": MessageLookupByLibrary.simpleMessage("Entrar"),
        "auth__login__connection_error": MessageLookupByLibrary.simpleMessage(
            "Não conseguimos alcançar nossos servidores. Você está conectado à internet?"),
        "auth__login__credentials_mismatch_error":
            MessageLookupByLibrary.simpleMessage(
                "As credenciais fornecidas não coincidem."),
        "auth__login__email_label":
            MessageLookupByLibrary.simpleMessage("Email"),
        "auth__login__forgot_password":
            MessageLookupByLibrary.simpleMessage("Esqueci a senha"),
        "auth__login__forgot_password_subtitle":
            MessageLookupByLibrary.simpleMessage("Digite seu email"),
        "auth__login__login": MessageLookupByLibrary.simpleMessage("Continuar"),
        "auth__login__password_empty_error":
            MessageLookupByLibrary.simpleMessage("A senha é necessária."),
        "auth__login__password_label":
            MessageLookupByLibrary.simpleMessage("Senha"),
        "auth__login__password_length_error":
            MessageLookupByLibrary.simpleMessage(
                "Sua senha deve ter entre 10 e 100 caracteres."),
        "auth__login__previous": MessageLookupByLibrary.simpleMessage("Voltar"),
        "auth__login__server_error": MessageLookupByLibrary.simpleMessage(
            "Ops... Estamos passando por problemas em nossos servidores. Por favor, tente novamente em alguns minutos."),
        "auth__login__subtitle": MessageLookupByLibrary.simpleMessage(
            "Insira suas credenciais para continuar."),
        "auth__login__title":
            MessageLookupByLibrary.simpleMessage("Bem-vindo(a) de volta!"),
        "auth__login__username_characters_error":
            MessageLookupByLibrary.simpleMessage(
                "O nome de usuário só pode conter caracteres alfanuméricos e underlines (_)."),
        "auth__login__username_empty_error":
            MessageLookupByLibrary.simpleMessage(
                "O nome de usuário é necessário."),
        "auth__login__username_label":
            MessageLookupByLibrary.simpleMessage("Nome de usuário"),
        "auth__login__username_length_error":
            MessageLookupByLibrary.simpleMessage(
                "O nome de usuário não pode ter mais de 30 caracteres."),
        "auth__name_empty_error": MessageLookupByLibrary.simpleMessage(
            "O nome não pode ficar vazio."),
        "auth__name_range_error": m2,
        "auth__password_empty_error": MessageLookupByLibrary.simpleMessage(
            "A senha não pode ficar vazia."),
        "auth__password_range_error": m3,
        "auth__reset_password_success_info":
            MessageLookupByLibrary.simpleMessage(
                "Sua senha foi alterada com sucesso"),
        "auth__reset_password_success_title":
            MessageLookupByLibrary.simpleMessage("Tudo pronto!"),
        "auth__username_characters_error": MessageLookupByLibrary.simpleMessage(
            "Um nome de usuário só pode conter caracteres alfanuméricos e underlines (_)."),
        "auth__username_empty_error": MessageLookupByLibrary.simpleMessage(
            "O nome de usuário não pode ficar vazio."),
        "auth__username_maxlength_error": m4,
        "bottom_sheets__confirm_action_are_you_sure":
            MessageLookupByLibrary.simpleMessage("Tem certeza?"),
        "bottom_sheets__confirm_action_no":
            MessageLookupByLibrary.simpleMessage("Não"),
        "bottom_sheets__confirm_action_yes":
            MessageLookupByLibrary.simpleMessage("Sim"),
        "community__about": MessageLookupByLibrary.simpleMessage("Sobre"),
        "community__actions_disable_new_post_notifications_success":
            MessageLookupByLibrary.simpleMessage(
                "New post notifications enabled"),
        "community__actions_disable_new_post_notifications_title":
            MessageLookupByLibrary.simpleMessage(
                "Desativar notificações de postagens"),
        "community__actions_enable_new_post_notifications_success":
            MessageLookupByLibrary.simpleMessage(
                "New post notifications enabled"),
        "community__actions_enable_new_post_notifications_title":
            MessageLookupByLibrary.simpleMessage(
                "Habilitar notificações de postagem"),
        "community__actions_invite_people_title":
            MessageLookupByLibrary.simpleMessage(
                "Convidar pessoas para a comunidade"),
        "community__actions_manage_text":
            MessageLookupByLibrary.simpleMessage("Gerenciar"),
        "community__add_administrators_title":
            MessageLookupByLibrary.simpleMessage("Adicionar administrador."),
        "community__add_moderator_title":
            MessageLookupByLibrary.simpleMessage("Adicionar moderador"),
        "community__adjectives_range_error": m5,
        "community__admin_add_confirmation": m6,
        "community__admin_desc": MessageLookupByLibrary.simpleMessage(
            "Isso permitirá que o membro edite os detalhes da comunidade, administradores, moderadores e usuários banidos."),
        "community__administrated_communities":
            MessageLookupByLibrary.simpleMessage("comunidades administradas"),
        "community__administrated_community":
            MessageLookupByLibrary.simpleMessage("comunidade administrada"),
        "community__administrated_title":
            MessageLookupByLibrary.simpleMessage("Administradas"),
        "community__administrator_plural":
            MessageLookupByLibrary.simpleMessage("administradores"),
        "community__administrator_text":
            MessageLookupByLibrary.simpleMessage("administrador"),
        "community__administrator_you":
            MessageLookupByLibrary.simpleMessage("Você"),
        "community__administrators_title":
            MessageLookupByLibrary.simpleMessage("Administradores"),
        "community__ban_confirmation": m7,
        "community__ban_desc": MessageLookupByLibrary.simpleMessage(
            "Isso removerá o usuário da comunidade e impedirá que ele entre novamente."),
        "community__ban_user_title":
            MessageLookupByLibrary.simpleMessage("Banir usuário"),
        "community__banned_user_text":
            MessageLookupByLibrary.simpleMessage("usuário banido"),
        "community__banned_users_text":
            MessageLookupByLibrary.simpleMessage("usuários banidos"),
        "community__banned_users_title":
            MessageLookupByLibrary.simpleMessage("Usuários banidos"),
        "community__button_rules":
            MessageLookupByLibrary.simpleMessage("Regras"),
        "community__button_staff":
            MessageLookupByLibrary.simpleMessage("Equipe"),
        "community__categories":
            MessageLookupByLibrary.simpleMessage("categorias."),
        "community__category":
            MessageLookupByLibrary.simpleMessage("categoria."),
        "community__communities":
            MessageLookupByLibrary.simpleMessage("comunidades"),
        "community__communities_all_text":
            MessageLookupByLibrary.simpleMessage("Todas"),
        "community__communities_no_category_found":
            MessageLookupByLibrary.simpleMessage(
                "Nenhuma categoria encontrada. Por favor, tente novamente em alguns minutos."),
        "community__communities_refresh_text":
            MessageLookupByLibrary.simpleMessage("Atualizar"),
        "community__communities_title":
            MessageLookupByLibrary.simpleMessage("Comunidades"),
        "community__community":
            MessageLookupByLibrary.simpleMessage("comunidade"),
        "community__community_members":
            MessageLookupByLibrary.simpleMessage("Membros da comunidade"),
        "community__community_staff":
            MessageLookupByLibrary.simpleMessage("Equipe da comunidade"),
        "community__confirmation_title":
            MessageLookupByLibrary.simpleMessage("Confirmação"),
        "community__delete_confirmation": MessageLookupByLibrary.simpleMessage(
            "Você tem certeza de que deseja excluir a comunidade?"),
        "community__delete_desc": MessageLookupByLibrary.simpleMessage(
            "Você não poderá mais ver as publicações desta comunidade, nem publicar nela."),
        "community__description_range_error": m8,
        "community__details_favorite":
            MessageLookupByLibrary.simpleMessage("Nos Favoritos"),
        "community__exclude_joined_communities":
            MessageLookupByLibrary.simpleMessage(
                "Excluir comunidades ingressadas"),
        "community__exclude_joined_communities_desc":
            MessageLookupByLibrary.simpleMessage(
                "Não mostrar publicações de comunidades das quais sou membro"),
        "community__excluded_communities":
            MessageLookupByLibrary.simpleMessage("comunidades excluídas"),
        "community__excluded_community":
            MessageLookupByLibrary.simpleMessage("comunidade excluída"),
        "community__favorite_action":
            MessageLookupByLibrary.simpleMessage("Favoritar comunidade"),
        "community__favorite_communities":
            MessageLookupByLibrary.simpleMessage("comunidades favoritas"),
        "community__favorite_community":
            MessageLookupByLibrary.simpleMessage("comunidade favorita"),
        "community__favorites_title":
            MessageLookupByLibrary.simpleMessage("Favoritas"),
        "community__invite_to_community_resource_plural":
            MessageLookupByLibrary.simpleMessage("conexões e seguidores"),
        "community__invite_to_community_resource_singular":
            MessageLookupByLibrary.simpleMessage("conexão ou seguidor"),
        "community__invite_to_community_title":
            MessageLookupByLibrary.simpleMessage("Convidar para a comunidade"),
        "community__invited_by_member": MessageLookupByLibrary.simpleMessage(
            "Você deve ser convidado(a) por um membro."),
        "community__invited_by_moderator": MessageLookupByLibrary.simpleMessage(
            "Você deve ser convidado(a) por um moderador."),
        "community__is_private":
            MessageLookupByLibrary.simpleMessage("Essa comunidade é privada."),
        "community__join_communities_desc":
            MessageLookupByLibrary.simpleMessage(
                "Entre nas comunidades para ver esta aba ganhar vida!"),
        "community__join_community":
            MessageLookupByLibrary.simpleMessage("Entrar"),
        "community__joined_communities":
            MessageLookupByLibrary.simpleMessage("comunidades ingressadas"),
        "community__joined_community":
            MessageLookupByLibrary.simpleMessage("comunidade ingressada"),
        "community__joined_title":
            MessageLookupByLibrary.simpleMessage("Ingressadas"),
        "community__leave_community":
            MessageLookupByLibrary.simpleMessage("Sair"),
        "community__leave_confirmation": MessageLookupByLibrary.simpleMessage(
            "Você tem certeza de que deseja sair da comunidade?"),
        "community__leave_desc": MessageLookupByLibrary.simpleMessage(
            "Você não poderá mais ver as publicações desta comunidade, nem publicar nela."),
        "community__manage_add_favourite": MessageLookupByLibrary.simpleMessage(
            "Adicionar a comunidade às suas favoritas"),
        "community__manage_admins_desc": MessageLookupByLibrary.simpleMessage(
            "Ver, adicionar e remover administradores."),
        "community__manage_admins_title":
            MessageLookupByLibrary.simpleMessage("Administradores"),
        "community__manage_banned_desc": MessageLookupByLibrary.simpleMessage(
            "Ver, adicionar e remover usuários banidos."),
        "community__manage_banned_title":
            MessageLookupByLibrary.simpleMessage("Usuários banidos"),
        "community__manage_closed_posts_desc":
            MessageLookupByLibrary.simpleMessage(
                "Ver e gerenciar as publicações fechadas"),
        "community__manage_closed_posts_title":
            MessageLookupByLibrary.simpleMessage("Publicações fechadas"),
        "community__manage_delete_desc": MessageLookupByLibrary.simpleMessage(
            "Excluir a comunidade, para sempre."),
        "community__manage_delete_title":
            MessageLookupByLibrary.simpleMessage("Excluir comunidade"),
        "community__manage_details_desc": MessageLookupByLibrary.simpleMessage(
            "Alterar título, nome, avatar, foto de capa e mais."),
        "community__manage_details_title":
            MessageLookupByLibrary.simpleMessage("Detalhes"),
        "community__manage_disable_new_post_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Disable new post notifications"),
        "community__manage_enable_new_post_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Enable new post notifications"),
        "community__manage_invite_desc": MessageLookupByLibrary.simpleMessage(
            "Convidar suas conexões e seus seguidores para a comunidade."),
        "community__manage_invite_title":
            MessageLookupByLibrary.simpleMessage("Convidar pessoas"),
        "community__manage_leave_desc":
            MessageLookupByLibrary.simpleMessage("Sair da comunidade."),
        "community__manage_leave_title":
            MessageLookupByLibrary.simpleMessage("Sair da comunidade"),
        "community__manage_mod_reports_desc":
            MessageLookupByLibrary.simpleMessage(
                "Revisar as denúncias para moderação da comunidade."),
        "community__manage_mod_reports_title":
            MessageLookupByLibrary.simpleMessage("Reportado para moderação"),
        "community__manage_mods_desc": MessageLookupByLibrary.simpleMessage(
            "Ver, adicionar e remover moderadores."),
        "community__manage_mods_title":
            MessageLookupByLibrary.simpleMessage("Moderadores"),
        "community__manage_remove_favourite":
            MessageLookupByLibrary.simpleMessage(
                "Remover a comunidade de suas favoritas"),
        "community__manage_title":
            MessageLookupByLibrary.simpleMessage("Gerenciar comunidade"),
        "community__member": MessageLookupByLibrary.simpleMessage("membro"),
        "community__member_capitalized":
            MessageLookupByLibrary.simpleMessage("Membro"),
        "community__member_plural":
            MessageLookupByLibrary.simpleMessage("membros"),
        "community__members_capitalized":
            MessageLookupByLibrary.simpleMessage("Membros"),
        "community__moderated_communities":
            MessageLookupByLibrary.simpleMessage("comunidades moderadas"),
        "community__moderated_community":
            MessageLookupByLibrary.simpleMessage("comunidade moderada"),
        "community__moderated_title":
            MessageLookupByLibrary.simpleMessage("Moderadas"),
        "community__moderator_add_confirmation": m9,
        "community__moderator_desc": MessageLookupByLibrary.simpleMessage(
            "Isso permitirá que o membro edite os detalhes da comunidade, moderadores e usuários banidos."),
        "community__moderator_resource_name":
            MessageLookupByLibrary.simpleMessage("moderador"),
        "community__moderators_resource_name":
            MessageLookupByLibrary.simpleMessage("moderadores"),
        "community__moderators_title":
            MessageLookupByLibrary.simpleMessage("Moderadores"),
        "community__moderators_you":
            MessageLookupByLibrary.simpleMessage("Você"),
        "community__name_characters_error": MessageLookupByLibrary.simpleMessage(
            "O nome só pode conter caracteres alfanuméricos e underlines (_)."),
        "community__name_empty_error": MessageLookupByLibrary.simpleMessage(
            "O nome não pode ficar vazio."),
        "community__name_range_error": m10,
        "community__no": MessageLookupByLibrary.simpleMessage("Não"),
        "community__pick_atleast_min_categories": m11,
        "community__pick_atleast_min_category": m12,
        "community__pick_upto_max": m13,
        "community__post_plural": MessageLookupByLibrary.simpleMessage("posts"),
        "community__post_singular":
            MessageLookupByLibrary.simpleMessage("post"),
        "community__posts": MessageLookupByLibrary.simpleMessage("Posts"),
        "community__refresh_text":
            MessageLookupByLibrary.simpleMessage("Atualizar"),
        "community__refreshing":
            MessageLookupByLibrary.simpleMessage("Atualizando a comunidade"),
        "community__retry_loading_posts":
            MessageLookupByLibrary.simpleMessage("Tentar novamente"),
        "community__rules_empty_error": MessageLookupByLibrary.simpleMessage(
            "As regras não podem ficar vazias."),
        "community__rules_range_error": m14,
        "community__rules_text": MessageLookupByLibrary.simpleMessage("Regras"),
        "community__rules_title":
            MessageLookupByLibrary.simpleMessage("Regras da comunidade"),
        "community__save_community_create_community":
            MessageLookupByLibrary.simpleMessage("Criar comunidade"),
        "community__save_community_create_text":
            MessageLookupByLibrary.simpleMessage("Criar"),
        "community__save_community_edit_community":
            MessageLookupByLibrary.simpleMessage("Editar comunidade"),
        "community__save_community_label_title":
            MessageLookupByLibrary.simpleMessage("Título"),
        "community__save_community_label_title_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "ex: Viagem, Fotografia, Jogos."),
        "community__save_community_name_category":
            MessageLookupByLibrary.simpleMessage("Categoria"),
        "community__save_community_name_label_color":
            MessageLookupByLibrary.simpleMessage("Cor"),
        "community__save_community_name_label_color_hint_text":
            MessageLookupByLibrary.simpleMessage("(Toque para alterar)"),
        "community__save_community_name_label_desc_optional":
            MessageLookupByLibrary.simpleMessage("Descrição · Opcional"),
        "community__save_community_name_label_desc_optional_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "Sobre o que é a sua comunidade?"),
        "community__save_community_name_label_member_adjective":
            MessageLookupByLibrary.simpleMessage(
                "Adjetivo para membro · Opcional"),
        "community__save_community_name_label_member_adjective_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "ex: viajante, fotógrafo, gamer."),
        "community__save_community_name_label_members_adjective":
            MessageLookupByLibrary.simpleMessage(
                "Adjetivo para membros · Opcional"),
        "community__save_community_name_label_members_adjective_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "ex: viajantes, fotógrafos, gamers."),
        "community__save_community_name_label_rules_optional":
            MessageLookupByLibrary.simpleMessage("Regras · Opcional"),
        "community__save_community_name_label_rules_optional_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "Há algo que você gostaria que seus usuários soubessem?"),
        "community__save_community_name_label_type":
            MessageLookupByLibrary.simpleMessage("Tipo"),
        "community__save_community_name_label_type_hint_text":
            MessageLookupByLibrary.simpleMessage("(Toque para alterar)"),
        "community__save_community_name_member_invites":
            MessageLookupByLibrary.simpleMessage("Convites de membros"),
        "community__save_community_name_member_invites_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Membros podem convidar pessoas para a comunidade"),
        "community__save_community_name_taken": m15,
        "community__save_community_name_title":
            MessageLookupByLibrary.simpleMessage("Nome"),
        "community__save_community_name_title_hint_text":
            MessageLookupByLibrary.simpleMessage(
                " ex: viagem, fotografia, jogos."),
        "community__save_community_save_text":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "community__tile_delete":
            MessageLookupByLibrary.simpleMessage("Excluir"),
        "community__title_empty_error": MessageLookupByLibrary.simpleMessage(
            "O título não pode ficar vazio."),
        "community__title_range_error": m16,
        "community__top_posts_excluded_communities":
            MessageLookupByLibrary.simpleMessage("Comunidades excluídas"),
        "community__top_posts_excluded_communities_desc":
            MessageLookupByLibrary.simpleMessage(
                "Gerenciar comunidades excluídas do explorar"),
        "community__top_posts_settings":
            MessageLookupByLibrary.simpleMessage("Configurações do explorar"),
        "community__trending_in_all":
            MessageLookupByLibrary.simpleMessage("Comunidades em alta"),
        "community__trending_in_category": m17,
        "community__trending_none_found": MessageLookupByLibrary.simpleMessage(
            "Nenhuma comunidade em alta encontrada. Tente novamente em alguns minutos."),
        "community__trending_refresh":
            MessageLookupByLibrary.simpleMessage("Atualizar"),
        "community__type_private":
            MessageLookupByLibrary.simpleMessage("Privada"),
        "community__type_public":
            MessageLookupByLibrary.simpleMessage("Pública"),
        "community__unfavorite_action":
            MessageLookupByLibrary.simpleMessage("Desfavoritar comunidade"),
        "community__user_you_text":
            MessageLookupByLibrary.simpleMessage("Você"),
        "community__yes": MessageLookupByLibrary.simpleMessage("Sim"),
        "contextual_account_search_box__no_results":
            MessageLookupByLibrary.simpleMessage("Nenhum resultado encontrado"),
        "contextual_account_search_box__suggestions":
            MessageLookupByLibrary.simpleMessage("Sugestões"),
        "contextual_community_search_box__no_results":
            MessageLookupByLibrary.simpleMessage("Nenhum resultado encontrado"),
        "contextual_community_search_box__suggestions":
            MessageLookupByLibrary.simpleMessage("Sugestões"),
        "contextual_hashtag_search_box__be_the_first": m18,
        "drawer__about": MessageLookupByLibrary.simpleMessage("Sobre"),
        "drawer__about_platform": m19,
        "drawer__account_settings":
            MessageLookupByLibrary.simpleMessage("Configurações da conta"),
        "drawer__account_settings_blocked_users":
            MessageLookupByLibrary.simpleMessage("Usuários bloqueados"),
        "drawer__account_settings_change_email":
            MessageLookupByLibrary.simpleMessage("Alterar Email"),
        "drawer__account_settings_change_password":
            MessageLookupByLibrary.simpleMessage("Alterar Senha"),
        "drawer__account_settings_delete_account":
            MessageLookupByLibrary.simpleMessage("Excluir a minha conta"),
        "drawer__account_settings_language": m20,
        "drawer__account_settings_language_text":
            MessageLookupByLibrary.simpleMessage("Idioma"),
        "drawer__account_settings_notifications":
            MessageLookupByLibrary.simpleMessage("Notificações"),
        "drawer__app_account_text":
            MessageLookupByLibrary.simpleMessage("Aplicativo & Conta"),
        "drawer__application_settings":
            MessageLookupByLibrary.simpleMessage("Configurações do aplicativo"),
        "drawer__connections":
            MessageLookupByLibrary.simpleMessage("Minhas conexões"),
        "drawer__customize":
            MessageLookupByLibrary.simpleMessage("Personalizar"),
        "drawer__developer_settings":
            MessageLookupByLibrary.simpleMessage("Opções de desenvolvedor"),
        "drawer__global_moderation":
            MessageLookupByLibrary.simpleMessage("Moderação global"),
        "drawer__help":
            MessageLookupByLibrary.simpleMessage("Suporte e Feedback"),
        "drawer__lists": MessageLookupByLibrary.simpleMessage("Minhas listas"),
        "drawer__logout": MessageLookupByLibrary.simpleMessage("Sair"),
        "drawer__main_title": MessageLookupByLibrary.simpleMessage("Somus"),
        "drawer__menu_title": MessageLookupByLibrary.simpleMessage("Menu"),
        "drawer__my_circles":
            MessageLookupByLibrary.simpleMessage("Meus círculos"),
        "drawer__my_followers":
            MessageLookupByLibrary.simpleMessage("Meus seguidores"),
        "drawer__my_following":
            MessageLookupByLibrary.simpleMessage("Meus seguidos"),
        "drawer__my_invites":
            MessageLookupByLibrary.simpleMessage("Meus convites"),
        "drawer__my_lists":
            MessageLookupByLibrary.simpleMessage("Minhas listas"),
        "drawer__my_mod_penalties":
            MessageLookupByLibrary.simpleMessage("Minhas penalidades"),
        "drawer__my_pending_mod_tasks": MessageLookupByLibrary.simpleMessage(
            "Minhas tarefas de moderação pendentes"),
        "drawer__profile": MessageLookupByLibrary.simpleMessage("Perfil"),
        "drawer__settings":
            MessageLookupByLibrary.simpleMessage("Configurações"),
        "drawer__themes": MessageLookupByLibrary.simpleMessage("Temas"),
        "drawer__useful_links_guidelines":
            MessageLookupByLibrary.simpleMessage("Diretrizes da Somus"),
        "drawer__useful_links_guidelines_bug_tracker":
            MessageLookupByLibrary.simpleMessage("Rastreador de bugs"),
        "drawer__useful_links_guidelines_bug_tracker_desc":
            MessageLookupByLibrary.simpleMessage(
                "Reportar um bug ou votar em bugs existentes"),
        "drawer__useful_links_guidelines_desc":
            MessageLookupByLibrary.simpleMessage(
                "As diretrizes que todos esperamos seguir para uma coexistência saudável e amigável."),
        "drawer__useful_links_guidelines_feature_requests":
            MessageLookupByLibrary.simpleMessage("Sugestões de recursos"),
        "drawer__useful_links_guidelines_feature_requests_desc":
            MessageLookupByLibrary.simpleMessage(
                "Sugerir um recurso ou votar em sugestões existentes"),
        "drawer__useful_links_guidelines_github":
            MessageLookupByLibrary.simpleMessage("Projeto no Github"),
        "drawer__useful_links_guidelines_github_desc":
            MessageLookupByLibrary.simpleMessage(
                "Dê uma olhada no que estamos trabalhando atualmente"),
        "drawer__useful_links_guidelines_handbook":
            MessageLookupByLibrary.simpleMessage("Manual da Somus"),
        "drawer__useful_links_guidelines_handbook_desc":
            MessageLookupByLibrary.simpleMessage(
                "Um manual para aprender tudo sobre o uso da plataforma"),
        "drawer__useful_links_slack_channel":
            MessageLookupByLibrary.simpleMessage(
                "Canal da comunidade no Slack"),
        "drawer__useful_links_slack_channel_desc":
            MessageLookupByLibrary.simpleMessage(
                "Um lugar para discutir tudo sobre a Somus"),
        "drawer__useful_links_support":
            MessageLookupByLibrary.simpleMessage("Apoie a Somus"),
        "drawer__useful_links_support_desc":
            MessageLookupByLibrary.simpleMessage(
                "Encontre uma maneira de nos apoiar em nossa jornada!"),
        "drawer__useful_links_title":
            MessageLookupByLibrary.simpleMessage("Links úteis"),
        "error__no_internet_connection":
            MessageLookupByLibrary.simpleMessage("Sem conexão com a internet"),
        "error__unknown_error":
            MessageLookupByLibrary.simpleMessage("Erro desconhecido"),
        "image_picker__error_too_large": m21,
        "image_picker__from_camera":
            MessageLookupByLibrary.simpleMessage("Câmera"),
        "image_picker__from_gallery":
            MessageLookupByLibrary.simpleMessage("Galeria"),
        "media_service__crop_image":
            MessageLookupByLibrary.simpleMessage("Cortar imagem"),
        "moderation__actions_chat_with_team":
            MessageLookupByLibrary.simpleMessage("Converse com a equipe"),
        "moderation__actions_review":
            MessageLookupByLibrary.simpleMessage("Revisar"),
        "moderation__category_text":
            MessageLookupByLibrary.simpleMessage("Categoria"),
        "moderation__community_moderated_objects":
            MessageLookupByLibrary.simpleMessage(
                "Itens moderados por comunidades"),
        "moderation__community_review_approve":
            MessageLookupByLibrary.simpleMessage("Aprovar"),
        "moderation__community_review_item_verified":
            MessageLookupByLibrary.simpleMessage("Este item foi verificado"),
        "moderation__community_review_object":
            MessageLookupByLibrary.simpleMessage("Objeto"),
        "moderation__community_review_reject":
            MessageLookupByLibrary.simpleMessage("rejeitar"),
        "moderation__community_review_title":
            MessageLookupByLibrary.simpleMessage("Revisar objeto moderado"),
        "moderation__confirm_report_community_reported":
            MessageLookupByLibrary.simpleMessage("Comunidade denunciada"),
        "moderation__confirm_report_item_reported":
            MessageLookupByLibrary.simpleMessage("Item denunciado"),
        "moderation__confirm_report_post_comment_reported":
            MessageLookupByLibrary.simpleMessage("Comentário denunciado"),
        "moderation__confirm_report_post_reported":
            MessageLookupByLibrary.simpleMessage("Publicação denunciada"),
        "moderation__confirm_report_provide_details":
            MessageLookupByLibrary.simpleMessage(
                "Você pode fornecer mais detalhes relevantes para a denúncia?"),
        "moderation__confirm_report_provide_happen_next":
            MessageLookupByLibrary.simpleMessage(
                "Aqui está o que acontecerá a seguir:"),
        "moderation__confirm_report_provide_happen_next_desc":
            MessageLookupByLibrary.simpleMessage(
                "- Sua denúncia será enviada anonimamente. \n- Se você estiver denunciando uma publicação ou comentário, a denúncia será enviada à equipe da Somus e aos moderadores da comunidade (se aplicável), e o conteúdo denunciado ficará oculto do seu feed. \n- Se você estiver denunciando uma conta ou comunidade, a denúncia será enviada para a equipe da Somus. \n- Vamos analisar a denúncia e, se aprovada, o conteúdo será excluído e as penalidades serão aplicadas às pessoas envolvidas, desde uma suspensão temporária até a exclusão da conta, dependendo da gravidade da transgressão. \n- Se a denúncia for apenas uma tentativa de prejudicar um membro ou comunidade que não cometeu a infração apontada por você, as penalidades serão aplicadas a você. \n"),
        "moderation__confirm_report_provide_optional_hint_text":
            MessageLookupByLibrary.simpleMessage("Digite aqui..."),
        "moderation__confirm_report_provide_optional_info":
            MessageLookupByLibrary.simpleMessage("(Opcional)"),
        "moderation__confirm_report_submit":
            MessageLookupByLibrary.simpleMessage("Eu entendo, envie."),
        "moderation__confirm_report_title":
            MessageLookupByLibrary.simpleMessage("Enviar denúncia"),
        "moderation__confirm_report_user_reported":
            MessageLookupByLibrary.simpleMessage("Usuário denunciado"),
        "moderation__description_text":
            MessageLookupByLibrary.simpleMessage("Descrição"),
        "moderation__filters_apply":
            MessageLookupByLibrary.simpleMessage("Aplicar filtros"),
        "moderation__filters_other":
            MessageLookupByLibrary.simpleMessage("Outros"),
        "moderation__filters_reset":
            MessageLookupByLibrary.simpleMessage("Redefinir"),
        "moderation__filters_status":
            MessageLookupByLibrary.simpleMessage("Status"),
        "moderation__filters_title":
            MessageLookupByLibrary.simpleMessage("Filtros de moderação"),
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
            MessageLookupByLibrary.simpleMessage("Itens moderados globalmente"),
        "moderation__moderated_object_false_text":
            MessageLookupByLibrary.simpleMessage("Falso"),
        "moderation__moderated_object_reports_count":
            MessageLookupByLibrary.simpleMessage("Número de denúncias"),
        "moderation__moderated_object_status":
            MessageLookupByLibrary.simpleMessage("Status"),
        "moderation__moderated_object_title":
            MessageLookupByLibrary.simpleMessage("Objeto"),
        "moderation__moderated_object_true_text":
            MessageLookupByLibrary.simpleMessage("Verdadeiro"),
        "moderation__moderated_object_verified":
            MessageLookupByLibrary.simpleMessage("Verificado"),
        "moderation__moderated_object_verified_by_staff":
            MessageLookupByLibrary.simpleMessage(
                "Verificado pela equipe da Somus"),
        "moderation__my_moderation_penalties_resouce_singular":
            MessageLookupByLibrary.simpleMessage("penalidade de moderação"),
        "moderation__my_moderation_penalties_resource_plural":
            MessageLookupByLibrary.simpleMessage("penalidades de moderação"),
        "moderation__my_moderation_penalties_title":
            MessageLookupByLibrary.simpleMessage("Penalidades de moderação"),
        "moderation__my_moderation_tasks_title":
            MessageLookupByLibrary.simpleMessage(
                "Tarefas de moderação pendentes"),
        "moderation__no_description_text":
            MessageLookupByLibrary.simpleMessage("Sem descrição"),
        "moderation__object_status_title":
            MessageLookupByLibrary.simpleMessage("Status"),
        "moderation__pending_moderation_tasks_plural":
            MessageLookupByLibrary.simpleMessage(
                "tarefas de moderação pendentes"),
        "moderation__pending_moderation_tasks_singular":
            MessageLookupByLibrary.simpleMessage(
                "tarefa de moderação pendente"),
        "moderation__report_account_text":
            MessageLookupByLibrary.simpleMessage("Denunciar conta"),
        "moderation__report_comment_text":
            MessageLookupByLibrary.simpleMessage("Denunciar comentário"),
        "moderation__report_community_text":
            MessageLookupByLibrary.simpleMessage("Denunciar comunidade"),
        "moderation__report_hashtag_text":
            MessageLookupByLibrary.simpleMessage("Denunciar hashtag"),
        "moderation__report_post_text":
            MessageLookupByLibrary.simpleMessage("Denunciar post"),
        "moderation__reporter_text":
            MessageLookupByLibrary.simpleMessage("Denunciante"),
        "moderation__reports_preview_resource_reports":
            MessageLookupByLibrary.simpleMessage("denúncias"),
        "moderation__reports_preview_title":
            MessageLookupByLibrary.simpleMessage("Denúncias"),
        "moderation__reports_see_all": m22,
        "moderation__tap_to_retry": MessageLookupByLibrary.simpleMessage(
            "Toque para tentar carregar os itens novamente"),
        "moderation__update_category_save":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "moderation__update_category_title":
            MessageLookupByLibrary.simpleMessage("Atualizar categoria"),
        "moderation__update_description_report_desc":
            MessageLookupByLibrary.simpleMessage("Descrição da denúncia"),
        "moderation__update_description_report_hint_text":
            MessageLookupByLibrary.simpleMessage(
                "ex: O motivo da denúncia é..."),
        "moderation__update_description_save":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "moderation__update_description_title":
            MessageLookupByLibrary.simpleMessage("Editar descrição"),
        "moderation__update_status_save":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "moderation__update_status_title":
            MessageLookupByLibrary.simpleMessage("Atualizar status"),
        "moderation__you_have_reported_account_text":
            MessageLookupByLibrary.simpleMessage("Você denunciou esta conta"),
        "moderation__you_have_reported_comment_text":
            MessageLookupByLibrary.simpleMessage(
                "Você denunciou este comentário"),
        "moderation__you_have_reported_community_text":
            MessageLookupByLibrary.simpleMessage(
                "Você denunciou esta comunidade"),
        "moderation__you_have_reported_hashtag_text":
            MessageLookupByLibrary.simpleMessage("Você denunciou esta hashtag"),
        "moderation__you_have_reported_post_text":
            MessageLookupByLibrary.simpleMessage(
                "Você denunciou esta publicação"),
        "notifications__accepted_connection_request_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] aceitou seu pedido de conexão."),
        "notifications__comment_comment_notification_tile_user_also_commented":
            m23,
        "notifications__comment_comment_notification_tile_user_commented": m24,
        "notifications__comment_desc": MessageLookupByLibrary.simpleMessage(
            "Seja notificado(a) quando alguém comentar uma das suas publicações ou uma que você também comentou"),
        "notifications__comment_reaction_desc":
            MessageLookupByLibrary.simpleMessage(
                "Seja notificado(a) quando alguém reagir a um dos seus comentários"),
        "notifications__comment_reaction_title":
            MessageLookupByLibrary.simpleMessage("Reações aos comentários"),
        "notifications__comment_reply_desc": MessageLookupByLibrary.simpleMessage(
            "Seja notificado(a) quando alguém responder a um dos seus comentários ou a um que você também respondeu"),
        "notifications__comment_reply_notification_tile_user_also_replied": m25,
        "notifications__comment_reply_notification_tile_user_replied": m26,
        "notifications__comment_reply_title":
            MessageLookupByLibrary.simpleMessage("Respostas aos comentários"),
        "notifications__comment_title":
            MessageLookupByLibrary.simpleMessage("Comentários"),
        "notifications__comment_user_mention_desc":
            MessageLookupByLibrary.simpleMessage(
                "Seja notificado(a) quando alguém mencionar você em um comentário"),
        "notifications__comment_user_mention_title":
            MessageLookupByLibrary.simpleMessage("Menções em comentários"),
        "notifications__community_invite_desc":
            MessageLookupByLibrary.simpleMessage(
                "Seja notificado(a) quando alguém convidar você para uma comunidade"),
        "notifications__community_invite_title":
            MessageLookupByLibrary.simpleMessage("Convites para comunidades"),
        "notifications__community_new_post_desc":
            MessageLookupByLibrary.simpleMessage(
                "Be notified when there is a new post in a community you enabled post notifications on"),
        "notifications__community_new_post_tile": m27,
        "notifications__community_new_post_title":
            MessageLookupByLibrary.simpleMessage(
                "Nova publicação da comunidade"),
        "notifications__connection_desc": MessageLookupByLibrary.simpleMessage(
            "Seja notificado(a) quando alguém quiser se conectar com você"),
        "notifications__connection_request_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] quer se conectar com você."),
        "notifications__connection_title":
            MessageLookupByLibrary.simpleMessage("Pedidos de conexão"),
        "notifications__follow_desc": MessageLookupByLibrary.simpleMessage(
            "Seja notificado(a) quando alguém começar a seguir você"),
        "notifications__follow_title":
            MessageLookupByLibrary.simpleMessage("Seguidores"),
        "notifications__following_you_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] está te seguindo agora."),
        "notifications__general_desc": MessageLookupByLibrary.simpleMessage(
            "Seja notificado(a) quando algo acontecer"),
        "notifications__general_title":
            MessageLookupByLibrary.simpleMessage("Notificações"),
        "notifications__mentioned_in_post_comment_tile": m28,
        "notifications__mentioned_in_post_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] mencionou você em um post."),
        "notifications__mute_post_turn_off_post_comment_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Desativar notificações do comentário"),
        "notifications__mute_post_turn_off_post_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Desativar notificações do post"),
        "notifications__mute_post_turn_on_post_comment_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Ativar notificações do comentário"),
        "notifications__mute_post_turn_on_post_notifications":
            MessageLookupByLibrary.simpleMessage("Ativar notificações do post"),
        "notifications__post_reaction_desc": MessageLookupByLibrary.simpleMessage(
            "Seja notificado(a) quando alguém reagir a uma das suas publicações"),
        "notifications__post_reaction_title":
            MessageLookupByLibrary.simpleMessage("Reações aos posts"),
        "notifications__post_user_mention_desc":
            MessageLookupByLibrary.simpleMessage(
                "Seja notificado(a) quando alguém mencionar você em uma publicação"),
        "notifications__post_user_mention_title":
            MessageLookupByLibrary.simpleMessage("Menções em posts"),
        "notifications__reacted_to_post_comment_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] reagiu ao seu comentário."),
        "notifications__reacted_to_post_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] reagiu ao seu post."),
        "notifications__settings_title": MessageLookupByLibrary.simpleMessage(
            "Configurações de notificações"),
        "notifications__tab_general":
            MessageLookupByLibrary.simpleMessage("Gerais"),
        "notifications__tab_requests":
            MessageLookupByLibrary.simpleMessage("Pedidos"),
        "notifications__user_community_invite_tile": m29,
        "notifications__user_new_post_desc": MessageLookupByLibrary.simpleMessage(
            "Be notified when there is a new post by a user you enabled notifications on"),
        "notifications__user_new_post_tile":
            MessageLookupByLibrary.simpleMessage(
                "[name] [username] postou algo."),
        "notifications__user_new_post_title":
            MessageLookupByLibrary.simpleMessage("Nova postagem do usuário"),
        "permissions_service__camera_permission_denied":
            MessageLookupByLibrary.simpleMessage(
                "Exigimos a permissão da câmera para permitir que você tire fotos e grave vídeos. Conceda-o nas suas configurações."),
        "permissions_service__storage_permission_denied":
            MessageLookupByLibrary.simpleMessage(
                "Exigimos a permissão de armazenamento para permitir a seleção de itens de mídia. Conceda-o em suas configurações."),
        "post__action_comment":
            MessageLookupByLibrary.simpleMessage("Comentar"),
        "post__action_react": MessageLookupByLibrary.simpleMessage("Reagir"),
        "post__action_reply": MessageLookupByLibrary.simpleMessage("Responder"),
        "post__actions_comment_deleted":
            MessageLookupByLibrary.simpleMessage("Comentário excluído"),
        "post__actions_delete":
            MessageLookupByLibrary.simpleMessage("Excluir post"),
        "post__actions_delete_comment":
            MessageLookupByLibrary.simpleMessage("Excluir comentário"),
        "post__actions_delete_comment_description":
            MessageLookupByLibrary.simpleMessage(
                "O comentário, assim como suas respostas e reações, serão excluídos permanentemente."),
        "post__actions_delete_description": MessageLookupByLibrary.simpleMessage(
            "A postagem, assim como seus comentários e reações, serão excluídos permanentemente."),
        "post__actions_deleted":
            MessageLookupByLibrary.simpleMessage("Post excluído"),
        "post__actions_edit_comment":
            MessageLookupByLibrary.simpleMessage("Editar comentário"),
        "post__actions_report_text":
            MessageLookupByLibrary.simpleMessage("Denunciar"),
        "post__actions_reported_text":
            MessageLookupByLibrary.simpleMessage("Denunciado"),
        "post__actions_show_more_text":
            MessageLookupByLibrary.simpleMessage("Ver mais"),
        "post__close_create_post_label":
            MessageLookupByLibrary.simpleMessage("Fechar publicação"),
        "post__close_post": MessageLookupByLibrary.simpleMessage("Fechar post"),
        "post__comment_maxlength_error": m30,
        "post__comment_reply_expanded_post":
            MessageLookupByLibrary.simpleMessage("Enviar"),
        "post__comment_reply_expanded_reply_comment":
            MessageLookupByLibrary.simpleMessage("Responder comentário"),
        "post__comment_reply_expanded_reply_hint_text":
            MessageLookupByLibrary.simpleMessage("Sua resposta..."),
        "post__comment_required_error": MessageLookupByLibrary.simpleMessage(
            "O comentário não pode ficar vazio."),
        "post__commenter_expanded_edit_comment":
            MessageLookupByLibrary.simpleMessage("Editar comentário"),
        "post__commenter_expanded_join_conversation":
            MessageLookupByLibrary.simpleMessage("Entrar na conversa..."),
        "post__commenter_expanded_save":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "post__commenter_expanded_start_conversation":
            MessageLookupByLibrary.simpleMessage("Começar uma conversa..."),
        "post__commenter_post_text":
            MessageLookupByLibrary.simpleMessage("Enviar"),
        "post__commenter_write_something":
            MessageLookupByLibrary.simpleMessage("Escreva algo..."),
        "post__comments_closed_post":
            MessageLookupByLibrary.simpleMessage("Post fechado"),
        "post__comments_disabled":
            MessageLookupByLibrary.simpleMessage("Comentários desativados"),
        "post__comments_disabled_message": MessageLookupByLibrary.simpleMessage(
            "Comentários desativados no post"),
        "post__comments_enabled_message": MessageLookupByLibrary.simpleMessage(
            "Comentários ativados no post"),
        "post__comments_header_be_the_first_comments":
            MessageLookupByLibrary.simpleMessage("Mande o primeiro comentário"),
        "post__comments_header_be_the_first_replies":
            MessageLookupByLibrary.simpleMessage("Mande a primeira resposta"),
        "post__comments_header_newer":
            MessageLookupByLibrary.simpleMessage("Mais recentes"),
        "post__comments_header_newest_comments":
            MessageLookupByLibrary.simpleMessage("Comentários mais recentes"),
        "post__comments_header_newest_replies":
            MessageLookupByLibrary.simpleMessage("Respostas mais recentes"),
        "post__comments_header_older":
            MessageLookupByLibrary.simpleMessage("Mais antigos"),
        "post__comments_header_oldest_comments":
            MessageLookupByLibrary.simpleMessage("Comentários mais antigos"),
        "post__comments_header_oldest_replies":
            MessageLookupByLibrary.simpleMessage("Respostas mais antigas"),
        "post__comments_header_see_newest_comments":
            MessageLookupByLibrary.simpleMessage("Mais recentes"),
        "post__comments_header_see_newest_replies":
            MessageLookupByLibrary.simpleMessage("Mais recentes"),
        "post__comments_header_see_oldest_comments":
            MessageLookupByLibrary.simpleMessage("Mais antigos"),
        "post__comments_header_see_oldest_replies":
            MessageLookupByLibrary.simpleMessage("Mais antigas"),
        "post__comments_header_view_newest_comments":
            MessageLookupByLibrary.simpleMessage("Mais recentes"),
        "post__comments_header_view_newest_replies":
            MessageLookupByLibrary.simpleMessage("Mais recentes"),
        "post__comments_header_view_oldest_comments":
            MessageLookupByLibrary.simpleMessage("Mais antigos"),
        "post__comments_header_view_oldest_replies":
            MessageLookupByLibrary.simpleMessage("Mais antigas"),
        "post__comments_page_no_more_replies_to_load":
            MessageLookupByLibrary.simpleMessage(
                "Sem mais respostas para carregar"),
        "post__comments_page_no_more_to_load":
            MessageLookupByLibrary.simpleMessage(
                "Sem mais comentários para carregar"),
        "post__comments_page_replies_title":
            MessageLookupByLibrary.simpleMessage("Respostas"),
        "post__comments_page_tap_to_retry":
            MessageLookupByLibrary.simpleMessage(
                "Toque para tentar atualizar os comentários novamente."),
        "post__comments_page_tap_to_retry_replies":
            MessageLookupByLibrary.simpleMessage(
                "Toque para tentar atualizar as respostas novamente."),
        "post__comments_page_title":
            MessageLookupByLibrary.simpleMessage("Comentários"),
        "post__comments_view_all_comments": m31,
        "post__create_hashtags_invalid": m32,
        "post__create_new": MessageLookupByLibrary.simpleMessage("Novo post"),
        "post__create_new_community_post_label":
            MessageLookupByLibrary.simpleMessage(
                "Criar publicação na comunidade"),
        "post__create_new_post_label":
            MessageLookupByLibrary.simpleMessage("Criar publicação"),
        "post__create_next": MessageLookupByLibrary.simpleMessage("Avançar"),
        "post__create_photo": MessageLookupByLibrary.simpleMessage("Imagem"),
        "post__create_video": MessageLookupByLibrary.simpleMessage("Vídeo"),
        "post__disable_post_comments": MessageLookupByLibrary.simpleMessage(
            "Desativar comentários do post"),
        "post__edit_save": MessageLookupByLibrary.simpleMessage("Salvar"),
        "post__edit_title": MessageLookupByLibrary.simpleMessage("Editar post"),
        "post__enable_post_comments":
            MessageLookupByLibrary.simpleMessage("Ativar comentários do post"),
        "post__exclude_post_community": MessageLookupByLibrary.simpleMessage(
            "Não mostrar publicações desta comunidade"),
        "post__have_not_shared_anything": MessageLookupByLibrary.simpleMessage(
            "Você ainda não compartilhou nada."),
        "post__is_closed": MessageLookupByLibrary.simpleMessage("Post fechado"),
        "post__load_more":
            MessageLookupByLibrary.simpleMessage("Carregar mais postagens"),
        "post__my_circles":
            MessageLookupByLibrary.simpleMessage("Meus círculos"),
        "post__my_circles_desc": MessageLookupByLibrary.simpleMessage(
            "Compartilhe a publicação para um ou vários dos seus círculos."),
        "post__no_circles_for": m33,
        "post__open_post": MessageLookupByLibrary.simpleMessage("Abrir post"),
        "post__post_closed":
            MessageLookupByLibrary.simpleMessage("Post fechado "),
        "post__post_opened":
            MessageLookupByLibrary.simpleMessage("Post aberto"),
        "post__post_reactions_title":
            MessageLookupByLibrary.simpleMessage("Reações ao post"),
        "post__profile_counts_follower":
            MessageLookupByLibrary.simpleMessage(" Seguidor"),
        "post__profile_counts_followers":
            MessageLookupByLibrary.simpleMessage(" Seguidores"),
        "post__profile_counts_following":
            MessageLookupByLibrary.simpleMessage(" Seguindo"),
        "post__profile_counts_post":
            MessageLookupByLibrary.simpleMessage(" Post"),
        "post__profile_counts_posts":
            MessageLookupByLibrary.simpleMessage(" Posts"),
        "post__profile_retry_loading_posts":
            MessageLookupByLibrary.simpleMessage("Tentar novamente"),
        "post__reaction_list_tap_retry": MessageLookupByLibrary.simpleMessage(
            "Toque para tentar carregar as reações novamente."),
        "post__search_circles":
            MessageLookupByLibrary.simpleMessage("Procurar círculos..."),
        "post__share": MessageLookupByLibrary.simpleMessage("Compartilhar"),
        "post__share_community":
            MessageLookupByLibrary.simpleMessage("Compartilhar"),
        "post__share_community_desc": MessageLookupByLibrary.simpleMessage(
            "Compartilhe a publicação com uma comunidade da qual você faz parte."),
        "post__share_community_title":
            MessageLookupByLibrary.simpleMessage("Uma comunidade"),
        "post__share_to":
            MessageLookupByLibrary.simpleMessage("Compartilhar em"),
        "post__share_to_circles":
            MessageLookupByLibrary.simpleMessage("Compartilhar nos círculos"),
        "post__share_to_community":
            MessageLookupByLibrary.simpleMessage("Compartilhar na comunidade"),
        "post__shared_privately_on": MessageLookupByLibrary.simpleMessage(
            "Compartilhado em particular nos"),
        "post__sharing_post_to":
            MessageLookupByLibrary.simpleMessage("Compartilhando post em"),
        "post__text_copied":
            MessageLookupByLibrary.simpleMessage("Texto copiado!"),
        "post__time_short_days": MessageLookupByLibrary.simpleMessage("d"),
        "post__time_short_hours": MessageLookupByLibrary.simpleMessage("h"),
        "post__time_short_minutes": MessageLookupByLibrary.simpleMessage("min"),
        "post__time_short_now_text":
            MessageLookupByLibrary.simpleMessage("agora"),
        "post__time_short_one_day": MessageLookupByLibrary.simpleMessage("1d"),
        "post__time_short_one_hour": MessageLookupByLibrary.simpleMessage("1h"),
        "post__time_short_one_minute":
            MessageLookupByLibrary.simpleMessage("1min"),
        "post__time_short_one_week":
            MessageLookupByLibrary.simpleMessage("1sem"),
        "post__time_short_one_year": MessageLookupByLibrary.simpleMessage("1a"),
        "post__time_short_seconds": MessageLookupByLibrary.simpleMessage("s"),
        "post__time_short_weeks": MessageLookupByLibrary.simpleMessage("sem"),
        "post__time_short_years": MessageLookupByLibrary.simpleMessage("a"),
        "post__timeline_posts_all_loaded": MessageLookupByLibrary.simpleMessage(
            "🎉  Todas as publicações carregadas"),
        "post__timeline_posts_default_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Tente atualizar a linha do tempo."),
        "post__timeline_posts_default_drhoo_title":
            MessageLookupByLibrary.simpleMessage("Algo não está certo."),
        "post__timeline_posts_failed_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Tente novamente em alguns segundos"),
        "post__timeline_posts_failed_drhoo_title":
            MessageLookupByLibrary.simpleMessage(
                "Não foi possível carregar sua linha do tempo."),
        "post__timeline_posts_no_more_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Siga usuários ou junte-se a uma comunidade para começar!"),
        "post__timeline_posts_refresh_posts":
            MessageLookupByLibrary.simpleMessage("Atualizar publicações"),
        "post__timeline_posts_refreshing_drhoo_title":
            MessageLookupByLibrary.simpleMessage("Aguenta aí!"),
        "post__top_posts_title":
            MessageLookupByLibrary.simpleMessage("Explorar"),
        "post__trending_posts_load_more": MessageLookupByLibrary.simpleMessage(
            "Carregar postagens mais antigas"),
        "post__trending_posts_no_trending_posts":
            MessageLookupByLibrary.simpleMessage(
                "Não há publicações em alta. Tente atualizar em alguns segundos."),
        "post__trending_posts_refresh":
            MessageLookupByLibrary.simpleMessage("Atualizar"),
        "post__trending_posts_title":
            MessageLookupByLibrary.simpleMessage("Publicações em alta"),
        "post__undo_exclude_post_community":
            MessageLookupByLibrary.simpleMessage(
                "Mostrar publicações desta comunidade"),
        "post__user_has_not_shared_anything": m34,
        "post__usernames_circles": m35,
        "post__world_circle_name":
            MessageLookupByLibrary.simpleMessage("Mundo"),
        "post__you_shared_with":
            MessageLookupByLibrary.simpleMessage("Você compartilhou com"),
        "post_body_link_preview__empty": MessageLookupByLibrary.simpleMessage(
            "Este link não está disponível para pré-visualização"),
        "post_body_link_preview__error_with_description": m36,
        "post_body_media__unsupported":
            MessageLookupByLibrary.simpleMessage("Tipo de mídia não suportado"),
        "post_uploader__cancelled":
            MessageLookupByLibrary.simpleMessage("Cancelado!"),
        "post_uploader__cancelling":
            MessageLookupByLibrary.simpleMessage("Cancelando"),
        "post_uploader__compressing_media":
            MessageLookupByLibrary.simpleMessage("Comprimindo mídia..."),
        "post_uploader__creating_post":
            MessageLookupByLibrary.simpleMessage("Criando post..."),
        "post_uploader__generic_upload_failed":
            MessageLookupByLibrary.simpleMessage("Falha ao enviar"),
        "post_uploader__processing":
            MessageLookupByLibrary.simpleMessage("Processando..."),
        "post_uploader__publishing":
            MessageLookupByLibrary.simpleMessage("Publicando..."),
        "post_uploader__success":
            MessageLookupByLibrary.simpleMessage("Pronto!"),
        "post_uploader__uploading_media":
            MessageLookupByLibrary.simpleMessage("Enviando mídia..."),
        "posts_stream__all_loaded": MessageLookupByLibrary.simpleMessage(
            "🎉  Todas as publicações foram carregadas"),
        "posts_stream__empty_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Tente novamente em alguns segundos."),
        "posts_stream__empty_drhoo_title": MessageLookupByLibrary.simpleMessage(
            "A linha do tempo está vazia."),
        "posts_stream__failed_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage(
                "Tente novamente em alguns segundos"),
        "posts_stream__failed_drhoo_title":
            MessageLookupByLibrary.simpleMessage(
                "Não foi possível carregar as publicações."),
        "posts_stream__refreshing_drhoo_subtitle":
            MessageLookupByLibrary.simpleMessage("Atualizando as publicações."),
        "posts_stream__refreshing_drhoo_title":
            MessageLookupByLibrary.simpleMessage("Aguenta aí!"),
        "posts_stream__status_tile_empty": MessageLookupByLibrary.simpleMessage(
            "Nenhuma publicação encontrada"),
        "posts_stream__status_tile_no_more_to_load":
            MessageLookupByLibrary.simpleMessage(
                "🎉  Todas as publicações foram carregadas"),
        "user__add_account_done":
            MessageLookupByLibrary.simpleMessage("Concluído"),
        "user__add_account_save":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "user__add_account_success":
            MessageLookupByLibrary.simpleMessage("Sucesso"),
        "user__add_account_to_lists":
            MessageLookupByLibrary.simpleMessage("Adicionar conta à lista"),
        "user__add_account_update_account_lists":
            MessageLookupByLibrary.simpleMessage("Atualizar listas de contas"),
        "user__add_account_update_lists":
            MessageLookupByLibrary.simpleMessage("Atualizar listas"),
        "user__billion_postfix": MessageLookupByLibrary.simpleMessage("b"),
        "user__block_user":
            MessageLookupByLibrary.simpleMessage("Bloquear usuário"),
        "user__change_email_email_text":
            MessageLookupByLibrary.simpleMessage("Email"),
        "user__change_email_error": MessageLookupByLibrary.simpleMessage(
            "Este email já está registrado"),
        "user__change_email_hint_text":
            MessageLookupByLibrary.simpleMessage("Digite seu novo email"),
        "user__change_email_save":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "user__change_email_success_info": MessageLookupByLibrary.simpleMessage(
            "Enviamos um link de confirmação para seu novo endereço de email, clique nele para verificar seu novo email"),
        "user__change_email_title":
            MessageLookupByLibrary.simpleMessage("Alterar Email"),
        "user__circle_name_empty_error": MessageLookupByLibrary.simpleMessage(
            "O nome do círculo não pode ficar vazio."),
        "user__circle_name_range_error": m37,
        "user__circle_peoples_count": m38,
        "user__clear_app_preferences_cleared_successfully":
            MessageLookupByLibrary.simpleMessage(
                "Preferências limpas com sucesso"),
        "user__clear_app_preferences_desc": MessageLookupByLibrary.simpleMessage(
            "Limpe as preferências do aplicativo. Atualmente, isso influencia apenas a ordem preferida dos comentários."),
        "user__clear_app_preferences_error":
            MessageLookupByLibrary.simpleMessage(
                "Não foi possível limpar as preferências"),
        "user__clear_app_preferences_title":
            MessageLookupByLibrary.simpleMessage("Limpar preferências"),
        "user__clear_application_cache_desc":
            MessageLookupByLibrary.simpleMessage(
                "Limpar cache de posts, contas, imagens e mais."),
        "user__clear_application_cache_failure":
            MessageLookupByLibrary.simpleMessage(
                "Não foi possível limpar o cache"),
        "user__clear_application_cache_success":
            MessageLookupByLibrary.simpleMessage("Cache limpo com sucesso"),
        "user__clear_application_cache_text":
            MessageLookupByLibrary.simpleMessage("Limpar cache"),
        "user__confirm_block_user_blocked":
            MessageLookupByLibrary.simpleMessage("Usuário bloqueado."),
        "user__confirm_block_user_info": MessageLookupByLibrary.simpleMessage(
            "Vocês não verão os posts um do outro nem serão capazes de interagir de qualquer forma."),
        "user__confirm_block_user_no":
            MessageLookupByLibrary.simpleMessage("Não"),
        "user__confirm_block_user_question": m39,
        "user__confirm_block_user_title":
            MessageLookupByLibrary.simpleMessage("Confirmação"),
        "user__confirm_block_user_yes":
            MessageLookupByLibrary.simpleMessage("Sim"),
        "user__confirm_connection_add_connection":
            MessageLookupByLibrary.simpleMessage(
                "Adicionar conexão ao círculo"),
        "user__confirm_connection_confirm_text":
            MessageLookupByLibrary.simpleMessage("Confirmar"),
        "user__confirm_connection_connection_confirmed":
            MessageLookupByLibrary.simpleMessage("Conexão confirmada"),
        "user__confirm_connection_with": m40,
        "user__confirm_guidelines_reject_chat_community":
            MessageLookupByLibrary.simpleMessage("Converse com a comunidade."),
        "user__confirm_guidelines_reject_chat_immediately":
            MessageLookupByLibrary.simpleMessage("Inicie o chat agora."),
        "user__confirm_guidelines_reject_chat_with_team":
            MessageLookupByLibrary.simpleMessage("Converse com a equipe."),
        "user__confirm_guidelines_reject_delete_account":
            MessageLookupByLibrary.simpleMessage("Excluir a minha conta"),
        "user__confirm_guidelines_reject_go_back":
            MessageLookupByLibrary.simpleMessage("Voltar"),
        "user__confirm_guidelines_reject_info":
            MessageLookupByLibrary.simpleMessage(
                "Você não pode usar a Somus até aceitar as diretrizes."),
        "user__confirm_guidelines_reject_join_slack":
            MessageLookupByLibrary.simpleMessage("Junte-se ao canal no Slack."),
        "user__confirm_guidelines_reject_title":
            MessageLookupByLibrary.simpleMessage("Rejeição das diretrizes"),
        "user__connect_to_user_add_connection":
            MessageLookupByLibrary.simpleMessage(
                "Adicionar conexão ao círculo"),
        "user__connect_to_user_connect_with_username": m41,
        "user__connect_to_user_done":
            MessageLookupByLibrary.simpleMessage("Pronto"),
        "user__connect_to_user_request_sent":
            MessageLookupByLibrary.simpleMessage("Pedido de conexão enviado"),
        "user__connection_circle_edit":
            MessageLookupByLibrary.simpleMessage("Editar"),
        "user__connection_pending":
            MessageLookupByLibrary.simpleMessage("Pendente"),
        "user__connections_circle_delete":
            MessageLookupByLibrary.simpleMessage("Excluir"),
        "user__connections_header_circle_desc":
            MessageLookupByLibrary.simpleMessage(
                "O círculo com todas as suas conexões é adicionado."),
        "user__connections_header_users":
            MessageLookupByLibrary.simpleMessage("Usuários"),
        "user__delete_account_confirmation_desc":
            MessageLookupByLibrary.simpleMessage(
                "Tem certeza de que deseja excluir sua conta?"),
        "user__delete_account_confirmation_desc_info":
            MessageLookupByLibrary.simpleMessage(
                "Esta é uma ação permanente e não pode ser desfeita."),
        "user__delete_account_confirmation_goodbye":
            MessageLookupByLibrary.simpleMessage("Adeus 😢"),
        "user__delete_account_confirmation_no":
            MessageLookupByLibrary.simpleMessage("Não"),
        "user__delete_account_confirmation_title":
            MessageLookupByLibrary.simpleMessage("Confirmação"),
        "user__delete_account_confirmation_yes":
            MessageLookupByLibrary.simpleMessage("Sim"),
        "user__delete_account_current_pwd":
            MessageLookupByLibrary.simpleMessage("Senha atual"),
        "user__delete_account_current_pwd_hint":
            MessageLookupByLibrary.simpleMessage("Digite a sua senha atual"),
        "user__delete_account_next":
            MessageLookupByLibrary.simpleMessage("Avançar"),
        "user__delete_account_title":
            MessageLookupByLibrary.simpleMessage("Excluir a minha conta"),
        "user__disable_new_post_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Desativar notificações de postagens"),
        "user__disconnect_from_user": m42,
        "user__disconnect_from_user_success":
            MessageLookupByLibrary.simpleMessage("Desconectado com sucesso"),
        "user__edit_profile_bio": MessageLookupByLibrary.simpleMessage("Bio"),
        "user__edit_profile_community_posts":
            MessageLookupByLibrary.simpleMessage("Publicações em comunidades"),
        "user__edit_profile_delete":
            MessageLookupByLibrary.simpleMessage("Excluir"),
        "user__edit_profile_location":
            MessageLookupByLibrary.simpleMessage("Localização"),
        "user__edit_profile_name": MessageLookupByLibrary.simpleMessage("Nome"),
        "user__edit_profile_pick_image":
            MessageLookupByLibrary.simpleMessage("Escolher imagem"),
        "user__edit_profile_pick_image_error_too_large": m43,
        "user__edit_profile_save_text":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "user__edit_profile_url": MessageLookupByLibrary.simpleMessage("Url"),
        "user__edit_profile_user_name_taken": m44,
        "user__edit_profile_username":
            MessageLookupByLibrary.simpleMessage("Nome de usuário"),
        "user__email_verification_error": MessageLookupByLibrary.simpleMessage(
            "Opa! Seu token não era válido ou expirou, por favor tente novamente"),
        "user__email_verification_successful":
            MessageLookupByLibrary.simpleMessage(
                "Incrível! Seu email foi verificado"),
        "user__emoji_field_none_selected":
            MessageLookupByLibrary.simpleMessage("Nenhum emoji selecionado"),
        "user__emoji_search_none_found": m45,
        "user__enable_new_post_notifications":
            MessageLookupByLibrary.simpleMessage(
                "Habilitar notificações de postagem"),
        "user__follow_button_follow_back_text":
            MessageLookupByLibrary.simpleMessage("Seguir de volta"),
        "user__follow_button_follow_text":
            MessageLookupByLibrary.simpleMessage("Seguir"),
        "user__follow_button_following_text":
            MessageLookupByLibrary.simpleMessage("Seguindo"),
        "user__follow_button_unfollow_text":
            MessageLookupByLibrary.simpleMessage("Deixar de seguir"),
        "user__follow_lists_no_list_found":
            MessageLookupByLibrary.simpleMessage("Nenhuma lista encontrada."),
        "user__follow_lists_no_list_found_for": m46,
        "user__follow_lists_search_for":
            MessageLookupByLibrary.simpleMessage("Procurar por uma lista..."),
        "user__follow_lists_title":
            MessageLookupByLibrary.simpleMessage("Minhas listas"),
        "user__follower_plural":
            MessageLookupByLibrary.simpleMessage("seguidores"),
        "user__follower_singular":
            MessageLookupByLibrary.simpleMessage("seguidor"),
        "user__followers_title":
            MessageLookupByLibrary.simpleMessage("Seguidores"),
        "user__following_resource_name":
            MessageLookupByLibrary.simpleMessage("usuários seguidos"),
        "user__following_text":
            MessageLookupByLibrary.simpleMessage("Seguindo"),
        "user__follows_list_accounts_count": m47,
        "user__follows_list_edit":
            MessageLookupByLibrary.simpleMessage("Editar"),
        "user__follows_list_header_title":
            MessageLookupByLibrary.simpleMessage("Usuários"),
        "user__follows_lists_account":
            MessageLookupByLibrary.simpleMessage("1 Conta"),
        "user__follows_lists_accounts": m48,
        "user__groups_see_all": m49,
        "user__guidelines_accept":
            MessageLookupByLibrary.simpleMessage("Aceitar"),
        "user__guidelines_desc": MessageLookupByLibrary.simpleMessage(
            "Por favor, dedique este momento para ler e aceitar as nossas diretrizes."),
        "user__guidelines_reject":
            MessageLookupByLibrary.simpleMessage("Rejeitar"),
        "user__invite": MessageLookupByLibrary.simpleMessage("Convidar"),
        "user__invite_member": MessageLookupByLibrary.simpleMessage("Membro"),
        "user__invite_someone_message": m50,
        "user__invites_accepted_group_item_name":
            MessageLookupByLibrary.simpleMessage("convite aceito"),
        "user__invites_accepted_group_name":
            MessageLookupByLibrary.simpleMessage("convites aceitos"),
        "user__invites_accepted_title":
            MessageLookupByLibrary.simpleMessage("Aceitos"),
        "user__invites_create_create":
            MessageLookupByLibrary.simpleMessage("Criar"),
        "user__invites_create_create_title":
            MessageLookupByLibrary.simpleMessage("Criar convite"),
        "user__invites_create_edit_title":
            MessageLookupByLibrary.simpleMessage("Editar convite"),
        "user__invites_create_name_hint":
            MessageLookupByLibrary.simpleMessage("ex: Joãozinho"),
        "user__invites_create_name_title":
            MessageLookupByLibrary.simpleMessage("Apelido"),
        "user__invites_create_save":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "user__invites_delete": MessageLookupByLibrary.simpleMessage("Excluir"),
        "user__invites_edit_text":
            MessageLookupByLibrary.simpleMessage("Editar"),
        "user__invites_email_hint":
            MessageLookupByLibrary.simpleMessage("ex: joaozinho@email.com"),
        "user__invites_email_invite_text":
            MessageLookupByLibrary.simpleMessage("Convite por email"),
        "user__invites_email_send_text":
            MessageLookupByLibrary.simpleMessage("Enviar"),
        "user__invites_email_sent_text":
            MessageLookupByLibrary.simpleMessage("Email de convite enviado"),
        "user__invites_email_text":
            MessageLookupByLibrary.simpleMessage("Email"),
        "user__invites_invite_a_friend":
            MessageLookupByLibrary.simpleMessage("Convidar um amigo"),
        "user__invites_invite_text":
            MessageLookupByLibrary.simpleMessage("Convidar"),
        "user__invites_joined_with": m51,
        "user__invites_none_left": MessageLookupByLibrary.simpleMessage(
            "Você não tem convites disponíveis."),
        "user__invites_none_used": MessageLookupByLibrary.simpleMessage(
            "Parece que você não usou nenhum convite."),
        "user__invites_pending":
            MessageLookupByLibrary.simpleMessage("Pendente"),
        "user__invites_pending_email": m52,
        "user__invites_pending_group_item_name":
            MessageLookupByLibrary.simpleMessage("convite pendente"),
        "user__invites_pending_group_name":
            MessageLookupByLibrary.simpleMessage("convites pendentes"),
        "user__invites_refresh":
            MessageLookupByLibrary.simpleMessage("Atualizar"),
        "user__invites_share_email": MessageLookupByLibrary.simpleMessage(
            "Compartilhe o convite por email"),
        "user__invites_share_email_desc": MessageLookupByLibrary.simpleMessage(
            "Enviaremos um email de convite com instruções em seu nome"),
        "user__invites_share_yourself": MessageLookupByLibrary.simpleMessage(
            "Compartilhe o convite você mesmo"),
        "user__invites_share_yourself_desc":
            MessageLookupByLibrary.simpleMessage(
                "Escolha um app de mensagens, etc."),
        "user__invites_title":
            MessageLookupByLibrary.simpleMessage("Meus convites"),
        "user__language_settings_save":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "user__language_settings_saved_success":
            MessageLookupByLibrary.simpleMessage("Idioma alterado com sucesso"),
        "user__language_settings_title":
            MessageLookupByLibrary.simpleMessage("Configurações de idioma"),
        "user__list_name_empty_error": MessageLookupByLibrary.simpleMessage(
            "O nome da lista não pode ficar vazio."),
        "user__list_name_range_error": m53,
        "user__million_postfix": MessageLookupByLibrary.simpleMessage("M"),
        "user__profile_action_cancel_connection":
            MessageLookupByLibrary.simpleMessage("Cancelar pedido de conexão"),
        "user__profile_action_deny_connection":
            MessageLookupByLibrary.simpleMessage("Recusar pedido de conexão"),
        "user__profile_action_user_blocked":
            MessageLookupByLibrary.simpleMessage("Usuário bloqueado"),
        "user__profile_action_user_post_notifications_disabled":
            MessageLookupByLibrary.simpleMessage(
                "Notificações de postagem estão desativadas"),
        "user__profile_action_user_post_notifications_enabled":
            MessageLookupByLibrary.simpleMessage(
                "Notificações de postagem estão ativadas"),
        "user__profile_action_user_unblocked":
            MessageLookupByLibrary.simpleMessage("Usuário desbloqueado"),
        "user__profile_bio_length_error": m54,
        "user__profile_in_circles":
            MessageLookupByLibrary.simpleMessage("Em círculos"),
        "user__profile_location_length_error": m55,
        "user__profile_somus_age_toast": m56,
        "user__profile_url_invalid_error": MessageLookupByLibrary.simpleMessage(
            "Por favor, forneça uma url válida."),
        "user__remove_account_from_list":
            MessageLookupByLibrary.simpleMessage("Remover conta das listas"),
        "user__remove_account_from_list_success":
            MessageLookupByLibrary.simpleMessage("Sucesso"),
        "user__save_connection_circle_color_hint":
            MessageLookupByLibrary.simpleMessage("(Toque para alterar)"),
        "user__save_connection_circle_color_name":
            MessageLookupByLibrary.simpleMessage("Cor"),
        "user__save_connection_circle_create":
            MessageLookupByLibrary.simpleMessage("Criar círculo"),
        "user__save_connection_circle_edit":
            MessageLookupByLibrary.simpleMessage("Editar círculo"),
        "user__save_connection_circle_hint":
            MessageLookupByLibrary.simpleMessage(
                "ex: Amigos, Família, Trabalho."),
        "user__save_connection_circle_name":
            MessageLookupByLibrary.simpleMessage("Nome"),
        "user__save_connection_circle_name_taken": m57,
        "user__save_connection_circle_save":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "user__save_connection_circle_users":
            MessageLookupByLibrary.simpleMessage("Usuários"),
        "user__save_follows_list_create":
            MessageLookupByLibrary.simpleMessage("Criar lista"),
        "user__save_follows_list_edit":
            MessageLookupByLibrary.simpleMessage("Editar lista"),
        "user__save_follows_list_emoji":
            MessageLookupByLibrary.simpleMessage("Emoji"),
        "user__save_follows_list_emoji_required_error":
            MessageLookupByLibrary.simpleMessage("Emoji necessário"),
        "user__save_follows_list_hint_text":
            MessageLookupByLibrary.simpleMessage("ex: Viagem, Fotografia"),
        "user__save_follows_list_name":
            MessageLookupByLibrary.simpleMessage("Nome"),
        "user__save_follows_list_name_taken": m58,
        "user__save_follows_list_save":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "user__save_follows_list_users":
            MessageLookupByLibrary.simpleMessage("Usuários"),
        "user__thousand_postfix": MessageLookupByLibrary.simpleMessage("k"),
        "user__tile_delete": MessageLookupByLibrary.simpleMessage("Excluir"),
        "user__tile_following":
            MessageLookupByLibrary.simpleMessage(" · Seguindo"),
        "user__timeline_filters_apply_all":
            MessageLookupByLibrary.simpleMessage("Aplicar filtros"),
        "user__timeline_filters_circles":
            MessageLookupByLibrary.simpleMessage("Círculos"),
        "user__timeline_filters_clear_all":
            MessageLookupByLibrary.simpleMessage("Limpar tudo"),
        "user__timeline_filters_lists":
            MessageLookupByLibrary.simpleMessage("Listas"),
        "user__timeline_filters_no_match": m59,
        "user__timeline_filters_search_desc":
            MessageLookupByLibrary.simpleMessage(
                "Procurar por círculos e listas..."),
        "user__timeline_filters_title":
            MessageLookupByLibrary.simpleMessage("Filtros da linha do tempo"),
        "user__translate_see_translation":
            MessageLookupByLibrary.simpleMessage("Mostrar tradução"),
        "user__translate_show_original":
            MessageLookupByLibrary.simpleMessage("Mostrar original"),
        "user__unblock_user":
            MessageLookupByLibrary.simpleMessage("Desbloquear usuário"),
        "user__uninvite":
            MessageLookupByLibrary.simpleMessage("Cancelar convite"),
        "user__update_connection_circle_save":
            MessageLookupByLibrary.simpleMessage("Salvar"),
        "user__update_connection_circle_updated":
            MessageLookupByLibrary.simpleMessage("Conexão atualizada"),
        "user__update_connection_circles_title":
            MessageLookupByLibrary.simpleMessage(
                "Atualizar círculos de conexão"),
        "user_search__cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "user_search__communities":
            MessageLookupByLibrary.simpleMessage("Comunidades"),
        "user_search__hashtags":
            MessageLookupByLibrary.simpleMessage("Hashtags"),
        "user_search__list_no_results_found": m60,
        "user_search__list_refresh_text":
            MessageLookupByLibrary.simpleMessage("Atualizar"),
        "user_search__list_retry": MessageLookupByLibrary.simpleMessage(
            "Toque para tentar novamente."),
        "user_search__list_search_text": m61,
        "user_search__no_communities_for": m62,
        "user_search__no_hashtags_for": m63,
        "user_search__no_results_for": m64,
        "user_search__no_users_for": m65,
        "user_search__search_text":
            MessageLookupByLibrary.simpleMessage("Pesquisar..."),
        "user_search__searching_for": m66,
        "user_search__users": MessageLookupByLibrary.simpleMessage("Usuários"),
        "video_picker__from_camera":
            MessageLookupByLibrary.simpleMessage("Câmera"),
        "video_picker__from_gallery":
            MessageLookupByLibrary.simpleMessage("Galeria")
      };
}
