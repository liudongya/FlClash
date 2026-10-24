# FlClash Android 并存版自动发布

本仓库的 `Android side-by-side release` 工作流每天检查上游 `chen08209/FlClash` 最新稳定 GitHub Release，也支持 Actions 页面手动运行。构建时使用上游正式 tag 的源代码。

- Android 安装包名：`app.routelight.mobile`（不含用户名或 clash）
- 手机桌面名称：`FlClash Side`
- 应用内“检查更新”和“下载新版”：`https://github.com/liudongya/FlClash/releases/latest`
- 目标：Android ARM64 APK；未来版本发布在本仓库 Releases，已发布的版本跳过
- Kotlin namespace、类名和 Dart/Android 通信通道继续使用原始内部标识，以避免运行异常；不影响安装包名
- 与原版数据独立；同一时刻 Android 通常只能运行一个 VPN

## 首次运行前：配置长期签名密钥

请到 [Actions Secrets](https://github.com/liudongya/FlClash/settings/secrets/actions) 添加以下四个 Repository secrets，**不要将签名私钥上传到代码仓库**：

| Secret | 值 |
| --- | --- |
| `KEYSTORE` | `keystore.jks` 文件的单行 Base64 |
| `KEY_ALIAS` | 签名 key alias |
| `STORE_PASSWORD` | keystore 密码 |
| `KEY_PASSWORD` | key 密码 |

在本地安装 Java 后可创建签名密钥：

```bash
keytool -genkeypair -v -keystore keystore.jks -storetype JKS -alias routekey -keyalg RSA -keysize 3072 -validity 10000 -dname "CN=Private Android Build, OU=Personal, O=Private, C=US"
base64 -w0 keystore.jks
```

第二个命令适合 Linux；macOS 可用 `base64 < keystore.jks | tr -d '\n'`。生成的 Base64 是你的私钥材料，只能放在 GitHub Secret 中。请备份 keystore 与密码，后续新 APK 必须使用同一签名才能覆盖升级。

设置后进入 [Actions 工作流](https://github.com/liudongya/FlClash/actions/workflows/android-side-release.yml)，必要时先启用 Fork 工作流，再选择 `Run workflow`。编译成功后在 [Releases](https://github.com/liudongya/FlClash/releases) 下载独立版 APK。

如果上游更改项目结构、依赖或构建方式，工作流会失败而不会发布未经验证的文件。所有打包均在 GitHub Actions 云端完成，手机不需要构建环境。
