import json
import requests

def lambda_handler(event, context):
    # TODO implement
    
    apiFTKey = "wroXiS8dSq4aO0HBiXyKX4bZjaHakhcI8x8SfJ7g"
    headers = {'X-API-Key':apiFTKey}
    apiFTUrl = "https://jegp1jgq2h.execute-api.us-east-1.amazonaws.com/default/witf_recom"
    payloadFT = json.dumps({"recom_hist": [],"user_id": "value2","recom_amount": 15})
    header={"x-api-key" : apiFTKey}
    responseFT = requests.get(apiFTUrl, data=payloadFT, headers=header)
    print(responseFT.text)
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

