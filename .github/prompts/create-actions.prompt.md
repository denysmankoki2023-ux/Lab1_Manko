---
description: "Створює або оновлює кросплатформний GitHub Actions workflow, що запускає ci.bat або ci.sh."
agent: build-engineer
---

# Створення GitHub Actions

## Призначення

Виконати skill `github-actions` і налаштувати CI для Windows, Linux і macOS, використовуючи тільки локальні CI-скрипти.

## Передумови

- `/create-build` успішно завершено.
- У корені репозиторію існують `ci.bat` і `ci.sh`.
- Перед зміною прочитай наявний `.github/workflows/ci.yml`, якщо він є.

## Skill, що використовується

`github-actions` — створення й перевірка workflow GitHub Actions для трьох ОС без прямих Cargo-команд і секретів.

## Дії

1. Прочитай і виконай інструкції з `.github/skills/github-actions/SKILL.md`.
2. Передай параметри `project_name=hello`, `language=Rust`, `build=Cargo`, ОС `ubuntu-latest`, `windows-latest`, `macos-latest`, гілки `develop` і `master`.
3. Створи або онови `.github/workflows/ci.yml` за вимогами skill.
4. Перевір наявність тригерів, матриці, відповідних кроків скриптів і завантаження артефактів.
5. Передай результат і список змінених файлів наступному кроку.

## Очікувані файли

- `.github/workflows/ci.yml`

## Команди перевірки

```text
git status
git grep -n -I -E "ubuntu-latest|windows-latest|macos-latest" -- .github/workflows/ci.yml
git grep -n -I -E "ci\.bat|ci\.sh|cargo |secrets\." -- .github/workflows/ci.yml
```

Перевір вміст workflow, зокрема `push` і `pull_request` для `develop` та `master`, `workflow_dispatch`, одну job `build-test`, умову для Windows і Linux/macOS та upload-artifact. `git grep` із шаблоном заборонених рядків не має знаходити `cargo ` або `secrets.`; збіг очікуваних назв `ci.bat` і `ci.sh` у відповідному кроці є нормальним. Якщо немає збігів у `git grep`, його код завершення `1` для цього пошуку означає відсутність збігів, а не помилку Git.

## Повідомлення про помилку

Якщо скрипти-передумови відсутні, YAML некоректний або workflow порушує вимоги, повідом про конкретний файл і перевірку, що не пройшла. Не заявляй про успіх і не додавай прямі Cargo-команди чи секрети як обхід.

## Повторний запуск

Перед зміною прочитай workflow; оновлюй його на місці, не видаляй файли та не додавай повторних job, тригерів або кроків. Не змінюй `ci.bat` чи `ci.sh` у межах цієї команди.
