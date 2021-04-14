import pandas as pd
import os
import ast
import sentence_transformers
import matplotlib.pyplot as plt
import networkx as nx
import pickle
from sklearn.metrics.pairwise import cosine_similarity
from scipy import sparse
import numpy as np
import networkx.algorithms.community as nxcom
import sqlite3
from tqdm import tqdm
import random
import math

random.seed(1)
np.random.seed(1)


def fetch_recommendations(inputs):
    """
    Generate a list of recipe id recommendations.
    if n >= len(last recoms) return n recommendations,
    else return len(last_recoms) recommendations.
    :param inputs: dict/ json. Keys are 'last_recoms', 'user_id', 'recom_amount'
    :return: list of ints. List of recommending recipe ids.
    """

    last_recoms = inputs['last_recoms']
    user_id = inputs['user_id']
    n = inputs['recom_amount']

    user_recom_hist = sqlite3.connect('dbs/user_recom_hist.db')
    c_hist = user_recom_hist.cursor()
    c_hist.execute('''Create TABLE if not exists recom_hist("user_id", "rcp_idx")''')
    c_hist.execute('''Select rcp_idx from recom_hist where user_id={}'''.format(user_id))
    recom_hist = [rcp_idx[0] for rcp_idx in c_hist.fetchall()]

    rcp_sims_db = sqlite3.connect('dbs/rcps_sims.db')
    rcp_sims_c = rcp_sims_db.cursor()
    rcp_sims_c.execute('''Select MAX(rcp1_idx) from rcps_sims Limit 1''')
    rcp_counts = rcp_sims_c.fetchone()[0] + 1

    recoms = []
    if last_recoms is None:
        recoms += np.random.choice(np.arange(rcp_counts), replace=False, size=n).tolist()
    else:
        children_per_recom = n // len(last_recoms)
        children_per_recom = max(children_per_recom, 1)

        for rcp1_idx in last_recoms:
            rcp_sims_c.execute('''Select rcp2_idxs, sims from rcps_sims where rcp1_idx={}'''.format(rcp1_idx))
            children_rcps_str, sims = rcp_sims_c.fetchone()

            rcp_sims = [(int(child_rcp), float(sim))
                        for child_rcp, sim in zip(children_rcps_str.split('|'), sims.split('|'))
                        if int(child_rcp) not in recom_hist][:children_per_recom]
            recoms += [children_rcp for children_rcp, _ in rcp_sims]

            for rcp, sim in rcp_sims:
                print(id2rcp([rcp1_idx], return_info=False), '-{}->'.format(sim), id2rcp([rcp], return_info=False))

        deficit = n - len(recoms)
        if deficit > 0:
            supplements = np.random.choice(list(set(range(rcp_counts)) - set(recom_hist + recoms)),
                                           replace=False, size=deficit).tolist()
            recoms += supplements

    for recom in recoms:
        c_hist.execute(
            'Insert into recom_hist (user_id, rcp_idx) values (?,?)',
            (user_id, recom)
        )

    rcp_sims_db.close()

    user_recom_hist.commit()
    user_recom_hist.close()

    return recoms


def id2rcp(ids):
    """
    Transcribe recipe ids to recipe names, along with other optional information.
    :param ids: list of ints. List of recipe ids.
    :param return_info: boolean. Return other misc information or not.
    :return: dict/ json.
     Keys are 'rcp_names'
        'rcp_idxs'
        'minutes'
        'tags'
        'nutritions'
        'n_steps'
        'steps'
        'descriptions'
        'ingredients'
        'n_ingredients'
    """
    raw_rcps_db = sqlite3.connect('dbs/raw_rcps.db')
    raw_rcps_c = raw_rcps_db.cursor()
    rets = {
        'rcp_names': [],
        'rcp_idxs': [],
        'minutes': [],
        'tags': [],
        'nutritions': [],
        'n_steps': [],
        'steps': [],
        'descriptions': [],
        'ingredients': [],
        'n_ingredients': []
    }
    for id_ in ids:
        raw_rcps_c.execute('''Select * from raw_rcps where rcp_idx={}'''.format(id_))
        rcp_idx, name, minutes, tags, nutrition, n_steps, steps, description, ingredients, n_ingredients = raw_rcps_c.fetchone()
        rets['rcp_names'].append(name)
        rets['rcp_idxs'].append(rcp_idx)
        rets['minutes'].append(minutes)
        rets['tags'].append(tags)
        rets['nutritions'].append(nutrition)
        rets['n_steps'].append(n_steps)
        rets['steps'].append(steps)
        rets['descriptions'].append(description)
        rets['ingredients'].append(ingredients)
        rets['n_ingredients'].append(n_ingredients)

    raw_rcps_db.close()


    return rets


if __name__ == "__main__":

    last_recom = None
    for i in range(5):
        last_recom = fetch_recommendations({'last_recoms': last_recom, 'user_id': 222, 'recom_amount': random.randint(15, 30)})

        # print(id2rcp(last_recom))
        print('-----------------------------------------------------------------------------------------------------')


