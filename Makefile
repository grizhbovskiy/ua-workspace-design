.DEFAULT_GOAL := help

OPENCODE_CONFIG := $(HOME)/.config/opencode/opencode.json
SUPERPOWERS_PLUGIN := superpowers@git+https://github.com/obra/superpowers.git

.PHONY: brew superpowers lokalise claude all help

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

brew: ## Install dependencies via Homebrew
	brew update --verbose
	brew bundle --verbose

superpowers: ## Install superpowers plugin for OpenCode
	@if [ ! -f "$(OPENCODE_CONFIG)" ]; then \
		echo "Error: OpenCode config not found at $(OPENCODE_CONFIG)"; \
		exit 1; \
	fi
	@if grep -q '"$(SUPERPOWERS_PLUGIN)"' "$(OPENCODE_CONFIG)"; then \
		echo "superpowers plugin already configured in $(OPENCODE_CONFIG)"; \
	else \
		node -e " \
			const fs = require('fs'); \
			const cfg = JSON.parse(fs.readFileSync('$(OPENCODE_CONFIG)', 'utf8')); \
			cfg.plugin = [...(cfg.plugin || []).filter(p => !/superpowers/.test(p)), '$(SUPERPOWERS_PLUGIN)']; \
			fs.writeFileSync('$(OPENCODE_CONFIG)', JSON.stringify(cfg, null, 2) + '\n'); \
		" && echo "superpowers plugin added to $(OPENCODE_CONFIG)"; \
	fi
	@echo "Restart OpenCode to activate superpowers."

lokalise: ## Install Lokalise MCP for OpenCode
	@if [ ! -f "$(OPENCODE_CONFIG)" ]; then \
		echo "Error: OpenCode config not found at $(OPENCODE_CONFIG)"; \
		exit 1; \
	fi
	@read -s -p "Enter Lokalise API key: " api_key; \
	echo; \
	if [ -z "$$api_key" ]; then \
		echo "Error: API key cannot be empty"; \
		exit 1; \
	fi; \
	node -e " \
		const fs = require('fs'); \
		const cfg = JSON.parse(fs.readFileSync('$(OPENCODE_CONFIG)', 'utf8')); \
		cfg.mcp = cfg.mcp || {}; \
		cfg.mcp.lokalise = { \
			command: 'npx', \
			args: ['-y', 'lokalise-mcp'], \
			env: { LOKALISE_API_KEY: '$$api_key' }, \
			enabled: true, \
			type: 'local' \
		}; \
		fs.writeFileSync('$(OPENCODE_CONFIG)', JSON.stringify(cfg, null, 2) + '\n'); \
	" && echo "Lokalise MCP added to $(OPENCODE_CONFIG)"; \
	echo "Restart OpenCode to activate Lokalise."

claude: ## Setup Claude Code config for this project
	@mkdir -p .claude
	@if [ ! -f ".claude/settings.json" ]; then \
		echo '{}' > .claude/settings.json; \
		echo "Created .claude/settings.json"; \
	else \
		echo ".claude/settings.json already exists"; \
	fi
	@echo "Claude Code config ready. Edit CLAUDE.md to add project context."

all: brew superpowers lokalise ## Full setup: brew + superpowers + lokalise
