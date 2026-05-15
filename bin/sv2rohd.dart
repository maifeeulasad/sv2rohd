// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:sv2rohd/sv2rohd.dart' as sv;

/// Thin wrapper that forwards to the package CLI implementation in `lib/src/sv2rohd.dart`.
Future<void> main(List<String> args) async {
  sv.main(args);
}
