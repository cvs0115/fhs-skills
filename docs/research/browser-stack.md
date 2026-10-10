# Research · browser · Server browser stack

2026-10-10. Read-only research on dev-lxc-1 as user `fhsbuild` (uid 999, home `/srv/fhs-build`, shell `/bin/bash`; `getent passwd fhsbuild`). No apt install, no listening port opened by this research, no login submitted. `npx` downloads went to `/srv/fhs-build/.npm`. The default `node` on `PATH` is Cursor's binary (`/srv/fhs-build/.local/share/cursor-agent/versions/2026.10.01-e373342/node`, v24.5.0). `npx --yes @playwright/mcp@0.0.83 --help` with that `node` first failed: `ENOENT` lstat `/srv/fhs-build/.local/share/cursor-agent/versions/lib` (npm log `~/.npm/_logs/2026-10-10T13_33_30_022Z-debug-0.log`). The same command succeeded with `PATH` starting at `/usr/bin` (`node` v20.20.2). That is the command behind the `--help` paste below.

## 1. Playwright MCP

**Package and pin.** npm registry, 2026-10-10T13:33:20Z:

```text
npm view @playwright/mcp name version description homepage repository bin --json
```

```text
{
  "name": "@playwright/mcp",
  "version": "0.0.83",
  "description": "Playwright Tools for MCP",
  "homepage": "https://playwright.dev",
  "repository": {
    "url": "git+https://github.com/microsoft/playwright-mcp.git",
    "type": "git"
  },
  "bin": { "playwright-mcp": "cli.js" }
}
```

`npm view @playwright/mcp@0.0.83 gitHead dependencies --json` returned gitHead `f183dad4a52965583e3cc1d59b88cdc279e2e57d` and dependencies `playwright` and `playwright-core` both `1.64.0-alpha-1790635538000`. That alpha is what this MCP package ships. `npm view playwright version` at the same time returned stable `1.64.0`, which is a different version and is not the dependency. `package.json` in the unpacked 0.0.83 tree also says `"engines": { "node": ">=18" }`. Host `/usr/bin/node` is v20.20.2.

**Pin:** `@playwright/mcp@0.0.83` together with `playwright@1.64.0-alpha-1790635538000` and `playwright-core@1.64.0-alpha-1790635538000`. Do not pin floating `@latest`, and do not swap in stable Playwright 1.64.0 unless a later check shows the MCP package depends on it.

**`--help` (real output).** Command: `PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" npx --yes @playwright/mcp@0.0.83 --help`

```text
Usage: Playwright MCP [options]

Options:
  -V, --version                         output the version number
  --allowed-hosts <hosts...>            comma-separated list of hosts this
                                        server is allowed to serve from.
                                        Defaults to the host the server is bound
                                        to. Pass '*' to disable the host check.
  --allowed-origins <origins>           semicolon-separated list of TRUSTED
                                        origins to allow the browser to request.
                                        Default is to allow all.
                                        Important: *does not* serve as a
                                        security boundary and *does not* affect
                                        redirects.
  --allow-unrestricted-file-access      allow access to files outside of the
                                        workspace roots. Also allows
                                        unrestricted access to file:// URLs. By
                                        default access to file system is
                                        restricted to workspace root directories
                                        (or cwd if no roots are configured)
                                        only, and navigation to file:// URLs is
                                        blocked.
  --blocked-origins <origins>           semicolon-separated list of origins to
                                        block the browser from requesting.
                                        Blocklist is evaluated before allowlist.
                                        If used without the allowlist, requests
                                        not matching the blocklist are still
                                        allowed.
                                        Important: *does not* serve as a
                                        security boundary and *does not* affect
                                        redirects.
  --block-service-workers               block service workers
  --browser <browser>                   browser or chrome channel to use,
                                        possible values: chrome, firefox,
                                        webkit, msedge.
  --caps <caps>                         comma-separated list of additional
                                        capabilities to enable, possible values:
                                        vision, pdf, devtools.
  --cdp-endpoint <endpoint>             CDP endpoint to connect to.
  --cdp-header <headers...>             CDP headers to send with the connect
                                        request, multiple can be specified.
  --cdp-timeout <timeout>               timeout in milliseconds for connecting
                                        to CDP endpoint, defaults to 30000ms
  --codegen <lang>                      specify the language to use for code
                                        generation, possible values:
                                        "typescript", "python", "java",
                                        "csharp", "none". Default is
                                        "typescript".
  --config <path>                       path to the configuration file.
  --console-level <level>               level of console messages to return:
                                        "error", "warning", "info", "debug".
                                        Each level includes the messages of more
                                        severe levels.
  --device <device>                     device to emulate, for example: "iPhone
                                        15"
  --mobile                              emulate a generic mobile device (Pixel
                                        10 for Chromium, iPhone 17 for WebKit).
                                        Mobile pages are usually lighter, which
                                        saves tokens. Cannot be combined with
                                        --device.
  --executable-path <path>              path to the browser executable.
  --extension                           Connect to a running browser instance
                                        (Edge/Chrome only). Requires the
                                        "Playwright Extension" to be installed.
  --endpoint <endpoint>                 Bound browser endpoint to connect to.
  --file-paths <mode>                   how file paths are rendered in tool
                                        results, "relative" to the workspace
                                        root or "absolute". Default is
                                        "relative".
  --grant-permissions <permissions...>  List of permissions to grant to the
                                        browser context, for example
                                        "geolocation", "clipboard-read",
                                        "clipboard-write".
  --headless                            run browser in headless mode, headed by
                                        default
  --host <host>                         host to bind server to. Default is
                                        localhost. Use 0.0.0.0 to bind to all
                                        interfaces.
  --idle-timeout <timeout>              close the browser after this many
                                        milliseconds without a completed tool
                                        call, the next tool call relaunches it.
                                        Defaults to one hour for headless
                                        browsers, never for headed ones, 0
                                        disables.
  --ignore-https-errors                 ignore https errors
  --init-page <path...>                 path to TypeScript file to evaluate on
                                        Playwright page object
  --init-script <path...>               path to JavaScript file to add as an
                                        initialization script. The script will
                                        be evaluated in every page before any of
                                        the page's scripts. Can be specified
                                        multiple times.
  --isolated                            keep the browser profile in memory, do
                                        not save it to disk.
  --image-responses <mode>              whether to send image responses to the
                                        client. Can be "allow", "omit" or
                                        "only". With "only", a response that
                                        carries an image consists of the image
                                        parts alone, without the text part.
                                        Defaults to "allow".
  --no-sandbox                          disable the sandbox for all process
                                        types that are normally sandboxed.
  --no-webmcp                           do not collect or expose the tools that
                                        a page registers through the WebMCP API.
  --output-dir <path>                   path to the directory for automatically
                                        named output files, for example a
                                        screenshot taken without an explicit
                                        file name. Files with an explicit name
                                        are resolved against the workspace root
                                        instead and are not affected by this
                                        option.
  --output-max-size <bytes>             Threshold for evicting old output files,
                                        in bytes.
  --port <port>                         port to listen on for SSE transport.
  --profile-dir-name <name>             name of the profile directory in the
                                        user data dir to connect to with
                                        --extension, for example "Profile 1".
                                        Defaults to the last used profile that
                                        has the extension installed.
  --proxy-bypass <bypass>               comma-separated domains to bypass proxy,
                                        for example
                                        ".com,chromium.org,.domain.com"
  --proxy-server <proxy>                specify proxy server, for example
                                        "http://myproxy:3128" or
                                        "socks5://myproxy:8080"
  --sandbox                             enable the sandbox for all process types
                                        that are normally not sandboxed.
  --save-session                        Whether to save the Playwright MCP
                                        session into the output directory.
  --secrets <path>                      path to a file containing secrets in the
                                        dotenv format
  --shared-browser-context              reuse the same browser context between
                                        all connected HTTP clients.
  --snapshot-boxes                      include each element's bounding box as
                                        [box=x,y,width,height] in snapshots.
                                        Coordinates are viewport-relative, in
                                        CSS pixels.
  --snapshot-mode <mode>                when taking snapshots for responses,
                                        specifies the mode to use. Can be "full"
                                        or "none". Default is "full".
  --storage-state <path>                path to the storage state file for
                                        isolated sessions.
  --test-id-attribute <attribute>       specify the attribute to use for test
                                        ids, defaults to "data-testid"
  --timeout-action <timeout>            specify action timeout in milliseconds,
                                        defaults to 5000ms
  --timeout-navigation <timeout>        specify navigation timeout in
                                        milliseconds, defaults to 60000ms
  --timeout-settle <timeout>            how long to wait after each action for
                                        triggered work to settle, in
                                        milliseconds, defaults to 500ms
  --user-agent <ua string>              specify user agent string
  --user-data-dir <path>                path to the user data directory. If not
                                        specified, a temporary directory will be
                                        created.
  --viewport-size <size>                specify browser viewport size in pixels,
                                        for example "1280x720"
  -h, --help                            display help for command
```

Flags the task asked for:

| Need | Flag |
|---|---|
| HTTP/SSE port | `--port <port>` ("port to listen on for SSE transport") |
| Host | `--host <host>` ("Default is localhost. Use 0.0.0.0 to bind to all interfaces.") |
| Persistent user-data directory | `--user-data-dir <path>` |
| Headed vs headless | headed by default; `--headless` turns headless on |
| Browser executable | `--executable-path <path>` |
| Allowed origins | `--allowed-origins <origins>` semicolon-separated; default allow all |
| Blocked origins | `--blocked-origins <origins>` semicolon-separated; blocklist first |

Both origin flags say they do not serve as a security boundary and do not affect redirects. `--allowed-hosts` is a separate check on the HTTP `Host` header of the MCP server, not on sites the browser may open.

Commander option inspection (same unpacked package, no server started) shows `--no-sandbox` is the negation of `--sandbox` (both attribute name `sandbox`; `--no-sandbox` has `negate: true`).

**What `--port` actually serves.** In `playwright-core/lib/coreBundle.js` from this install, the embedded source path is `packages/playwright-core/src/tools/utils/mcp/http.ts`. `installHttpTransport` sends any path starting with `/sse` to `handleSSE` (a new `SSEServerTransport("/sse", res)` on `GET`, stored in an `sseSessions` Map). Every other path goes to `handleStreamable` (`StreamableHTTPServerTransport`, sessions in a `streamableSessions` Map). So one port serves both SSE (`GET /sse`) and streamable HTTP (the README's `/mcp` path is not special-cased; it simply does not start with `/sse`). If `--port` is omitted, `start()` uses stdio (`StdioServerTransport`) and does not listen. The README section "Standalone MCP server" in `@playwright/mcp@0.0.83` says:

```bash
npx @playwright/mcp@latest --port 8931
```

and the client `url` is `http://localhost:8931/mcp`.

**Two HTTP clients, one MCP process.** Re-read 2026-10-10 from the unpacked `@playwright/mcp@0.0.83` bundle (`playwright-core/lib/coreBundle.js`) and from `cli.js --help` on that same tree. Help text:

- `--isolated`: "keep the browser profile in memory, do not save it to disk."
- `--shared-browser-context`: "reuse the same browser context between all connected HTTP clients."

The MCP command action (embedded path `packages/playwright-core/src/tools/mcp/program.ts`) sets:

```text
const useSharedBrowser = config.sharedBrowserContext || config.browser.isolated;
```

`factory.create` runs for each connected client (`connect()` builds a new MCP `Server` per SSE or streamable session; the session maps have no size check). When `useSharedBrowser` is set, the first client launches one browser (`sharedBrowserPromise` via `createBrowserWithInfo`) and every client, including the first, calls `connectToBrowserEndpoint` on that browser. The context line is: if `config.browser.isolated`, `browser.newContext(config.browser.contextOptions)`; otherwise `browser.contexts()[0]` or a new context. `createBrowser` sends an isolated launch to `createIsolatedBrowser` (`browserType.launch`, no profile directory) and every other local launch to `createPersistentBrowser`. `defaultConfig` does not set `browser.isolated`. `resolveCLIConfigForMCP` does not default it either. `resolveCLIConfigForCLI` does default `browser.isolated` when no profile is set; that function is the Playwright CLI, not this MCP server.

For two HTTP clients of this one process:

- **Default (neither flag).** `useSharedBrowser` is false. Each client calls `createPersistentBrowser` and gets its own browser. The profile directory is locked: `createPersistentBrowser` throws `Browser is already in use for ${userDataDir}, use --isolated to run multiple instances of the same browser` when the profile lock is held. Two clients that hash to the same default directory (same `clientInfo.cwd`) hit that lock; two different workspace directories get two browsers.
- **`--isolated`.** `useSharedBrowser` is true because `config.browser.isolated` is true, even without `--shared-browser-context`. One in-memory browser, and each client gets `browser.newContext(...)` (separate cookies and pages). The profile is not saved. `validateBrowserConfig` throws `Browser userDataDir is not supported in isolated mode.` if `--user-data-dir` is also set.
- **`--shared-browser-context`.** One browser, and clients reuse `browser.contexts()[0]` (same cookies and pages). `browser_close` throws `The browser context is shared between clients and cannot be closed.` This flag does not refuse a second client.
- **Both flags.** `useSharedBrowser` is still true. `createBrowser` takes the isolated branch, and the context line follows `config.browser.isolated`, so each client gets a new context on that one in-memory browser. `--user-data-dir` is still rejected.

A live second client was not connected (that would listen). The behavior above is the shipped source, not a runtime trial.

**Default profile path (source, not the help sentence).** `--user-data-dir`'s help says a missing path creates a temporary directory. For the default (not `--isolated`) path, `createPersistentBrowser` does `config.browser.userDataDir ?? await createUserDataDir(...)`. `createUserDataDir` joins `defaultCacheDirectory()` with `ms-playwright-mcp` and `mcp-${browserToken}-${hash}`. `computeDefaultCacheDirectory` on Linux is `XDG_CACHE_HOME` or `~/.cache`. The hash is SHA-256 of the MCP client's workspace directory (`clientInfo.cwd`), first 7 hex characters. So the default persistent profile is:

`~/.cache/ms-playwright-mcp/mcp-<browser>-<7-hex>`

The README "User profile" section in the same package says `~/.cache/ms-playwright/mcp-{channel}-{workspace-hash}`. That path does not match this source. Trust the source for 0.0.83. Pass an explicit `--user-data-dir` owned by the browser user so the location does not depend on whichever directory the client reports.

## 2. Browser binary

Command (playwright already unpacked by the `npx` above; cache directory was still absent afterward):

```text
node node_modules/playwright/cli.js install --dry-run chromium
```

```text
Chrome for Testing 155.0.8059.12 (playwright chromium v1247)
  Install location:    /srv/fhs-build/.cache/ms-playwright/chromium-1247
  Download url:        https://cdn.playwright.dev/builds/cft/155.0.8059.12/linux64/chrome-linux64.zip

FFmpeg (playwright ffmpeg v1011)
  Install location:    /srv/fhs-build/.cache/ms-playwright/ffmpeg-1011
  Download url:        https://cdn.playwright.dev/dbazure/download/playwright/builds/ffmpeg/1011/ffmpeg-linux.zip

Chrome Headless Shell 155.0.8059.12 (playwright chromium-headless-shell v1247)
  Install location:    /srv/fhs-build/.cache/ms-playwright/chromium_headless_shell-1247
  Download url:        https://cdn.playwright.dev/builds/cft/155.0.8059.12/linux64/chrome-headless-shell-linux64.zip
```

`playwright-core/browsers.json` in that tree: chromium `revision` `1247`, `browserVersion` `155.0.8059.12`, `title` `Chrome for Testing`. The executable relative path in the bundle is `EXECUTABLE_PATHS.chromium["linux-x64"] = ["chrome-linux64", "chrome"]`. Per-user install path:

`~/.cache/ms-playwright/chromium-1247/chrome-linux64/chrome`

(`defaultRegistryDirectory()` is `defaultCacheDirectory()` plus `ms-playwright`. For this account that is `/srv/fhs-build/.cache/ms-playwright/...`. A different user gets that user's own `~/.cache`.)

**Size.** `curl -sI -L` of the Chrome for Testing zip: final `HTTP/2 200`, `content-length: 198335306` (redirects to `storage.googleapis.com/chrome-for-testing-public/155.0.8059.12/linux64/chrome-linux64.zip`). Headless-shell zip: `content-length: 124403925`. The zip was not downloaded. Unpacked size on disk is `(?)` until an install. The ffmpeg zip HEAD after redirect did not show a `content-length` in the captured headers; size `(?)`.

**Libraries.** `node node_modules/playwright/cli.js install-deps --dry-run chromium` printed `All system dependencies are installed.` The list itself is in the same bundle under host platform `ubuntu24.04-x64` (this host is Ubuntu 24.04, so that key is the one Playwright selects; see the platform function which returns `ubuntu24.04` when the version is 24.04). Chromium packages:

`libasound2t64 libatk-bridge2.0-0t64 libatk1.0-0t64 libatspi2.0-0t64 libcairo2 libcups2t64 libdbus-1-3 libdrm2 libgbm1 libglib2.0-0t64 libnspr4 libnss3 libpango-1.0-0 libx11-6 libxcb1 libxcomposite1 libxdamage1 libxext6 libxfixes3 libxkbcommon0 libxrandr2`

Tool packages in that same object (fonts and Xvfb, not Chromium .so packages): `xvfb fonts-noto-color-emoji fonts-unifont libfontconfig1 libfreetype6 xfonts-cyrillic xfonts-scalable fonts-liberation fonts-ipafont-gothic fonts-wqy-zenhei fonts-tlwg-loma-otf fonts-freefont-ttf`.

`dpkg-query -W` on every package in both lists returned `install ok installed`. `ldconfig -p` resolves `libnss3.so`, `libnspr4.so`, `libgbm.so.1`, `libatk-1.0.so.0`, `libasound.so.2`, and `libxkbcommon.so.0` under `/lib/x86_64-linux-gnu/`. **None of the listed Chromium library packages are missing.** Firefox and WebKit dependency arrays were not checked package-by-package; this note is Chromium only.

## 3. Sandbox in LXC

`systemd-detect-virt` prints `lxc`. `/run/systemd/container` contains `lxc`. PID 1 is `systemd` (`ps -p 1`). `/proc/1/uid_map` is `0 100000 65536` (container root is host uid 100000: an unprivileged container). `cat /proc/1/environ` was not read.

| Check | Value | Meaning |
|---|---|---|
| `/proc/self/status` and `/proc/1/status` `NoNewPrivs` | `0` | `proc_pid_status(5)`: the `no_new_privs` bit (`prctl(2)` `PR_SET_NO_NEW_PRIVS`). `0` means execve can still honor setuid and file capabilities. It does not force `--no-sandbox`. |
| `/proc/self/status` and `/proc/1/status` `Seccomp` | `2` | `proc_pid_status(5)`: `2` is `SECCOMP_MODE_FILTER`. PID 1 has it too, with `Seccomp_filters: 1`, so the filter is the container's, inherited, not something added only around this shell. |
| `/proc/sys/kernel/unprivileged_userns_clone` | `1` (file present) | Unprivileged user namespaces are switched on. Confirmed in practice: `unshare --user --map-root-user id` printed `uid=0(root) gid=0(root) groups=0(root)` and exited 0. `user_namespaces(7)`: since Linux 3.8 an unprivileged process may create a user namespace, and other namespaces can then be created with `CAP_SYS_ADMIN` in that namespace. |
| `/proc/sys/kernel/apparmor_restrict_unprivileged_userns` | `0` | Ubuntu documents `1` as turning the restriction on and `0` as turning it off (`https://ubuntu.com/blog/ubuntu-23-10-restricted-unprivileged-user-namespaces`). AppArmor is enabled (`/sys/module/apparmor/parameters/enabled` is `Y`) but this restriction is off. |
| `/proc/sys/user/max_user_namespaces` | `2147483647` | Nesting is not exhausted. |
| `/proc/sys/kernel/yama/ptrace_scope` | `1` | `ptrace(2)`: `1` is "restricted ptrace", the default. A tracer must be the target's ancestor or hold `CAP_SYS_PTRACE`. |
| `unshare --mount /bin/true` | `Operation not permitted` | This user cannot make a mount namespace directly. |
| `unshare --user --map-root-user --mount /bin/true` | exit 0 | A mount namespace works inside a user namespace. |

**What that means for `--no-sandbox`.** Chromium's user-namespace sandbox needs an unprivileged user namespace. Those sysctls and the `unshare --user` test say the kernel allows that for `fhsbuild`. `NoNewPrivs=0` does not block it. `ptrace_scope=1` is the Ubuntu default and is not, by itself, a reason to pass `--no-sandbox`. The existing seccomp filter (mode 2, one filter on PID 1) might still reject a syscall Chromium's sandbox needs. The filter rules were not dumped. Whether a real Chromium stays up with sandboxing on is `(?)`. Confirm by launching once with `--sandbox` and reading the log. Playwright rewrites a failure that mentions `No usable sandbox!` or `crbug.com/357670` or `crbug.com/638180` into `Chromium sandboxing failed!` and tells you to configure the environment or set `chromiumSandbox: false` (same bundle, `doRewriteStartupLog`).

**This Playwright build turns the sandbox off unless asked.** In Chromium `_innerDefaultArgs` in the same bundle:

```text
if (options.chromiumSandbox !== true)
  chromeArguments.push("--no-sandbox");
```

`configFromCLIOptions` sets `launchOptions.chromiumSandbox` only when `cliOptions.sandbox !== undefined`. Omitting both flags leaves it unset, which is not `true`, so the launched Chromium gets `--no-sandbox`. `--sandbox` is what turns the sandbox on. `--no-sandbox` matches the default Chrome argument. The help line for `--sandbox` ("enable the sandbox for all process types that are normally not sandboxed") matches this code. A browser was not launched, so this is source plus the CLI parse, not a process listing.

## 4. Owner viewer

`lsb_release -a`: Ubuntu 24.04.4 LTS, codename noble.

`apt-cache policy` / `apt-cache show` (Installed-Size is the dpkg field, in KB; Size is the .deb in bytes):

| Package | Candidate | Installed? | Installed-Size | .deb Size |
|---|---|---|---|---|
| xvfb | 2:21.1.12-1ubuntu1.6 | yes (`ii`) | 2141 | 876922 |
| x11vnc | 0.9.16-10 | no | 2107 | 1017502 |
| novnc | 1:1.3.0-2 | no | 998 | 247568 |
| websockify | 0.10.0+dfsg1-5build2 | no | 85 | 24270 |
| python3-websockify | 0.10.0+dfsg1-5build2 (main) | no | 173 | 42208 |
| python3-novnc | 1:1.3.0-2 | no | 48 | 12826 |

`novnc` Depends: `adduser, nodejs, net-tools, python3-novnc, python3-numpy, websockify`. `websockify` Depends includes `python3-websockify`. File list for noble `novnc` (`https://packages.ubuntu.com/noble/all/novnc/filelist`) includes `/usr/share/novnc/vnc.html` and `/usr/share/novnc/utils/novnc_proxy`. Those files are not on disk until the package is installed.

**Bind to 127.0.0.1.** Ubuntu noble man page `x11vnc(1)` (`https://manpages.ubuntu.com/manpages/noble/man1/x11vnc.1.html`), option text:

- `-localhost` is "Basically the same as `-allow 127.0.0.1`" and "implies `-listen localhost`". With IPv6 it also implies `::1`.
- `-listen ipaddr`: listen only on that interface. `'-listen localhost'` works.
- The same page says this binary was built with `-6` (IPv6 listen) enabled by default, so without `-localhost` / `-listen localhost` it listens beyond loopback.

Password from a file, same man page:

- `-passwdfile filename`: "Specify the LibVNCServer password via the first line of the file filename" (so it is not on the command line).
- `-rfbauth passwd-file`: obscured password file created by `x11vnc -storepasswd pass file`.

`websockify(1)` on the same site, package version matching the candidate (`0.10.0+dfsg1-5build2`):

```text
websockify [options] [source_addr:]source_port target_addr:target_port
--web=DIR    run webserver on same port. Serve files from DIR.
```

Loopback-only form: `websockify --web=/usr/share/novnc 127.0.0.1:6080 127.0.0.1:5900`.

Upstream noVNC v1.3.0 `utils/novnc_proxy` (the version number in the noble package `1:1.3.0-2`; script fetched from `https://raw.githubusercontent.com/novnc/noVNC/v1.3.0/utils/novnc_proxy`, package itself not installed) only accepts `--listen PORT` and execs websockify with that port and no address. That listens on all interfaces. The Debian-patched script inside the .deb was not unpacked, so a difference from upstream is `(?)`. Call `websockify` with `127.0.0.1:port` rather than `novnc_proxy` if the bind address matters.

Installed `Xvfb -help` lists `-listen string` and `-nolisten string`. The local `Xvfb` man page did not state whether TCP is on by default, and Xvfb was not started. Default listen sockets are `(?)`.

**Lighter alternatives.**

- Chromium remote debugging (`--cdp-endpoint` exists on this MCP) plus a DevTools tab. Fewer packages, and nothing new to apt-install. Trade-off: it is not a normal mouse-driven picture of the browser, which is what the owner needs in order to sign in. A second CDP client can drive the same browser. Chrome's DevTools notes for Chrome 63 (`https://developer.chrome.com/blog/new-in-devtools-63`, section "Multi-client remote debugging support") say multiple remote debugging clients work by default: two WebSocket protocol clients can connect to the same tab at the same time, and a protocol client can run beside DevTools. Not tried here.
- SSH X11 forwarding of the headed Chrome window. No VNC packages. Trade-off: the owner needs an X server on the PC, and they do not "open a web page" as the spec requires. Not tried here.
- `websockify --run-once` (same man page: "handle a single WebSocket connection and exit") limits the viewer to one connection, then the proxy exits. Trade-off: the owner must reconnect by restarting the proxy; it does not stop a second MCP client.

## 5. MCP registration

**Claude Code.** `claude --version` is `2.1.296 (Claude Code)`. `claude mcp add --help` includes `-s, --scope <scope>` with values `local`, `user`, or `project` (default `local`) and `-t, --transport <transport>` with values `stdio`, `sse`, `http`. The user-scope HTTP form, also in the Claude Code docs (`https://code.claude.com/docs/en/mcp`, "User scope" section):

```text
claude mcp add --transport http --scope user <name> <url>
```

The docs example is `claude mcp add --transport http hubspot --scope user https://mcp.hubspot.com/anthropic`. User-scoped servers are stored in `~/.claude.json`. For this browser the URL matching the README is `http://127.0.0.1:8931/mcp` (streamable HTTP). The same docs page also has `claude mcp add --transport sse <name> <url>`. SSE on this server is `http://127.0.0.1:<port>/sse` (section 1). Docs say JSON `type` accepts `streamable-http` as an alias for `http`. This research did not run `claude mcp add` (that would write config).

**cursor-agent.** `cursor-agent --version` is `2026.10.01-e373342`. `cursor-agent mcp --help` has `login`, `list`, `list-tools`, `enable`, `disable`. It has no `add` subcommand. `cursor-agent mcp list` printed: `No MCP servers configured (expected in .cursor/mcp.json or ~/.cursor/mcp.json)`.

Cursor's MCP docs (`https://cursor.com/docs/context/mcp`): project file `.cursor/mcp.json`, global file `~/.cursor/mcp.json`. Remote server shape shown there:

```json
{
  "mcpServers": {
    "server-name": {
      "url": "http://localhost:3000/mcp",
      "headers": { "API_KEY": "value" }
    }
  }
}
```

The same page says Cursor supports stdio, SSE ("URL to an SSE endpoint"), and streamable HTTP ("URL to an HTTP endpoint"). For a server shared by every project, use `~/.cursor/mcp.json` with `"url": "http://127.0.0.1:8931/mcp"`. Prefer `127.0.0.1` over `localhost` so it cannot resolve to another interface. This research did not write that file.

## 6. Locking

No Playwright MCP flag refuses a second client. `--help` has no single-client or max-client option. A search of the 0.0.83 bundle found no `singleClient`. `clientCount` only decides when the shared browser is closed, not whether a new session is accepted. `sseSessions` and `streamableSessions` are Maps with no maximum. Neither `--shared-browser-context` nor `--isolated` refuses a second client. The first shares one context; the second shares one browser and opens a new context per client (section 1).

Playwright's hidden `run-server` command has `--max-clients`, but that is the Playwright driver server, not the MCP CLI (`decorateMCPCommand` does not add it). Do not treat it as an MCP lock.

The profile lock in section 1 (`Browser is already in use for ...`) refuses a second browser on the same user-data directory. It is not an access-path control: the second MCP session is accepted, and the failure happens later, inside `createPersistentBrowser`. With `--shared-browser-context` or `--isolated` that lock is not the refusal path: the first reuses the browser from `sharedBrowserPromise`, and the second calls `createIsolatedBrowser` instead of `createPersistentBrowser`.

Two ways to refuse at the access path. Neither was built.

1. **A localhost reverse proxy that allows one MCP session.** Put it in front of `--host 127.0.0.1 --port <mcp>` and publish only the proxy port to Claude and cursor-agent. On a new session (`GET /sse`, or a streamable `POST` with no `mcp-session-id`), if a session is already open, return 409 and close the new one. Trade-off: a raw "one TCP connection" limit is wrong, because SSE is a long `GET` plus later `POST`s, and streamable HTTP uses a session header across requests. The proxy has to understand both. It is another process to run and bind to `127.0.0.1`. Clients see a hard refusal instead of a shared cursor fighting the same page.
2. **stdio plus an exclusive file lock, and do not publish the HTTP port.** Register the server as a stdio command (`claude mcp add` without `--transport http`, and cursor `command`/`args` instead of `url`) whose wrapper takes `flock` on a lock file and exits if the lock is held. Trade-off: this only works when each client spawns the process. If both configs point at an already-running HTTP port, the wrapper never runs and the lock does nothing. Each successful client also gets its own MCP process; you do not get `--shared-browser-context` across processes unless they attach to one browser some other way. `flock` releases when the process exits, including a crash. A stale PID file would not.

## 7. Running unprivileged

systemd 255 (`systemctl --version`: `systemd 255 (255.4-1ubuntu8.16)`) is PID 1 inside the container. `CapEff` of PID 1 is `000001ffffffffff`, which includes `CAP_SYS_ADMIN` (bit 21) inside the container's user namespace. That is not host root: uid_map still starts at host uid 100000.

Text only. No unit was installed and no service was started. Account `fhs-browser` is a name for this topology, not a user on this machine. One service cannot be Xvfb, x11vnc, websockify, and the MCP server. The runnable shape is four system units, one long-running process each. `Restart=on-failure` (`systemd.service(5)`) restarts a process that exits non-zero or dies on a signal other than SIGHUP, SIGINT, SIGTERM, or SIGPIPE. A stop or restart that systemd itself asked for does not restart the process. `PartOf=` (`systemd.unit(5)`) propagates stop and restart from the named unit to this one, so a restarted display takes the clients with it. `Requires=` pulls the named unit in. With `After=`, this unit does not start if that unit fails to activate. `Requires=` stops or restarts this unit when the named unit is explicitly stopped or restarted; it does not by itself stop this unit when the other process exits on its own (`systemd.unit(5)`). `BindsTo=` does: an unexpected exit of the named unit stops this one. `Wants=` on the upstream unit starts the downstream units when the upstream unit starts. `Before=` only orders that start. After `BindsTo=` has stopped them, the next upstream start pulls them in again through `Wants=`, including a start from `Restart=on-failure`.

`Xvfb(1)` on this host defaults to one screen, 1280x1024x24, when `-screen` is omitted. `-nolisten tcp` is still passed so the unit does not depend on the unconfirmed TCP default in section 4. Xvfb does not listen on `127.0.0.1`; it has no TCP listener. The installed `/usr/bin/Xvfb` contains the path `/tmp/.X11-unix` (`strings /usr/bin/Xvfb`). That is the directory this binary uses for the display socket. `PrivateTmp=yes` gives each unit its own `/tmp`, so the x11vnc and MCP units set `JoinsNamespaceOf=fhs-browser-xvfb.service` in `[Unit]`. `systemd-analyze verify` on a throwaway unit ignores that key in `[Service]` (`Unknown key name 'JoinsNamespaceOf' in section 'Service'`). `systemd.unit(5)` says the share applies only when `PrivateTmp=` is set on both the joiner and the unit it joins. `systemd.exec(5)` says `JoinsNamespaceOf=` does not share the rest of the mount namespace, so each unit still applies its own `ProtectSystem=`, `ProtectHome=`, and `ReadWritePaths=`. `PrivateNetwork=` is not set, so VNC and MCP stay on the host loopback.

`StateDirectory=fhs-browser` (`systemd.exec(5)`) creates `/var/lib/fhs-browser`, owned by `User=` and `Group=`, and bind-mounts it into the unit. The same option on all four units is the one state directory. It is not removed when a unit stops. `ReadWritePaths=/var/lib/fhs-browser` is still set, as in the hardening below.

The VNC password file `/var/lib/fhs-browser/vnc-pass` and the pin directory `/opt/fhs-browser/node_modules/@playwright/mcp/` are not created here. Whether x11vnc exits when the password file is missing was not run `(?)`. Package file lists (section 4): `/usr/bin/Xvfb` (installed), `/usr/bin/x11vnc`, `/usr/bin/websockify` (from `python3-websockify`). `websockify(1)` stays in the foreground unless `-D` / `--daemon`. These units do not pass that flag, so `Type=simple` matches. The MCP command is the package bin `cli.js` under an absolute `/usr/bin/node`. The system manager's `$PATH` is the fixed value `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin` (`systemd.exec(5)`), which does not include Cursor's `node`. Section 1's failure was the login `PATH`, not this one. The MCP unit also sets `PATH=/usr/bin:/bin`.

`resolveCLIConfigForMCP` sets `launchOptions.headless` to true on Linux when `DISPLAY` is unset. The MCP unit sets `DISPLAY=:99` so the browser stays headed. `--headless` is not passed. `--shared-browser-context` is passed so two HTTP clients share one login (section 1).

```ini
# fhs-browser-xvfb.service
[Unit]
Description=Firehouse browser virtual display
After=local-fs.target
Requires=local-fs.target
Wants=fhs-browser-x11vnc.service fhs-browser-mcp.service
Before=fhs-browser-x11vnc.service fhs-browser-mcp.service

[Service]
Type=simple
User=fhs-browser
Group=fhs-browser
Environment=HOME=/var/lib/fhs-browser
WorkingDirectory=/var/lib/fhs-browser
StateDirectory=fhs-browser
ExecStart=/usr/bin/Xvfb :99 -nolisten tcp
Restart=on-failure
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
ReadWritePaths=/var/lib/fhs-browser

[Install]
WantedBy=multi-user.target
```

```ini
# fhs-browser-x11vnc.service
[Unit]
Description=Firehouse browser VNC
After=fhs-browser-xvfb.service
Requires=fhs-browser-xvfb.service
BindsTo=fhs-browser-xvfb.service
PartOf=fhs-browser-xvfb.service
JoinsNamespaceOf=fhs-browser-xvfb.service
Wants=fhs-browser-novnc.service
Before=fhs-browser-novnc.service

[Service]
Type=simple
User=fhs-browser
Group=fhs-browser
Environment=HOME=/var/lib/fhs-browser
Environment=DISPLAY=:99
WorkingDirectory=/var/lib/fhs-browser
StateDirectory=fhs-browser
ExecStart=/usr/bin/x11vnc -display :99 -listen 127.0.0.1 -no6 -rfbport 5900 -passwdfile /var/lib/fhs-browser/vnc-pass -forever -shared -norc
Restart=on-failure
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
ReadWritePaths=/var/lib/fhs-browser

[Install]
WantedBy=multi-user.target
```

`-listen 127.0.0.1` is the noble man page's `-listen ipaddr` form (re-read 2026-10-10). The same page says this binary listens on IPv6 by default and that `-no6` is what turns that off, so the unit passes both. `-norc` stops `$HOME/.x11vncrc` from adding flags. `-localhost` is "basically the same as `-allow 127.0.0.1`" and implies `-listen localhost`, which is a name rather than the address `127.0.0.1`.

```ini
# fhs-browser-novnc.service
[Unit]
Description=Firehouse browser noVNC
After=fhs-browser-x11vnc.service
Requires=fhs-browser-x11vnc.service
BindsTo=fhs-browser-x11vnc.service
PartOf=fhs-browser-x11vnc.service

[Service]
Type=simple
User=fhs-browser
Group=fhs-browser
Environment=HOME=/var/lib/fhs-browser
WorkingDirectory=/var/lib/fhs-browser
StateDirectory=fhs-browser
ExecStart=/usr/bin/websockify --web=/usr/share/novnc 127.0.0.1:6080 127.0.0.1:5900
Restart=on-failure
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
ReadWritePaths=/var/lib/fhs-browser

[Install]
WantedBy=multi-user.target
```

```ini
# fhs-browser-mcp.service
[Unit]
Description=Firehouse browser Playwright MCP
After=fhs-browser-xvfb.service network.target
Requires=fhs-browser-xvfb.service
BindsTo=fhs-browser-xvfb.service
PartOf=fhs-browser-xvfb.service
JoinsNamespaceOf=fhs-browser-xvfb.service

[Service]
Type=simple
User=fhs-browser
Group=fhs-browser
Environment=HOME=/var/lib/fhs-browser
Environment=DISPLAY=:99
Environment=PATH=/usr/bin:/bin
WorkingDirectory=/var/lib/fhs-browser
StateDirectory=fhs-browser
ExecStart=/usr/bin/node /opt/fhs-browser/node_modules/@playwright/mcp/cli.js --browser chromium --host 127.0.0.1 --port 8931 --user-data-dir /var/lib/fhs-browser/profile --sandbox --shared-browser-context
Restart=on-failure
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
ReadWritePaths=/var/lib/fhs-browser

[Install]
WantedBy=multi-user.target
```

`ProtectSystem=strict` mounts the tree read-only except `/dev`, `/proc`, and `/sys` (`systemd.exec(5)`). The profile, VNC password file, and browser cache must sit on `ReadWritePaths`. The Chromium binary and the pinned MCP tree under `/opt/fhs-browser` can stay on a read-only path. `ProtectHome=yes` makes `/home`, `/root`, and `/run/user` inaccessible. It does not hide `/srv` or `/var`. `fhsbuild`'s home is `/srv/fhs-build`, so `ProtectHome=yes` would not cover that home. Put the browser user's files under `/var/lib/fhs-browser` and do not point the profile at `/srv/fhs-build`.

`NoNewPrivileges=yes` sets `no_new_privs` (`systemd.exec(5)`, `prctl(2)`). A setuid `chrome-sandbox` helper cannot gain root under that bit. The namespace sandbox does not need setuid. The MCP unit asks for `--sandbox`. Whether Chromium's namespace sandbox still comes up when the unit has already set `NoNewPrivileges` was not launched `(?)`.

**What may not work in this LXC.** `systemd.exec(5)` says `ProtectSystem=` has no effect if the service manager runs in a container that makes file-system namespacing unavailable to its payload, and that `PrivateTmp=` can be impossible when mount namespaces are not available. The same page says those settings are not available to user services unless `PrivateUsers=true`, which needs `kernel.unprivileged_userns_clone` (this host's value is 1). Use system units, not user units. This user cannot `unshare --mount` directly, but PID 1 holds `CAP_SYS_ADMIN` in the container, and a user namespace plus a mount namespace did work for `fhsbuild`. Whether `ProtectSystem=strict`, `ProtectHome=yes`, and `PrivateTmp=yes` actually apply when systemd starts a unit here was not tested `(?)`. The same untested gap covers `JoinsNamespaceOf=` sharing that private `/tmp` among the Xvfb, x11vnc, and MCP units. If the private `/tmp` is not actually private, the display socket would be the host's `/tmp/.X11-unix` instead. Confirm with `systemd-run` (as root, which this user is not) or the first real start, and check `systemctl show` for the effective values. `systemd.exec(5)` also says the implementation may turn the setting off quietly, so a successful start is not proof the sandbox option took effect until `systemctl show` is read.

## 8. Sites

Public `GET` only (`curl -sI -L` and `curl -sL`, max 8 redirects, 25s). No form posted. Cookie values are omitted. A Chrome-like user agent was sent; the first short `Mozilla/5.0` agent got the same Toast result.

**Restaurant365.** `https://fhs4021089.restaurant365.com/` returned `HTTP/2 200`, `server: nginx`, `content-type: text/html`, final URL the same, about 10126 bytes, `<title>Restaurant365</title>`. No redirect. Hosts in the HTML that are real loads:

- `cdn.restaurant365.io` — script src for `vendors.min.js` and `app.min.js`
- `cdn.pendo.io` — inline script sets the Pendo agent src to `https://cdn.pendo.io/agent/static/<key>/pendo.js`
- `faro-collector-prod-us-east-3.grafana.net` — inline `faroCollectorUrl` (the collector path includes a token; the token is not copied here)
- same-origin `dest/faro.min.js`, `dest/analytics.min.js`, CSS, and `js/PDF/pdf.js`

`REACT_LOCALHOST` is set to `http://localhost:3000` in the inline config. That is a dev setting in the page, not a host this server contacts. An Application Insights key is also in the inline config; the ingest hostname is not in the HTML, so it is `(?)` (likely a `visualstudio.com` or `applicationinsights.azure.com` host inside the bundles). The Pendo key and the Faro token are in the public HTML; they are not repeated in this note.

**Toast.** `https://www.toasttab.com/` → `HTTP/2 301` `location: https://pos.toasttab.com` (`server: cloudflare`), then `HTTP/2 403` from `https://pos.toasttab.com`. Body title `Just a moment...`, only host in that body: `challenges.cloudflare.com`.

`https://www.toasttab.com/restaurants/admin/reports/home` → `HTTP/2 302` `location: https://www.toasttab.com/login?returnUrl=%2Frestaurants%2Fadmin%2Freports%2Fhome`, then `HTTP/2 403` with the same Cloudflare challenge. `https://www.toasttab.com/login` alone was also `403`.

Confirmed redirect domains: `pos.toasttab.com` and `www.toasttab.com`. `challenges.cloudflare.com` is the block page, not the login app. Domains the real Toast login HTML loads are `(?)` until a browser gets past Cloudflare. curl did not.

**ADP.** `https://online.adp.com/signin/v1/?APPID=RUN&productId=80e309c3-70c3-bae1-e053-3505430b5495` returned `HTTP/2 200`, final URL unchanged, `<title>Sign in</title>`, about 7956 bytes. `Set-Cookie` used `Domain=.adp.com` (cookie value omitted). Script src in the HTML:

- same-origin `/inc/js/lib/6a8r-1192.js`, `/ruxitagentjs_ICA7NVfghqrux_10341260622154106.js` (Dynatrace; `data-dtconfig` contains `domain=adp.com`), `/signin/v1/static/risk/...`, `/static/js/vendors...`, `/static/js/main...`, `/static/css/main...`
- `https://synerg.adp.com/config/synerg-config-5.48.0.js`

That config URL returned `200`, 29554 bytes. The only `https://` host in it is `canvas.waypoint.prod.us.caas.oneadp.com`. Further hosts pulled in by the same-origin bundles were not fetched `(?)`.

**Starting allow-list (confirmed loads and redirects only):**

- `fhs4021089.restaurant365.com`
- `cdn.restaurant365.io`
- `cdn.pendo.io`
- `faro-collector-prod-us-east-3.grafana.net`
- `www.toasttab.com`
- `pos.toasttab.com`
- `online.adp.com`
- `synerg.adp.com`
- `canvas.waypoint.prod.us.caas.oneadp.com`

`challenges.cloudflare.com` is what curl was shown instead of Toast. Treat it as a CDN Cloudflare may use, not as the login app. `--allowed-origins` will not hold this list as a boundary (section 1).

Namespace and identifier URIs found in page source (for example `www.w3.org` in `xmlns=`) are not hosts the page loads, so they stay off the allow-list.

**T6b re-check (2026-10-10).** `curl -sL --max-redirs 8 --max-time 25` with a Chrome user agent, then `grep -oE 'https?://[a-zA-Z0-9.-]+' | sort -u`, on `https://fhs4021089.restaurant365.com/`, `https://www.toasttab.com/`, and the ADP sign-in URL above. Every host in that output:

- `localhost` (`http://localhost` on R365) — the `REACT_LOCALHOST` dev setting above. Not a load. Off the allow-list.
- `cdn.pendo.io`, `cdn.restaurant365.io`, `faro-collector-prod-us-east-3.grafana.net` — on the allow-list.
- `challenges.cloudflare.com` (Toast) — the Cloudflare block page above. Off the allow-list.
- `synerg.adp.com` — on the allow-list.
- `www.w3.org` (`http://www.w3.org` on ADP) — the SVG namespace `xmlns="http://www.w3.org/2000/svg"`. Not a load. Off the allow-list.

## Summary: recommended stack, pinned versions, open `(?)` items

**Stack to plan from.** Four systemd system units, one process each, as a dedicated user (not root, not `fhsbuild`). `fhs-browser-xvfb.service`: `/usr/bin/Xvfb :99 -nolisten tcp` (no TCP listener). `fhs-browser-x11vnc.service` requires that unit and runs `x11vnc -listen 127.0.0.1 -no6` with a password file. `fhs-browser-novnc.service` requires x11vnc and runs `websockify --web=/usr/share/novnc` on `127.0.0.1:6080`, aimed at `127.0.0.1:5900`. `fhs-browser-mcp.service` requires the Xvfb unit, sets `DISPLAY=:99`, and runs Playwright MCP `@playwright/mcp@0.0.83` via `/usr/bin/node` and the pinned `cli.js` on `127.0.0.1` with an explicit `--user-data-dir` under `ReadWritePaths`, `--sandbox` (the build's default is `--no-sandbox`), and `--shared-browser-context` so two HTTP clients share one context and one login. x11vnc and the MCP unit join the Xvfb unit's private `/tmp`. Register Claude with `claude mcp add --transport http --scope user` and cursor-agent with `url` in `~/.cursor/mcp.json`. Refuse a second driver at a localhost proxy or with a stdio flock; the MCP server will not do it. Owner reaches noVNC through an SSH tunnel. Nothing listens except on loopback.

**Finding for the build plan.** The Cursor agent itself starts `@playwright/mcp` and `chrome-devtools-mcp` as child processes. Tester T11 in `/srv/fhs-build/reports/browser-research-01-test.md` saw `npm exec @playwright/mcp@latest` and `npm exec chrome-devtools-mcp@1.2.0`, parented by that session's `cursor-agent`.

**Pins.**

- `@playwright/mcp@0.0.83` (gitHead `f183dad4a52965583e3cc1d59b88cdc279e2e57d`)
- `playwright@1.64.0-alpha-1790635538000` and `playwright-core@1.64.0-alpha-1790635538000`
- Chrome for Testing `155.0.8059.12`, Playwright revision `1247`
- Ubuntu packages when installed: `xvfb` `2:21.1.12-1ubuntu1.6` (already installed), `x11vnc` `0.9.16-10`, `novnc` `1:1.3.0-2`, `websockify` `0.10.0+dfsg1-5build2`

**Open `(?)`.**

- Chromium with `--sandbox` was not launched. Kernel userns works; the LXC seccomp filter's effect on the sandbox is untested. Also untested: `--sandbox` combined with the unit's `NoNewPrivileges=yes`.
- Unpacked size of `chromium-1247` (zip is 198335306 bytes). FFmpeg zip size was not in the HEAD response.
- `ProtectSystem` / `ProtectHome` / `PrivateTmp` were not started under this container's systemd. The man page says a container can silently disable them.
- Xvfb's default listen mode (TCP or not) was not observed. The Xvfb unit passes `-nolisten tcp` so the plan does not depend on the default.
- Toast login asset domains. curl received Cloudflare `403` after the redirects to `pos.toasttab.com` and `/login`.
- ADP hosts beyond `synerg.adp.com` and `canvas.waypoint.prod.us.caas.oneadp.com`. R365 Application Insights ingest host is not in the HTML.
- Whether noble's packaged `novnc_proxy` differs from upstream v1.3.0, which listens on all interfaces. Use `websockify`'s `source_addr` either way.
- A live two-client MCP session was not opened. Sharing rules are from the 0.0.83 source.
