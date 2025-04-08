### SCOOP 介绍

Scoop**是一款适用于 Windows 平台的命令行软件（包）管理工具**。 简单来说，就是可以通过命令行工具（PowerShell、CMD 等）实现软件（包）的安装管理等需求，通过简单的一行代码实现软件的下载、安装、卸载、更新等操作。

官网安装说明书： [ScoopInstaller](https://github.com/ScoopInstaller)

1. 先决条件

   - [PowerShell](https://aka.ms/powershell)最新版本或[Windows PowerShell 5.1](https://aka.ms/wmf5download)

1. PowerShell 执行策略：

   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

### 安装 scoop

下载安装脚本,在 Powershell 中执行以下命令

```powershell
irm get.scoop.sh -outfile 'install.ps1'
```

管理员执行安装脚本

```powershell
.\install.ps1 -RunAsAdmin -ScoopDir 'C:\Base' -ScoopGlobalDir 'C:\Global' -NoProxy
```

- 其中`-RunAsAdmin`是使用管理员角色执行脚本，`-ScoopDir`指定 scoop 安装目录，软件默认安装在此。`-ScoopGlobalDir`指定全局程序安装到自定义目录。

### scoop 初始化配置

- **给 scoop 设置全局代理**（可选，科学上网实现加快软件下载速度）

```powershell
# 设置全局代理
scoop config proxy 127.0.0.1:7890
# 取消全局代理
scoop config rm proxy
```

- **多线程下载**

使用 Scoop 安装 Aria 2 后，Scoop 会自动调用 Aria 2 进行多线程加速下载。

```powershell
scoop install aria2
```

使用 `scoop config` 命令可以对 Aria 2 进行设置，比如 `scoop config aria2-enabled false` 可以禁止调用 Aria 2 下载。以下是与 Aria 2 有关的设置选项：

- `aria2-enabled`: 开启 Aria 2 下载，默认 `true`
- `aria2-retry-wait`: 重试等待秒数，默认 `2`
- `aria2-split`: 单任务最大连接数，默认 `5`
- `aria2-max-connection-per-server`: 单[服务器](https://cloud.tencent.com/act/pro/promotion-cvm?from_column=20065&from=20065)最大连接数，默认 `5` ，最大 `16`
- `aria2-min-split-size`: 最小文件分片大小，默认 `5M`

默认情况下，Scoop 在下载应用时是单线程的，直接的感受是——慢，借助 aria2 可以使 Scoop 具有多线程下载的能力。当然，你需要先安装 aria2，然后执行以下命令：
在这里推荐以下优化设置，单任务最大连接数设置为 `32`，单服务器最大连接数设置为 `16`，最小文件分片大小设置为 `1M`

```powershell
scoop config aria2-enabled true
scoop config aria2-retry-wait 3
scoop config aria2-split 32
scoop config aria2-max-connection-per-server 16
scoop config aria2-min-split-size 1M
```

- **scoop 使用**

添加仓库

```powershell
# 添加仓库
scoop bucket add transnull https://github.com/transnull/scoop-bucket

```

安装应用程序

```
scoop install xxxxx -g
```

**备注：** `xxxx` 为所要安装的软件名称，`-g`指定程序安装到自定义目录，不加`-g`选项则安装到默认目录-g
