// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io show exitCode;
import 'dart:io';

import 'package:args/args.dart' show ArgParser, ArgResults;
import 'package:front_end/src/api_unstable/vm.dart'
    show
        CompilerOptions,
        InvocationMode,
        DiagnosticMessage,
        Verbosity,
        parseExperimentalArguments,
        parseExperimentalFlags,
        resolveInputUri;
import 'package:kernel/ast.dart' show Component;
import 'package:vm/kernel_front_end.dart'
    show
        badUsageExitCode,
        compileTimeErrorExitCode,
        compileToKernel,
        convertToPackageUri,
        createFrontEndFileSystem,
        createFrontEndTarget,
        ErrorDetector,
        ErrorPrinter,
        KernelCompilationArguments,
        parseCommandLineDefines,
        successExitCode,
        writeDepfile;

import 'dart_to_cpp_compiler.dart';

final ArgParser _argParser = ArgParser(allowTrailingOptions: true)
  ..addOption('platform',
      help: 'Path to vm_platform_strong.dill file', defaultsTo: null)
  ..addOption('packages',
      help: 'Path to .dart_tool/package_config.json file', defaultsTo: null)
  ..addOption('output',
      abbr: 'o', help: 'Path to resulting C++ file', defaultsTo: null)
  ..addFlag('help',
      abbr: 'h', negatable: false, help: 'Print this help message.')
  ..addOption('verbosity',
      help: 'Sets the verbosity level used for filtering messages during '
          'compilation.',
      defaultsTo: Verbosity.defaultValue);

final String _usage = '''
Usage: dart2cpp [options] input.dart
Compiles Dart sources to C++ code.

Options:
${_argParser.usage}
''';

Future<void> main(List<String> arguments) async {
  // 如果没有提供参数，使用默认的测试参数
  if (arguments.isEmpty) {
    arguments = [
      "--platform=/Users/alsc/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill",
      "/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp/sample/dart/basic_syntax.dart"
    ];
  } else {
    // 如果只提供了输入文件，自动添加platform参数
    if (arguments.length == 1 && !arguments[0].startsWith('--')) {
      arguments = [
        "--platform=/Users/alsc/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill",
        arguments[0]
      ];
    }
  }
  io.exitCode = await runCompiler(_argParser.parse(arguments));
}

/// Run bytecode compiler tool with given [options]
/// and return exit code.
Future<int> runCompiler(ArgResults options) async {
  final String? platformKernel = options['platform'];

  if (options['help']) {
    print(_usage);
    return successExitCode;
  }

  final String? input = options.rest.singleOrNull;
  if (input == null || platformKernel == null) {
    print(_usage);
    return badUsageExitCode;
  }

  // 获取输入文件的基本名称（不含路径和扩展名）
  final inputFile = File(input);
  final baseName = inputFile.uri.pathSegments.last.replaceAll('.dart', '');

  // 默认输出到demo/cpp目录
  final String outputFileName =
      options['output'] ?? "${inputFile.parent.path}/cpp/${baseName}.cpp";
  final String? packages = options['packages'];
  final Uri? packagesUri = packages != null ? resolveInputUri(packages) : null;
  final platformKernelUri = Uri.base.resolveUri(new Uri.file(platformKernel));

  final verbosity = Verbosity.parseArgument(options['verbosity']);
  final errorPrinter = ErrorPrinter(verbosity);
  final errorDetector = ErrorDetector(previousErrorHandler: errorPrinter.call);

  Uri mainUri = resolveInputUri(input);
  if (packagesUri != null) {
    final fileSystem = createFrontEndFileSystem("", []);
    mainUri = await convertToPackageUri(fileSystem, mainUri, packagesUri);
  }

  final CompilerOptions compilerOptions = CompilerOptions()
    ..sdkSummary = platformKernelUri
    ..packagesFileUri = packagesUri
    ..onDiagnostic = (DiagnosticMessage m) {
      errorDetector(m);
    }
    ..embedSourceText = false
    ..verbosity = verbosity;

  compilerOptions.target = createFrontEndTarget('vm', supportMirrors: false);
  if (compilerOptions.target == null) {
    print('Failed to create front-end target.');
    return badUsageExitCode;
  }

  final results = await compileToKernel(KernelCompilationArguments(
      source: mainUri,
      options: compilerOptions,
      requireMain: false,
      includePlatform: false,
      environmentDefines: {},
      enableAsserts: false));

  errorPrinter.printCompilationMessages();

  final Component? component = results.component;
  if (errorDetector.hasCompilationErrors || component == null) {
    return compileTimeErrorExitCode;
  }

  // 使用统一的转换入口
  await _transformToCpp(component, outputFileName);

  return successExitCode;
}

/// 统一的转换入口点 - 使用真实的Component进行转换
Future<void> _transformToCpp(Component component, String outputFileName) async {
  try {
    print('🔄 开始转换 Dart 到 C++...');

    // 直接使用真实的Component进行转换
    final transformer = DartToCppTransformer();
    String cppCode = transformer.transformComponent(component);

    // // 添加运行时支持
    // cppCode = Dart2CppCompiler.addRuntimeSupport(cppCode);

    // 确保输出目录存在
    final outputFile = File(outputFileName);
    await outputFile.parent.create(recursive: true);

    // 写入C++文件
    await outputFile.writeAsString(cppCode);

    print('✅ 转换完成！');
    print('📁 输出文件: $outputFileName');
    print('📊 代码大小: ${cppCode.length} 字符');

    // 同时生成Dart转换版本
  } catch (e, stackTrace) {
    print('❌ 转换失败: $e');
    print('堆栈跟踪: $stackTrace');
    rethrow;
  }
}
