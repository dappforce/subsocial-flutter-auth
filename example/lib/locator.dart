import 'package:get_it/get_it.dart';
import 'package:subsocial_flutter_auth/subsocial_flutter_auth.dart';
import 'package:subsocial_sdk/subsocial_sdk.dart';

final sl = GetIt.I;

Future<void> setUpLocator() async {
  sl.registerSingletonAsync(() => Subsocial.instance);
  sl.registerSingletonAsync(() async => SubsocialAuth.defaultConfiguration(
        sdk: await sl.getAsync(),
      ));

  return sl.allReady();
}
