import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/core/service/impl/file_service_impl.dart';

class CoreDependencyContainer extends DependencyInitializer {
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
}

class CoreDependency extends InheritedWidget {
  const CoreDependency({
    required super.child,
    required this.container,
    super.key,
  });

  final CoreDependencyContainer container;

  @override
  bool updateShouldNotify(covariant CoreDependency oldWidget) =>
      oldWidget.container != container;

  static CoreDependencyContainer of(
    BuildContext context, {
    bool listen = false,
  }) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<CoreDependency>()!
          .container;
    } else {
      final element =
          context.getElementForInheritedWidgetOfExactType<CoreDependency>();

      assert(element != null, 'CoreDependency not found in context');

      return (element!.widget as CoreDependency).container;
    }
  }
}
