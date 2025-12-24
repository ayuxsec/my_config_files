#!/bin/bash
base_url="https://api.groq.com/openai/v1/chat/completions"
base_header="Content-Type: application/json"
authorization_header="Authorization: Bearer ${GROQ_API_KEY}" 

groq_run_prompt() {
    [[ $1 == "help" || ( -z "$1" && -t 0 ) ]] && {
        printf '\nUsage: groq_run_prompt "instruction text" [model]'
        printf '\n       cat <input_file> | groq_run_prompt "instruction text" [model]'
        printf '\n\nExamples:'
        printf '\n  groq_run_prompt "Explain the Turing Test" "deepseek-r1:8b"'
        printf '\n  cat example.py | groq_run_prompt "Find vulnerabilities in this code"'
        printf '\n  git --no-pager diff --cached | groq_run_prompt "Generate short commit message"'
        printf '\n  MY_groq_SAVE_DATASET=0 groq_run_prompt "ping"\n\n'
    return 0
    }
    local instruction="$1"
    local model="${2:-"openai/gpt-oss-120b"}"
    # echo $GROQ_API_KEY

    [ ! -t 0 ] && local stdin_content="$(cat)"
    local full_prompt="${instruction}${instruction:+"${stdin_content:+$'\n\n'}"}${stdin_content}"
    
    response=$(
        jq -n \
        --arg model "$model" \
        --arg prompt "$full_prompt" '
        {
         "messages": [
           {
             "role": "user",
             "content": $prompt,
           }
         ],
         "model": $model,
         "temperature": 1,
         "max_completion_tokens": 8192,
         "top_p": 1,
         "stream": false,
         "reasoning_effort": "medium",
         "stop": null
       }' | curl -s "$base_url" -H "$base_header" -H "$authorization_header" -d @- | \
       jq -r '.choices[0].message.content'
    )
    echo $response

    # Append training record for future fine-tunning related task
    [[ "$MY_GROQ_SAVE_DATASET" == "0" ]] && { echo "[-] skipping save (set MY_GROQ_SAVE_DATASET=1 to enable)"; return 0; }
    [[ -z "$MY_GROQ_SAVE_DATASET" ]] && { read -p "Save Response for future fine-tunning? [y/N] " ok < /dev/tty; [[ "$ok" =~ ^[Yy](es)?$ ]] || return 0; }

    read -p "Enter score for model response (1/10): " score < /dev/tty && \
    groq_save_dataset "${model}" "${full_prompt}" "${response}" "${score}"
}

groq_save_dataset() {
  [ "$#" -ne 4 ] && { echo "Usage: groq_save_dataset <model> <full_prompt> <response> <user_score>"; return 1; }

  local model="${1}"
  local full_prompt="${2}"
  local response="${3}"
  local score="${4}"
  local dataset="$HOME/groq_datasets/instruction_logs.jsonl"
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