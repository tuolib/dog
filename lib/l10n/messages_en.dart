// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'There are no emails left', one: 'There is ${howMany} email left', other: 'There are ${howMany} emails left')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "auto" : MessageLookupByLibrary.simpleMessage("Auto"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "contacts" : MessageLookupByLibrary.simpleMessage("Contacts"),
    "discovery" : MessageLookupByLibrary.simpleMessage("Discovery"),
    "home" : MessageLookupByLibrary.simpleMessage("Home"),
    "language" : MessageLookupByLibrary.simpleMessage("Language"),
    "login" : MessageLookupByLibrary.simpleMessage("Login"),
    "logout" : MessageLookupByLibrary.simpleMessage("Log out"),
    "logoutTip" : MessageLookupByLibrary.simpleMessage("Log out tip"),
    "message" : MessageLookupByLibrary.simpleMessage("Message"),
    "noDescription" : MessageLookupByLibrary.simpleMessage("noDescription"),
    "password" : MessageLookupByLibrary.simpleMessage("Password"),
    "passwordRequired" : MessageLookupByLibrary.simpleMessage("Password required"),
    "personal" : MessageLookupByLibrary.simpleMessage("Personal"),
    "remainingEmailsMessage" : m0,
    "theme" : MessageLookupByLibrary.simpleMessage("Theme"),
    "title" : MessageLookupByLibrary.simpleMessage("Flutter APP"),
    "userName" : MessageLookupByLibrary.simpleMessage("User name"),
    "userNameOrEmail" : MessageLookupByLibrary.simpleMessage("User name or email"),
    "userNameOrPasswordWrong" : MessageLookupByLibrary.simpleMessage("User name or password wrong"),
    "userNameRequired" : MessageLookupByLibrary.simpleMessage("User name required"),
    "yes" : MessageLookupByLibrary.simpleMessage("Yes")
  };
}
