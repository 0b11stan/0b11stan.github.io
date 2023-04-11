import json

with open('./readings.json', 'rb') as f:
    readings = json.loads(f.read())

for reading in readings:
    line = f"## { reading['author'] } - { reading['title'] }\n\n"
    line += f"![{ reading['picture'] }]({ reading['picture'] })\n"
    print(line)
    # print(reading['picture'])
