import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/core/service/impl/file_service_impl.dart';

class CoreDependencyContainer extends DependencyContainer {
  CoreDependencyContainer();

  //therd party dependencies
  late final SharedPreferencesAsync sharedPreferences;
  late final ImagePicker _imagePicker;

  //services
  late final FileService fileService;

  @override
  Future<void> initialize() async {
    sharedPreferences = SharedPreferencesAsync();
    _imagePicker = ImagePicker();
    fileService = FileServiceImpl(imagePicker: _imagePicker);
  }

  @override
  Future<void> dispose() async {}
}

class CoreDependencyScope extends InheritedWidget {
  const CoreDependencyScope({
    required super.child,
    required this.container,
    super.key,
  });

  final CoreDependencyContainer container;

  @override
  bool updateShouldNotify(covariant CoreDependencyScope oldWidget) =>
      oldWidget.container != container;

  static CoreDependencyContainer of(
    BuildContext context, {
    bool listen = false,
  }) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<CoreDependencyScope>()!
          .container;
    } else {
      final element = context
          .getElementForInheritedWidgetOfExactType<CoreDependencyScope>();
      assert(element != null, 'CoreDependencyScope not found in context');
      return (element!.widget as CoreDependencyScope).container;
    }
  }
}
