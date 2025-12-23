base_url="http://localhost:11434/api/generate"
base_header="Content-Type: application/json"

# example: echo "Explain Turing Test." | ollama_run_prompt "deepseek-r1:8b" | glow .
ollama_run_prompt ()
{
    [[ "$1" == "help" || -t 0 ]] && { 
        echo 'Usage: cat <input_file> | ollama_run_prompt "instruction text" [model]'; # e.g.: git --no-pager diff --cached | ollama_run_prompt "generate commit message"
        return 0
    };

    local instruction="$1"
    local model="${2:-${1:-qwen2.5-coder:7b}}" # use 1st arg if 2nd missing or use qwen2.5-coder:7b as defualt model if both missing
    local keep_alive=0 # close immediately once prompt complete

    jq -n \
      --arg keep_alive "$keep_alive" \
      --arg model "$model" \
      --arg instruction "$instruction" \
      --rawfile stdin /dev/stdin '
      {
        model: $model,
        prompt: ($instruction + "\n\n" + $stdin),
        stream: false,
        keep_alive: $keep_alive
      }' \
    | curl -s "$base_url" -H "$base_header" -d @- \
    | jq -r ".response"
}
