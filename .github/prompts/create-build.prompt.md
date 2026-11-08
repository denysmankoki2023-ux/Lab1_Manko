---
description: "Налаштовує збірку Cargo у build/, інтеграційний тест BasicAddition і локальні CI-скрипти."
agent: build-engineer
---

# Налаштування збірки та тестування

## Призначення

Виконати skill `build-and-test` для Rust/Cargo-проєкту, створивши тест `BasicAddition` і локальні скрипти CI.

## Передумови

- `/create-project` успішно завершено: існують Cargo-маніфест і `src/lib.rs` із `hello::add`.
- Перебувай у корені Git-репозиторію.
- Перед зміною прочитай кожен наявний цільовий файл.

## Skill, що використовується

`build-and-test` — налаштування Cargo `target-dir`, інтеграційного тесту та скриптів `ci.sh` і `ci.bat`, а також їх перевірка.

## Дії

1. Прочитай і виконай інструкції з `.github/skills/build-and-test/SKILL.md`.
2. Передай параметри `project_name=hello`, `language=Rust`, `build=Cargo`, `tests=cargo test`, `test_name=BasicAddition`, `build_dir=build/`.
3. У Windows запусти `.\ci.bat`; у Linux/macOS — `bash ./ci.sh`. Перевір код завершення, вивід тесту та файл у `dist/`.
4. Skill може виконати `git add --chmod=+x ci.sh` лише для зміни executable mode `ci.sh`; не додавай інші файли до індексу й не створюй commit.
5. Передай наступному кроку список змінених файлів і фактичний результат усіх перевірок.

## Очікувані файли

- `.cargo/config.toml`
- `tests/basic_addition.rs`
- `ci.sh`
- `ci.bat`
- `dist/hello` або `dist/hello.exe` як ігнорований результат запуску CI-скрипта.

## Команди перевірки

```text
cargo test
git check-ignore build/
git status
git ls-files --stage -- ci.sh
```

Додатково виконай платформну команду: Windows — `.\ci.bat`; Linux/macOS — `bash ./ci.sh`. У виводі тесту має бути `test BasicAddition ... ok`, а скрипт має завершитись із кодом `0` і створити відповідний виконуваний файл у `dist/`.

## Повідомлення про помилку

Якщо тест падає або не знайдено linker (зокрема MSVC у Windows), негайно зупинись і покажи команду та релевантний вивід. Запропонуй виправлення toolchain/linker, але не змінюй тест для приховування помилки й не переходь до наступного етапу, доки перевірку не буде успішно повторено.

## Повторний запуск

Дотримуйся правил skill `build-and-test`: перед зміною прочитай файли, оновлюй їх на місці, не видаляй і не очищай `build/` чи `dist/`, не дублюй команди. Дозволено оновити executable mode лише для `ci.sh`; не додавай інші файли до індексу.
