import json
import re
import matplotlib.pyplot as plt
from mpldatacursor import datacursor
from matplotlib.ticker import MaxNLocator
import argparse
import sys

def plot_condition(etichetta, coords, minLimit):
    if len(coords) < minLimit:
        return

    x = [i for (i,_) in coords]
    y = [i for (_,i) in coords]
    plt.plot(x, y, '.-', label=etichetta)

def plot_specific_conditions(conditions, dictionary):
    for condition in conditions:
        x = [i for (i,_) in dictionary[condition]]
        y = [i for (_,i) in dictionary[condition]]
        plt.plot(x, y, '.-', label=condition)

def main(inputFile, minLimit, selectedConditions):
    with open(inputFile) as f:
        jsonified = re.sub("([a-z])", lambda x: '"' + x.group(1) + '"', f.read())
        condizioni = json.loads(jsonified)

    evolution = dict()

    i = 1

    for condgroup in condizioni:
        for cond in condgroup:
            etichetta = cond[1:len(cond)]
            if not str(etichetta) in evolution:
                evolution[str(etichetta)] = [(i, cond[0])]
            else:
                evolution[str(etichetta)].append((i,cond[0]))
        i = i + 1

    print(evolution)

    if(len(selectedConditions) != 0):
        plot_specific_conditions(selectedConditions, evolution)
    else:    
        for etichetta, coords in evolution.items():
            plot_condition(etichetta,coords,minLimit)
    
    plt.title('Andamento dei coefficienti')
    #plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05), shadow=True, ncol=7)
    datacursor(formatter='{label}'.format)
    plt.show()

if __name__ == "__main__":
    global args
    selectedConditions = []
    parser = argparse.ArgumentParser(description='Un visualizzatore per le condizioni')
    parser.add_argument("--input", default="condizioni.txt")
    parser.add_argument("--min", type=int, default=3)
    parser.add_argument("--condition")
    parser.add_argument("--conditions")
    args = parser.parse_args()
    if args.condition:
        selectedConditions.append(args.condition)
    elif args.conditions:
        with open(args.conditions) as f:
            selectedConditions = json.loads(f.read())
    main(args.input, args.min, selectedConditions)