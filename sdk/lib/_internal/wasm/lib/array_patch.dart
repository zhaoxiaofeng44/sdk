// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:_internal' show patch, EfficientLengthIterable;
import 'dart:_list';
import 'dart:_wasm';
import 'cpp_collection.dart';

@patch
class List<E> {
  @patch
  @pragma("wasm:prefer-inline")
  factory List.empty({bool growable = false}) =>
      CppList<E>.empty(growable: growable);

  @patch
  @pragma("wasm:prefer-inline")
  factory List.filled(int length, E fill, {bool growable = false}) =>
      CppList<E>.filled(length, fill, growable: growable);

  @patch
  @pragma("wasm:prefer-inline")
  factory List.from(Iterable elements, {bool growable = true}) =>
      CppList<E>.from(elements, growable: growable);

  @patch
  @pragma("wasm:prefer-inline")
  factory List.of(Iterable<E> elements, {bool growable = true}) =>
      CppList<E>.of(elements, growable: growable);

  @patch
  @pragma("wasm:prefer-inline")
  factory List.generate(
    int length,
    E generator(int index), {
    bool growable = true,
  }) =>
      CppList<E>.generate(length, generator, growable: growable);
  @patch
  @pragma("wasm:prefer-inline")
  factory List.unmodifiable(Iterable elements) =>
      CppList<E>.unmodifiable(elements);
}
