import json
import os
import argparse


parser = argparse.ArgumentParser(description='JSON format converter')
parser.add_argument('-i', type=str, help='json file in old format')
parser.add_argument('-o', type=str, help='output file')
args = parser.parse_args()
old = open(args.i, "r")
obj = json.loads("\n".join(old.readlines()))

new_dict = {}

for k, v in obj.items(): #dny
    new_dict[k] = {}
    for ki, vi in v.items(): #jednotlivá jídla
        new_dict[k][ki] = {}
        new_dict[k][ki]["jmeno"] = vi["co"]
        new_dict[k][ki]["ingredience"] = []
        if "recept" in vi.keys():
            new_dict[k][ki]["recept"] = vi["recept"]
        else:
            new_dict[k][ki]["recept"] = ''
        hodnoty = vi["kolik"].split("+")
        for ingr in hodnoty:
            n_ingr = {}
            vl = ingr.strip().split(" ")
            n_ingr["nazev"] = " ".join(vl[2:])
            n_ingr["hodnota"] = float(vl[0])
            n_ingr["jednotka"] = vl[1]
            new_dict[k][ki]["ingredience"].append(n_ingr)

nstr = json.dumps(new_dict, ensure_ascii=False)
new = open(args.o, "w")
new.write(nstr)