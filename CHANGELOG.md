# Changelog

## [1.1.0](https://github.com/BoutLabs/tclaude/compare/v1.0.0...v1.1.0) (2026-07-12)


### Features

* add tgrok and tcodex alongside tclaude ([#30](https://github.com/BoutLabs/tclaude/issues/30)) ([69b1239](https://github.com/BoutLabs/tclaude/commit/69b1239b3a80dde25c94b719d043609ab8ebb046))

## 1.0.0 (2026-02-21)


### Features

* add --list flag to tclaude ([#12](https://github.com/BoutLabs/tclaude/issues/12)) ([95efb93](https://github.com/BoutLabs/tclaude/commit/95efb93385baff754e7e9cfa339eb76dd76c03a1))
* add automated SemVer releases with release-please ([#18](https://github.com/BoutLabs/tclaude/issues/18)) ([7b81657](https://github.com/BoutLabs/tclaude/commit/7b81657c01dab25be97bed3f93fcadac2d2a36b1))
* add install script ([e47e709](https://github.com/BoutLabs/tclaude/commit/e47e7093a53abded062d5588bb9135b72caedbe7))
* add tclaude scripts for tmux session management ([2e32ea2](https://github.com/BoutLabs/tclaude/commit/2e32ea2de0c75973cb2c63009e09298a7354ad5b))
* add tclaude-all for cross-session commands ([#14](https://github.com/BoutLabs/tclaude/issues/14)) ([5f6fe85](https://github.com/BoutLabs/tclaude/commit/5f6fe85f2ca9274094e7becf781c671442f815a2))
* add tclaude-kill for session cleanup ([#11](https://github.com/BoutLabs/tclaude/issues/11)) ([c31e794](https://github.com/BoutLabs/tclaude/commit/c31e794e42b94a6e9979a00a6af3922fdaf3df4f))
* add telegram notification hook ([c3678a8](https://github.com/BoutLabs/tclaude/commit/c3678a87dd289e7a0e1ecb2307126e24cd04bbba))
* add uninstall script ([#15](https://github.com/BoutLabs/tclaude/issues/15)) ([00d5a58](https://github.com/BoutLabs/tclaude/commit/00d5a58e95411acfb42318acb6217124addba70b))
* add zsh completions ([#17](https://github.com/BoutLabs/tclaude/issues/17)) ([e36c077](https://github.com/BoutLabs/tclaude/commit/e36c077bddb95bc8cf97179c0d966df364d334b3))
* auto-log session output ([#16](https://github.com/BoutLabs/tclaude/issues/16)) ([fe50ded](https://github.com/BoutLabs/tclaude/commit/fe50ded89838844053f16591dfbe17635d764f0a))
* auto-name sessions from git remote ([#13](https://github.com/BoutLabs/tclaude/issues/13)) ([9466202](https://github.com/BoutLabs/tclaude/commit/946620267cad7c56c118193ec101b75c96b9dee6))
* set terminal tab title to repo name ([#27](https://github.com/BoutLabs/tclaude/issues/27)) ([4e16b71](https://github.com/BoutLabs/tclaude/commit/4e16b719fdb19b272086eeca5113bdb8507868e4))


### Bug Fixes

* correct sed regex for stripping .git from remote URL ([#25](https://github.com/BoutLabs/tclaude/issues/25)) ([04df41f](https://github.com/BoutLabs/tclaude/commit/04df41fd8729af53d5756925cda07bba8b31857a))
* remove = prefix from tmux pane-targeting commands ([#26](https://github.com/BoutLabs/tclaude/issues/26)) ([a43655e](https://github.com/BoutLabs/tclaude/commit/a43655efdce95e5edf9d62e59c943f0ac4bf64a5))
