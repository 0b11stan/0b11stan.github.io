curl -s 'https://api.www.root-me.org/auteurs/227831' \
  -b "api_key=$(pass ctfs/rootme/api)" \
  | jq '. | {score: .score, rank: .position}'

