from flask import Flask, render_template, request ,jsonify
from restaurants_inventory.inventory import Inventory
from restaurants_inventory.restaurant import Restaurant
from datetime import datetime



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
    recommendation = inventory.get_recommendation(style, vegetarian, current_time)

    if recommendation:
        return jsonify({
            "massage" : f"A {get_recommendation}",
            "restaurantRecommendation": {
                "name": recommendation.name,
                "style": recommendation.style,
                "address": recommendation.address,
                "openHour": recommendation.open_hour,
                "closeHour": recommendation.close_hour,
                "vegetarian": recommendation.vegetarian
            }
        })
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