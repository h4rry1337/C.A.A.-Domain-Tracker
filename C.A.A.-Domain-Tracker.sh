#!/usr/bin/env bash
echo '
   _____    ___     ___        ______ ________  ___ ___ _____ _   _      ___________  ___  _____ _   _____________ 
  /  __ \  / _ \   / _ \       |  _  |  _  |  \/  |/ _ |_   _| \ | |    |_   _| ___ \/ _ \/  __ | | / |  ___| ___ \
  | /  \/ / /_\ \ / /_\ \______| | | | | | | .  . / /_\ \| | |  \| |______| | | |_/ / /_\ | /  \| |/ /| |__ | |_/ /
  | |     |  _  | |  _  |______| | | | | | | |\/| |  _  || | | . ` |______| | |    /|  _  | |   |    \|  __||    / 
  | \__/\_| | | |_| | | |      | |/ /\ \_/ | |  | | | | _| |_| |\  |      | | | |\ \| | | | \__/| |\  | |___| |\ \ 
   \____(_\_| |_(_\_| |_/      |___/  \___/\_|  |_\_| |_\___/\_| \_/      \_/ \_| \_\_| |_/\____\_| \_\____/\_| \_|
                        
              made by @h4rry1337'

# WhoisXMLAPI API Key
APIKEY="APIKEY"

# Loop through the domains in the wildcards file
while read -r domain; do
  # Format the URL for the HTTP request
  url="http://$domain"
  echo "Checking if $domain uses Cloudflare, Azure, or Amazon Services..."

  # Get the domain's headers using advanced configurations
  headers=$(curl -s -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" "$url" -I)
  echo "Headers received for $domain:"
  echo "$headers" # Display headers for debugging

  # Check if the headers indicate use of Cloudflare, Azure, or Amazon Services.
  if echo "$headers" | grep -qi -e "server: cloudflare" -e "cf-ray" -e "cf-cache-status" -e "x-ms-request-id" -e "x-ms-correlation-id" -e "x-ms-routing-name" -e "x-azure-ref" -e "x-amz-rid" -e "x-amzn-cdn-id" -e "X-Amz-Cf-Id" -e "X-Amz-Cf-Pop"; then
    echo "$domain uses Cloudflare, Azure, or Amazon Services."

    # Resolve the domain's NS servers
    dig NS +short "$domain" > dig.txt
    ns1=$(head -n 1 dig.txt)
    ns2=$(sed -n '2p' dig.txt)

    if [[ -z "$ns1" || -z "$ns2" ]]; then
      echo "NameServers not found for $domain."
      continue
    fi

    # Format the JSON payload
    payload=$(printf '{"apiKey":"%s","searchType":"current","mode":"purchase","advancedSearchTerms":[{"field":"NameServers","term":"%s"},{"field":"NameServers","term":"%s"}]}' "$APIKEY" "$ns1" "$ns2")

    # Send the request to the API
    curl -s https://reverse-whois.whoisxmlapi.com/api/v2 --data "$payload" -o whois.json

    # Extract the returned domains and save them
    cat whois.json | jq -r '.domainsList[]' | grep -i -E "^${domain%%.*}" >> cf_or_azr_amzn_domains.txt
    echo "$domain processed successfully."
  else
    echo "$domain is not using Cloudflare, Azure, or Amazon. Skipping..."
  fi

done < ./wildcards
