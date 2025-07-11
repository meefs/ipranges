#!/bin/bash


# https://docs.perplexity.ai/guides/bots

set -euo pipefail
set -x


# get from public ranges
download_and_parse_json() {
    curl --connect-timeout 60 --retry 3 --retry-delay 15 -s "${1}" \
    -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
    -H 'accept-language: en' \
    -H 'cache-control: no-cache' \
    -H 'pragma: no-cache' \
    -H 'priority: u=0, i' \
    -H 'sec-ch-ua: "Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "macOS"' \
    -H 'sec-fetch-dest: document' \
    -H 'sec-fetch-mode: navigate' \
    -H 'sec-fetch-site: none' \
    -H 'sec-fetch-user: ?1' \
    -H 'upgrade-insecure-requests: 1' \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36' \
    > /tmp/perplexity.json

    jq '.prefixes[] | [.ipv4Prefix][] | select(. != null)' -r /tmp/perplexity.json > /tmp/perplexity.txt

    # save ipv4
    grep -v ':' /tmp/perplexity.txt >> /tmp/perplexity-ipv4.txt

    # ipv6 not provided

    sleep 10
}

download_and_parse_json "https://www.perplexity.ai/perplexitybot.json"
download_and_parse_json "https://www.perplexity.ai/perplexity-user.json"


# sort & uniq
sort -V /tmp/perplexity-ipv4.txt | uniq > perplexity/ipv4.txt
