#!/bin/bash

# Natural Language Query Processor
nlp_search() {
    log "INFO" "Starting NLP-based command search"
    colorize "CYAN" "Natural Language Command Search"
    
    read -p "Enter your query: " query

    # Simple NLP processing using pattern matching
    local patterns=()
    local timeframe=""
    
    # Extract time-related keywords
    if [[ "$query" =~ (today|yesterday|last[[:space:]]week|this[[:space:]]month) ]]; then
        timeframe=$(echo "$query" | grep -Eo 'today|yesterday|last week|this month')
    fi

    # Extract command patterns
    if [[ "$query" =~ (sudo|git|docker|failed|error) ]]; then
        patterns+=($(echo "$query" | grep -Eo 'sudo|git|docker|failed|error'))
    fi

    # Build search command
    local search_cmd="cat $HISTORY_FILE"
    
    # Add timeframe filter if needed
    if [ -n "$timeframe" ]; then
        case "$timeframe" in
            today)      search_cmd+=" | awk -v start=\"$(date +%Y-%m-%d)\" '\$0 > start'" ;;
            yesterday)  search_cmd+=" | awk -v start=\"$(date -d yesterday +%Y-%m-%d)\" -v end=\"$(date +%Y-%m-%d)\" '\$0 >= start && \$0 < end'" ;;
            "last week") search_cmd+=" | awk -v start=\"$(date -d '7 days ago' +%Y-%m-%d)\" '\$0 >= start'" ;;
            "this month") search_cmd+=" | awk -v start=\"$(date +%Y-%m-01)\" '\$0 >= start'" ;;
        esac
    fi

    # Add pattern filters
    for pattern in "${patterns[@]}"; do
        search_cmd+=" | grep -i '$pattern'"
    done

    # Execute search
    eval "$search_cmd" | sort | uniq -c | sort -nr | awk '{
        printf "%s[%d] %s%s\n", "\033[0;32m", $1, $2, "\033[0m"
    }' || {
        log "ERROR" "NLP search failed"
        colorize "RED" "No matching commands found"
    }
    
    log "INFO" "NLP query completed: $query"
}