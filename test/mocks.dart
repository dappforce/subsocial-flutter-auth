import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:subsocial_sdk/subsocial_sdk.dart';

class MockSubsocial extends Mock implements Subsocial {}

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  static MockPathProviderPlatform setUp() {
    final mock = MockPathProviderPlatform();
    PathProviderPlatform.instance = mock;
    return mock;
  }
}
