################################################
# This Script is writed by TeRRaNoVA           #
# 2023 v.1x Beta   OpenAI chat for Eggdrop     #
#                                              #
#    !!!!USE THIS AT YOUR OWN RISK!!!!         #
#                                              #
# Changelog:                                   #
# 202x-0X-XX - BETA v.1x                       #
################################################

package require http
package require json

set api_key "<YOUR API KEY IN HERE>"
# egg: https://api.openai.com/v1/engines/davinci-codex/completions
set endpoint "<YOUR END POINT IN HERE>"

bind pub -|- openai_response
bind msg -|- openai_response

proc openai_response {nick host hand chan text} {
    if {[string match "!openai*" $text]} {
        set prompt [string trim [string range $text 8 end]]
        set payload [http::formatQuery prompt $prompt api_key $api_key]
        set headers [list Content-Type "application/json"]
        set query_result [http::data -headers $headers -body $payload $endpoint]
        set json_result [json::json2dict $query_result]
        set response [dict get $json_result "choices" 0 "text"]
        if {$response == ""} {
            puthelp "PRIVMSG $chan :Sorry, I couldn't understand your question"
        } else {
            puthelp "PRIVMSG $chan :$response"
        }
    }
}
