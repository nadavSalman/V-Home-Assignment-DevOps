class Inventory:
    def __init__(self):
        self.restaurants = []

    def add_restaurant(self, restaurant):
        self.restaurants.append(restaurant)

    def get_recommendation(self, style=None, vegetarian=None, current_time=None):
        recommendations = [r for r in self.restaurants
                            if (style is None or r.style == style)
                            and (vegetarian is None or r.vegetarian == vegetarian)
                            and (current_time is None or r.is_open(current_time))]
        

        # If non of the restaurants aline with all args the response will be set to check if one arg found
        if len(recommendations) == 0:
            recommendations = [r for r in self.restaurants
                                if (style is None or r.style == style)
                                or (vegetarian is None or r.vegetarian == vegetarian)
                                or (current_time is None or r.is_open(current_time))]
        if recommendations:
            return recommendations[0]  # Return the first match for simplicity
        return None