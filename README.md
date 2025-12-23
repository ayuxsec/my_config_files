# my_config_files

## ollama.sh

Minimal Bash helpers I use for interacting with [Ollama](https://ollama.com/) and logging prompt/response pairs for later fine-tuning or analysis.

### Functions

#### `ollama_run_prompt`

Send a prompt to a local Ollama model.
Accepts optional STDIN (code, diffs, files) which is appended after the instruction.

```console
$ ollama_run_prompt

Usage:
  ollama_run_prompt "instruction text" [model]
  cat <input_file> | ollama_run_prompt "instruction text" [model]

Examples:
  ollama_run_prompt "Explain the Turing Test" deepseek-r1:8b
  cat example.py | ollama_run_prompt "Find vulnerabilities in this code"
  git --no-pager diff --cached | ollama_run_prompt "Generate short commit message"
```

#### `ollama_save_dataset`

Append a training record to a local JSONL dataset, intended for future fine-tuning / evaluation workflows.

```console
$ ollama_save_dataset

Usage: ollama_save_dataset <model> <full_prompt> <response> <user_score>
```

* Stores at:

```console
~/ollama_datasets/instruction_logs.jsonl
```

### External API → dataset logging

Useful when the response does **not** come from Ollama but should still be logged.

```console
response="$(curl -s "https://openapi.com/...&prompt=${prompt}")"
ollama_save_dataset "gpt-oss:20b" "${prompt}" "${response}" "8"
```
