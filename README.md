# Read Managed App Configuration Values

![](Docs/screenshot.jpg)

MDMシステムのManaged App Configurationで設定した値を読み取るサンプル。Managed App Configurationの設定は`UserDefaults`の`com.apple.configuration.managed`キーでアクセスができる。

```swift
private func fetchAppConfig() -> [String: AnyObject] {
    return UserDefaults.standard.dictionary(forKey: "com.apple.configuration.managed") as? [String: AnyObject] ?? [:]
}
```

ローカルのsimulatorでは次のようにして確認
```sh
xcrun simctl spawn booted defaults write <bundle id> com.apple.configuration.managed -dict yes "ok" burabura "hoge hoge hoge" secret_num -int 42 dead_or_alive -bool false
```