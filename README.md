# ccms_des

DES加密方法，不使用向量，只使用key进行加密

## Getting Started

### Add dependency

```yaml
dependencies:
  flutter_des: ^0.0.1  #latest version
```

### Example

```dart
import 'package:ccms_des/ccms_des.dart';

void example() async {
  const _string = "testMessage";
  const _key = "12345678";

  var encrypt = await CcmsDes.encryptToHex(_string, _key);
  var decrypt = await CcmsDes.decryptToHex(_string, _key);
}
```

