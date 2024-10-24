import 'dart:convert';

import 'package:crypto/crypto.dart';

String getGravatarUrl(String email, {int size = 200}) {
  final String trimmedEmail = email.trim().toLowerCase();

  final String emailHash = md5.convert(utf8.encode(trimmedEmail)).toString();

  return 'https://www.gravatar.com/avatar/$emailHash?s=$size';
}

String getGitHubIdenticonUrl(String username, {int size = 200}) {
  return 'https://github.com/identicons/$username.png';
}

String getDiceBearAvatar(String seed, {int size = 200}) {
  return 'https://avatars.dicebear.com/v2/identicon/$seed.svg?size=$size';
}
