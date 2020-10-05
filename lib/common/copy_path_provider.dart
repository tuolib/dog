// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io' show Directory, Platform;

import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';


bool _disablePlatformOverride = false;
PathProviderPlatform __platform;

// This is to manually endorse the linux path provider until automatic registration of dart plugins is implemented.
// See this issue https://github.com/flutter/flutter/issues/52267 for details
PathProviderPlatform get _platform {
  if (__platform != null) {
    return __platform;
  }
  if (!kIsWeb && Platform.isLinux && !_disablePlatformOverride) {
    __platform = PathProviderLinux();
  } else {
    __platform = PathProviderPlatform.instance;
  }
  return __platform;
}


Future<String> getExternalStorageDirectoryCopy() async {
  final String path = await _platform.getExternalStoragePath();
  if (path == null) {
    return null;
  }
  return path;
}
