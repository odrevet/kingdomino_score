import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

// C function signatures
typedef _version_func = ffi.Pointer<Utf8> Function();
typedef _process_image_func = ffi.Double Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Dart function signatures
typedef _VersionFunc = ffi.Pointer<Utf8> Function();
typedef _ProcessImageFunc = double Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Getting a library that holds needed symbols
ffi.DynamicLibrary _lib = Platform.isAndroid
    ? ffi.DynamicLibrary.open('libnative_opencv.so')
    : ffi.DynamicLibrary.process();

// Looking for the functions
final _VersionFunc _version = _lib
    .lookup<ffi.NativeFunction<_version_func>>('version')
    .asFunction();
final _ProcessImageFunc _processImage = _lib
    .lookup<ffi.NativeFunction<_process_image_func>>('process_image')
    .asFunction();

ffi.Pointer<Utf8> opencvVersion() {
  return _version();
}

double processImage(ProcessImageArguments args) {
  return _processImage(args.input1.toNativeUtf8(), args.input2.toNativeUtf8());
}

class ProcessImageArguments {
  final String input1;
  final String input2;

  ProcessImageArguments(this.input1, this.input2);
}