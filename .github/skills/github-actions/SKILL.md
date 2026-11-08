---
name: github-actions
description: "Створює та перевіряє GitHub Actions workflow для Rust CI на Linux, Windows і macOS; застосовуй для автоматизації перевірок у GitHub."
---

# GitHub Actions для кросплатформного Rust CI

## Коли застосовувати

- Коли потрібно налаштувати CI для Rust-проєкту в GitHub Actions.
- Під час виконання `/create-actions` або відповідного етапу `/init`.
- Коли треба перевірити, що CI запускає лише наявні платформні скрипти, а не дублює команди збірки у workflow.

## Вхідні дані

- Корінь репозиторію з підготовленими `ci.sh` і `ci.bat`.
- Параметри за замовчуванням: Rust, Cargo; CI-ОС `ubuntu-latest`, `windows-latest`, `macos-latest`.
- Наявний `.github/workflows/ci.yml`, якщо він уже існує.
- Очікувані гілки push і pull request: `develop` і `master`.

## Дії

1. Перевір, що `ci.sh` і `ci.bat` створені попереднім етапом. Прочитай наявний workflow перед його зміною.
2. Створи або онови `.github/workflows/ci.yml` із такими вимогами:
   - назва workflow — `CI`;
   - тригер `push` і `pull_request` обмежені гілками `develop` і `master`;
   - додай `workflow_dispatch`;
   - одна job `build-test`;
   - `strategy.fail-fast: false`;
   - `strategy.matrix.os`: `ubuntu-latest`, `windows-latest`, `macos-latest`;
   - `runs-on: ${{ matrix.os }}`;
   - крок `actions/checkout@v4`;
   - для Windows — крок із `if: runner.os == 'Windows'`, `shell: cmd`, який запускає тільки `ci.bat`;
   - для Linux/macOS — крок із `if: runner.os != 'Windows'`, `shell: bash`, який запускає `bash ./ci.sh`;
   - зрозумілі назви кроків, наприклад `Build and test (Windows)` та `Build and test (Linux/macOS)`;
   - після успішної збірки й тестів — `actions/upload-artifact@v4`, `name: hello-${{ matrix.os }}`, `path: dist/`.
3. Не додавай у workflow жодних команд `cargo` і не вбудовуй кроків, що дублюють збирання чи тестування; цим займаються лише `ci.bat` і `ci.sh`. Не додавай секретів, посилань на `secrets.` чи чутливих значень.
4. Перевір workflow на відповідність усім вимогам і передай результат та шлях файла наступному етапу.

## Результат (файли)

- `.github/workflows/ci.yml`

## Перевірка результату

- Переконайся, що workflow-файл існує і містить назву `CI`, події `push`, `pull_request`, `workflow_dispatch`, одну job `build-test`, `fail-fast: false` і всі три runner-и.
- Переконайся, що кроки запускають Windows `ci.bat` і Linux/macOS `bash ./ci.sh` з потрібними умовами та shell.
- Переконайся, що завантаження артефакту використовує `actions/upload-artifact@v4`, ім'я `hello-${{ matrix.os }}` і шлях `dist/`.
- Переконайся, що YAML не містить `cargo `, команд збірки/тестування напряму, або `secrets.`.
- Переконайся, що в workflow немає сторонніх змін, не передбачених завданням. Якщо доступний YAML-парсер у наявному середовищі, перевір синтаксис ним; не встановлюй залежностей лише заради цієї перевірки.

## Ідемпотентність

- Перед редагуванням прочитай наявний workflow і збережи потрібні налаштування, які не суперечать вимогам.
- Змінюй `.github/workflows/ci.yml` на місці; не видаляй workflow-файли чи каталоги.
- Повторне застосування не має додавати дубльовані job-ів, тригерів чи кроків.
- Не змінюй CI-скрипти в межах цього skill; для їхніх змін використовується `build-and-test`.

## Приклад входу

```text
project_name=hello
language=Rust
build=Cargo
workflow_path=.github/workflows/ci.yml
ci_scripts=ci.bat, ci.sh
ci_os=ubuntu-latest, windows-latest, macos-latest
```

## Очікуваний результат

Один workflow запускається для push і pull request у `develop` та `master`, а також вручну; матриця паралельно перевіряє Windows, Linux і macOS, кожен runner користується відповідним CI-скриптом і публікує `dist/` як артефакт.

## Типовий сценарій помилки та дії при ньому

Якщо на Linux/macOS крок завершується `Permission denied` під час запуску `ci.sh`, зупинись і повідом про невдалий крок та вивід. Запропонуй виправити executable mode через `git add --chmod=+x ci.sh` (лише для цього файла, без автоматичного коміту) і викликати скрипт як `bash ./ci.sh`. Не додавай у workflow прямі Cargo-команди як обхід і не позначай CI успішним, доки скрипт не відпрацює успішно.
