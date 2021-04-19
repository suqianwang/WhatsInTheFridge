import json
import os
import json
import sqlite3
import boto3
import random

random.seed(1)

client = boto3.client('lambda')

def fetch_recommendations(event):
    """
    Generate a list of recipe id recommendations.
    if n >= len(last recoms) return n recommendations,
    else return len(last_recoms) recommendations.
    :param inputs: dict/ json. Keys are 'last_recoms', 'user_id', 'recom_amount'
    :return: list of ints. List of recommending recipe ids.
    """

    print("here!")
    last_recoms = event.get('last_recoms')
    user_id = event.get('user_id')
    n = event.get('recom_amount')

    user_recom_hist = sqlite3.connect('/mnt/recom_invoker_efs/user_recom_hist.db')
    c_hist = user_recom_hist.cursor()
    c_hist.execute('''Create TABLE if not exists recom_hist("user_id", "rcp_idx")''')
    c_hist.execute('''Select rcp_idx from recom_hist where user_id={}'''.format(user_id))
    recom_hist = [rcp_idx[0] for rcp_idx in c_hist.fetchall()]
    
    payload = {
        "recom_hist": recom_hist,
        "user_id": user_id,
        "recom_amount": n,
    }
    
    response_json = client.invoke(
        FunctionName = 'witf_recom',
        InvocationType = 'RequestResponse',
        Payload = json.dumps(payload)
    )
    response = json.load(response_json['Payload'])



    # for recom in recoms:
    #     c_hist.execute(
    #         'Insert into recom_hist (user_id, rcp_idx) values (?,?)',
    #         (user_id, recom)
    #     )

    # rcp_sims_db.close()

    # user_recom_hist.commit()
    # user_recom_hist.close()

    # return recoms
    
    return response


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
    raw_rcps_db = sqlite3.connect('/mnt/recom_invoker_efs/raw_rcps.db')
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


def lambda_handler(event, context):
    response = fetch_recommendations(event)
    return {
        'statusCode': 200,
        # 'body': json.dumps({'result': response})
        'body': [os.listdir('/mnt/recom_invoker_efs/'), os.access('/mnt/recom_invoker_efs/', os.W_OK)]
    }

