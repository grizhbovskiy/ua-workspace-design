# rbua-design-team

## Налаштування середовища

1. Встанови Homebrew:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Встанови залежності та налаштуй інструменти:
   ```bash
   make all
   ```
   > Потрібен API ключ Lokalise: https://app.lokalise.com/profile#apitokens

3. Налаштуй OpenCode:
   > Гайд: https://wiki.rbinternational.com/confluence/pages/viewpage.action?pageId=5334903423

4. Встанови superpowers для OpenCode:
   ```bash
   make superpowers
   ```

5. Встанови Skill Creator Code

6. Встанови Claude Code:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

7. Ініціалізуй конфігурацію Claude Code для проєкту:
   ```bash
   make claude
   ```
   > Після цього відредагуй `CLAUDE.md` — додай контекст свого проєкту.

## Доступні команди

```bash
make help       # показати всі команди
make all        # повне налаштування (brew + superpowers + lokalise)
make brew       # встановити Homebrew залежності
make superpowers # встановити superpowers для OpenCode
make lokalise   # підключити Lokalise MCP до OpenCode
make claude     # ініціалізувати конфіг Claude Code
```
