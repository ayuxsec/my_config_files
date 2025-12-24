# my_config_files

A personal collection of Bash helpers, Conky configuration, and small utilities i use that make daily development, AI-prompting, and system monitoring a little easier.

> This README itself was generated using the helper: `cat projdump.txt | groq_run_prompt "complete README.md" "openai/gpt-oss-120b"`

All scripts are **stand-alone** and can be sourced individually or loaded automatically from `~/.bashrc`.

## Table of Contents

| Section                        | Description                                       |
| ------------------------------ | ------------------------------------------------- |
| [Installation](#installation)  | Clone the repo and load the scripts automatically |
| [ollama.sh](#ollamash)         | Helpers for the local **Ollama** inference server |
| [groq.sh](#groqsh)             | Helpers for the **Groq** API (hosted LLMs)        |
| [pentesting.sh](#pentestingsh) | Small network-recon / OSINT helpers               |
| [conky.conf](#conkyconf)       | A clean, semi-transparent Conky setup             |
| [settings.sh](#settingssh)     | Default toggles for dataset-saving                |
| [Contributing](#contributing)  | How to add new helpers                            |
| [License](#license)            | MIT – feel free to fork!                          |

## Installation

```bash
# 1️⃣ Clone (shallow – only latest commit)
git clone --depth 1 https://github.com/ayuxsec/my_config_files

# 2️⃣ Auto-source all *.sh files on login
echo 'for f in "$HOME"/my_config_files/*.sh; do
  [ -f "$f" ] && source "$f"
done' >> ~/.bashrc

# 3️⃣ Reload shell
exec $SHELL
```

> **Tip:**
> If you keep the repo elsewhere, replace `"$HOME"/my_config_files` with the correct path.
> You can also source a single file manually:
>
> ```bash
> source "$HOME/my_config_files/ollama.sh"
> ```

## ollama.sh

### What it does

* Sends prompts (optionally via piped STDIN) to a locally running **Ollama** model
* Prints the model’s response to stdout
* Optionally logs *prompt → response* pairs in JSONL format for fine-tuning

### Quick Install

```bash
source <(curl -fsSL https://raw.githubusercontent.com/ayuxsec/my_config_files/refs/heads/main/ollama.sh)
```

### Functions

| Function              | Synopsis                                                                                           | Description                                                                                              |
| --------------------- | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `ollama_run_prompt`   | `ollama_run_prompt "instruction" [model]`<br>`cat file \| ollama_run_prompt "instruction" [model]` | Sends prompt to Ollama. If `MY_OLLAMA_SAVE_DATASET=1`, you’ll be asked whether to store the interaction. |
| `ollama_save_dataset` | `ollama_save_dataset <model> <prompt> <response> <score>`                                          | Appends a JSON object to the dataset log.                                                                |

### Example Usage

```bash
# Default model
ollama_run_prompt "What is the difference between TCP and UDP?"

# Specific model
ollama_run_prompt "Write a Bash script that backs up /etc" "deepseek-r1:8b"

# Pipe input
cat my_program.c | ollama_run_prompt "Find security issues in the code"

# Disable dataset saving for one call
MY_OLLAMA_SAVE_DATASET=0 ollama_run_prompt "ping"
```

### Dataset Location

```text
~/ollama_datasets/instruction_logs.jsonl
```

Each line is a valid JSON object:

```json
{
  "model": "deepseek-r1:8b",
  "prompt": "...",
  "output": "...",
  "score": 8,
  "timestamp": "2025-12-24T14:33:12+00:00"
}
```

## groq.sh

### What it does

* Sends prompts to **Groq’s** hosted LLMs (OpenAI-compatible API)
* Prints responses and remaining rate-limit tokens
* Supports optional dataset logging

### Quick Install

```bash
source <(curl -fsSL https://raw.githubusercontent.com/ayuxsec/my_config_files/refs/heads/main/groq.sh)
```

> **Required:**
>
> ```bash
> export GROQ_API_KEY="gsk_XXXXXXXXXXXXXXXX"
> ```

### Functions

| Function            | Synopsis                                                | Description                                              |
| ------------------- | ------------------------------------------------------- | -------------------------------------------------------- |
| `groq_run_prompt`   | `groq_run_prompt "instruction" [model]`                 | Sends a prompt to Groq (default: `openai/gpt-oss-120b`). |
| `groq_list_models`  | `groq_list_models`                                      | Lists all available models.                              |
| `groq_save_dataset` | `groq_save_dataset <model> <prompt> <response> <score>` | Appends a JSON entry to the dataset log.                 |

### Example Usage

```bash
groq_run_prompt "Explain zero-knowledge proofs"

groq_run_prompt "Generate a Dockerfile for Flask" "llama-3.3-70b-versatile"

git diff --cached | groq_run_prompt "Write a concise commit message"

MY_GROQ_SAVE_DATASET=0 groq_run_prompt "ping"
```

### Dataset Location

```text
~/groq_datasets/instruction_logs.jsonl
```

## pentesting.sh

Small helpers useful during bug-bounty / red-team work.

### Functions

| Function   | Synopsis                  | Description                                  |
| ---------- | ------------------------- | -------------------------------------------- |
| `ipinfo`   | `ipinfo <ip_or_hostname>` | Query **ipinfo.io** and return JSON data.    |
| `kt_crawl` | `kt_crawl [options]`      | Wrapper around **Katana** for URL discovery. |

### `kt_crawl` Options

| Flag | Meaning          | Default          |
| ---- | ---------------- | ---------------- |
| `-i` | Input hosts file | `httpx.txt`      |
| `-o` | Output file      | `kt_crawled.txt` |
| `-t` | Katana threads   | `15`             |
| `-p` | HTTP parallelism | `5`              |
| `-d` | Crawl depth      | `6`              |
| `-m` | Max duration     | `15m`            |
| `-h` | Help             | —                |

#### Example

```bash
kt_crawl -i httpx.txt -o urls.txt -t 25 -p 10 -d 5 -m 30m
```

## conky.conf

A minimal dark-theme Conky configuration showing:

* System stats
* Top processes
* NVIDIA GPU metrics

### Usage

```bash
conky -c "$HOME/my_config_files/conky.conf"
```

### Customisation

* **Colors & fonts** → edit `font`, `color*`, `default_color`
* **Refresh rate** → `update_interval`
* **Position** → `alignment`, `gap_x`, `gap_y`

> For permanence:
>
> ```bash
> cp conky.conf ~/.config/conky/conky.conf
> ```


## settings.sh

Provides default dataset-saving toggles:

```bash
MY_OLLAMA_SAVE_DATASET=1
MY_GROQ_SAVE_DATASET=1
```

Override per command:

```bash
MY_OLLAMA_SAVE_DATASET=0 ollama_run_prompt "ping"
```

If unset, you’ll be prompted interactively.

## Contributing

1. Fork the repository
2. Create a branch: `git checkout -b feature/awesome-helper`
3. Add or modify scripts (POSIX-compatible Bash, `jq` for JSON)
4. Update `README.md`
5. Open a Pull Request

Contributions are welcome—especially AI wrappers, OSINT tools, or Conky tweaks.
