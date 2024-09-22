from flask import Flask, render_template, request ,jsonify
from restaurants_inventory.inventory import Inventory
from restaurants_inventory.restaurant import Restaurant
from datetime import datetime


from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient
import json
import os
import uuid


app = Flask(__name__)



#  ingressClassName: external-nginx


# Populate the inventory with some sample data
inventory = Inventory()
inventory.add_restaurant(Restaurant("Pizza Hut", "Italian", "Wherever Street 99, Somewhere", "09:00", "23:00", "Yes"))
inventory.add_restaurant(Restaurant("Le Gourmet", "French", "Gourmet Lane 22, Paris", "10:00", "22:00", "No"))
inventory.add_restaurant(Restaurant("Korean BBQ", "Korean", "Seoul Road 55, Seoul", "12:00", "20:00", "Yes"))

'''
Query Parameters : style,vegetarian,
'''
@app.route('/recommendation', methods=['GET'])
def get_recommendation():
    style = request.args.get('style')
    vegetarian = request.args.get('vegetarian')
    current_time_str = request.args.get('current_time', datetime.now().strftime("%H:%M")) #  If the parameter is not provided, now()
    current_time = datetime.strptime(current_time_str, "%H:%M").time()

    # Get recommendation
    recommendation:Restaurant = inventory.get_recommendation(style, vegetarian, current_time)



    # Track history by updatein blob storage
    container_name = 'restaurants'
    blob_name = f'request_response_{uuid.uuid4()}.json'
    

    recommendation_response = {
            "massage" : f"The restaurant {recommendation.get_name()} {recommendation.is_open(current_time=current_time) }.",
            "restaurantRecommendation": {
                "name": recommendation.name,
                "style": recommendation.style,
                "address": recommendation.address,
                "openHour": recommendation.open_hour,
                "closeHour": recommendation.close_hour,
                "vegetarian": recommendation.vegetarian
            }
    }

    blob_data = {
        'request': {
            'style': style,
            'vegetarian': vegetarian,
            'time': current_time
        },
        'response': {
            'data': recommendation_response
        }
    }

    # Initialize DefaultAzureCredential which will use the Managed Identity
    credential = DefaultAzureCredential()

    # Create BlobServiceClient using Managed Identity
    blob_service_client = BlobServiceClient(
        account_url=f"https://{os.getenv('STORAGE_ACCOUNT_NAME')}.blob.core.windows.net",  # replace storageAccountName with env
        credential=credential
    )

    # Get the container client
    container_client = blob_service_client.get_container_client(container_name)
    blob_client = container_client.get_blob_client(blob_name)
    json_data = json.dumps(blob_data)
    blob_client.upload_blob(json_data, overwrite=True)
    app.logger.info(f"Blob '{blob_name}' uploaded to container '{container_name}'.")

    if recommendation:
        return jsonify(recommendation_response)
    else:
        return jsonify({"message": "No matching restaurant found."}), 404


@app.route("/endpoints")
def endpoints():
    routes = []
    for rule in app.url_map.iter_rules():
        routes.append(str(rule))
    return {"endpoints": routes}



if __name__ == '__main__':
    app.run(debug=True)