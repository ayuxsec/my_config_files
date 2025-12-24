base_url="http://localhost:11434/api/generate"
base_header="Content-Type: application/json"

# example: echo "Explain Turing Test." | ollama_run_prompt "deepseek-r1:8b" | glow .
ollama_run_prompt() {
  [[ "$1" == "help" || ( -z "$1" && -t 0 ) ]] && {
    printf '\nUsage: ollama_run_prompt "instruction text" [model]'
    printf '\n       cat <input_file> | ollama_run_prompt "instruction text" [model]'
    printf '\n\nExamples:'
    printf '\n  ollama_run_prompt "Explain the Turing Test" "deepseek-r1:8b"'
    printf '\n  cat example.py | ollama_run_prompt "Find vulnerabilities in this code"'
    printf '\n  git --no-pager diff --cached | ollama_run_prompt "Generate short commit message"'
    printf '\n  MY_OLLAMA_SAVE_DATASET=0 ollama_run_prompt "ping"\n\n'
    return 0
  }

  local instruction="$1"
  local model="${2:-"qwen2.5-coder:7b"}"
  local keep_alive=0

  [ ! -t 0 ] && local stdin_content="$(cat)"

  local full_prompt="${instruction}${instruction:+"${stdin_content:+$'\n\n'}"}${stdin_content}"

  local response
  response="$(
    jq -n \
      --arg keep_alive "$keep_alive" \
      --arg model "$model" \
      --arg prompt "$full_prompt" '
      {
        model: $model,
        prompt: $prompt,
        stream: false,
        keep_alive: ($keep_alive | tonumber)
      }' \
    | curl -s "$base_url" -H "$base_header" -d @- \
    | jq -r ".response"
  )"

  # Print response
  echo "$response" | glow . # todo: hardcoding glow for now

  # Append training record for future fine-tunning related task
  [[ "$MY_OLLAMA_SAVE_DATASET" == "0" ]] && { echo "[-] skipping save (set MY_OLLAMA_SAVE_DATASET=1 to enable)"; return 0; }
  [[ -z "$MY_OLLAMA_SAVE_DATASET" ]] && { read -p "Save Response for future fine-tunning? [y/N] " ok < /dev/tty; [[ "$ok" =~ ^[Yy](es)?$ ]] || return 0; }

  read -p "Enter score for model response (1/10): " score < /dev/tty && \
  ollama_save_dataset "${model}" "${full_prompt}" "${response}" "${score}"
}

ollama_save_dataset() {
  [ "$#" -ne 4 ] && { echo "Usage: ollama_save_dataset <model> <full_prompt> <response> <user_score>"; return 1; }

  local model="${1}"
  local full_prompt="${2}"
  local response="${3}"
  local score="${4}"
  local dataset="$HOME/ollama_datasets/instruction_logs.jsonl"
  mkdir -p "$(dirname "$dataset")"

  jq -cn --arg model "$model" \
    --arg prompt "$full_prompt" \
    --arg output "$response" \
    --arg score "$score" \
    --arg timestamp "$(date --iso-8601=seconds)" \
          '{
            model: $model,
            prompt: $prompt,
            output: $output,
            score: ( $score | tonumber ),
            timestamp: $timestamp
          }' >> "$dataset"

  echo "[+] Saved to $dataset" >&2
}
