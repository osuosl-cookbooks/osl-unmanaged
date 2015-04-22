#!/usr/bin/env python

import json
import requests
import subprocess

# Get list of all repos in the osuosl-cookbooks organization
page = 1
names = []
while True:
    data = json.loads(requests.get("https://api.github.com/orgs/osuosl-cookbooks/repos?page={}".format(page)).text)
    if len(data) == 0:
        break
    else:
        page += 1
        names.extend([repo['name'] for repo in data])

# Create entries for repos
entries = []
for name in sorted(names):
    entries.append("""
[osuosl-cookbooks/{}]
checkout = git clone git@github.com:osuosl-cookbooks/{}.git""".format(name, name))

# Write the entries
with open("../.mrconfig.d/github-repos", 'w') as f:
    f.write("\n".join(entries))
