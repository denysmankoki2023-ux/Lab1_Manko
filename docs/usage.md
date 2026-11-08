# Інструкція з використання

## Передумови

- Windows 11, VS Code і GitHub Copilot із доступом до Copilot Chat.
- Git, доступний у терміналі та `PATH`.
- Rust toolchain, встановлений через `rustup` (зокрема `cargo` і `rustc`).
- На Windows — Visual Studio C++ Build Tools з MSVC C++ workload і Windows SDK для компонування Rust-програми.
- Bash для запуску `bash ./ci.sh` у Linux/macOS.

## Запуск агента

1. Відкрий репозиторій у VS Code.
2. Відкрий **Copilot Chat** і вибери режим **Agent**.
3. Вибери агента **build-engineer**.
4. Введи `/init` і підтвердь потрібні дії агента.

Команда `/init` послідовно виконує `/git-init`, `/create-project`, `/create-build`, `/create-actions`, `/check` і зупиняється на першій помилці. Також їх можна запускати окремо в цьому порядку:

```text
/git-init
/create-project
/create-build
/create-actions
/check
```

Згенеровані файли проєкту, CI-скрипти та workflow з'являться після виконання відповідних команд.

## Локальна перевірка

Запускай скрипт, відповідний операційній системі:

```powershell
.\ci.bat
```

```bash
bash ./ci.sh
```

Додаткові команди для запуску програми, тестів і перевірки ігнорування build-каталогу:

```text
cargo run --bin hello
cargo test
git check-ignore build/
```

Успішний тест має містити `test BasicAddition ... ok`. Скрипт збирає release-версію, запускає її та копіює результат у `dist/`.

## Розташування результатів

- Cargo build-артефакти: `build/`; release-виконуваний файл розташований у `build/release/` (`hello.exe` у Windows).
- Результат локального CI-скрипта: `dist/hello` або `dist/hello.exe`.

Каталоги `build/`, `target/` і `dist/` ігноруються Git.

## Демонстрація помилкової перевірки

1. Відкрий `tests/basic_addition.rs` і тимчасово зміни очікуване значення в одній з перевірок на завідомо неправильне.
2. Запусти `.\ci.bat` у Windows або `/check` у Copilot Chat. Тест має завершитися помилкою; `/check` має показати відповідний `FAIL` і підсумок `CHECK FAILED`.
3. Поверни правильне очікуване значення у `tests/basic_addition.rs`.
4. Повтори перевірку й переконайся, що тест знову проходить.

Не залишай навмисно зламану перевірку у фінальному стані проєкту.

## GitHub Actions

Workflow `.github/workflows/ci.yml` запускається для push і pull request у гілки `develop` та `master`, а також вручну через `workflow_dispatch`. Матриця виконує CI на `ubuntu-latest`, `windows-latest` і `macos-latest`; workflow викликає відповідні `ci.sh` або `ci.bat`, а після успіху завантажує вміст `dist/` як артефакт.

Результати виконань доступні у вкладці **Actions** відповідного workflow run. У його секції **Artifacts** шукай артефакт для кожної ОС з назвою `hello-<os>`, наприклад `hello-ubuntu-latest`.
