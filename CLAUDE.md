# ua-workspace-design

Design-система команди RBUA.

## Команди

- `make all` — повне налаштування середовища (brew + superpowers + lokalise)
- `make brew` — встановлення залежностей через Homebrew
- `make superpowers` — встановлення superpowers плагіну для OpenCode
- `make lokalise` — підключення Lokalise MCP до OpenCode
- `make claude` — ініціалізація конфігурації Claude Code для проєкту

## Структура проєкту

- `Brewfile` — Homebrew залежності (OpenCode)
- `Makefile` — автоматизація налаштування середовища
- `CLAUDE.md` — контекст та правила для Claude Code
- `.claude/settings.json` — налаштування Claude Code

## Правила роботи

- Гілки для AI-змін: `claude/...`
- Мова комітів: англійська
- Мова коментарів у коді: англійська
