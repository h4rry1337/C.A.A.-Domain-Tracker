# C.A.A.-Domain-Tracker
During my attempts to enhance my reconnaissance process, I read an article written by **@c3l3si4n**, in which quick techniques are presented to discover all domains associated with a name server. In the example described by Celesian, the process of "dumping" domains from a **Top Level Domain (TLD)** of a web application using **Cloudflare** is demonstrated. It involves acquiring its name server (NS) using `dig` to capture the Name Servers (NS) and then querying the **Reverse WHOIS API** to gather more information about the NS.

This approach enables the exploration and identification of domains that share the same name server, significantly expanding reconnaissance capabilities during the information-gathering process. This is particularly valid for certain technologies from **Cloudflare**, **Azure**, and **AWS**.

**How it works:**

1 - The script reads a list of domains (from the wildcards file).

2 - It checks the HTTP headers to see if the domain uses Cloudflare, Azure, or Amazon Services.

3 - If the domain uses one of these services, it resolves the domain's name servers (NS) and sends a query to a Whois API.

4 - It logs the identified domains based on their prefix in an output file with information about the cloud providers.

**Install and Usage:**

``$ curl https://raw.githubusercontent.com/h4rry1337/C.A.A.-Domain-Tracker/main/C.A.A.-Domain-Tracker.sh -O``

**Moving to /usr/bin/**

``$ sudo mv CAA-Domain-Tracker.sh /usr/bin/CAA-Domain-Tracker.sh``

**Change APIKEY for Setup CAA-Domain-Tracker.sh**

``$ sed -i 's/^APIKEY=".*"/APIKEY="APIKEY-HERE"/' /usr/bin/CAA-Domain-Tracker.sh``

**Create the wildcards file and add the top-level domains you want to recognize**

``$ echo domain.com > wildcards``

**For Start Process:**

``$ CAA-Domain-Tracker.sh``

NOTE: IT IS NECESSARY TO INITIATE THE PROCESS IN THE SAME DIRECTORY WHERE THE wildcards FILE IS WRITTEN.

**Results stored in the file cf_or_azr_amzn_domains.txt**

**Credits @c3l3si4n and References: https://celes.in/posts/cloudflare_ns_whois**
