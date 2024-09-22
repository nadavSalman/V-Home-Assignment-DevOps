from datetime import datetime


class Restaurant:
    def __init__(self, name, style, address, open_hour, close_hour, vegetarian):
        self.name = name
        self.style = style
        self.address = address
        self.open_hour = open_hour
        self.close_hour = close_hour
        self.vegetarian = vegetarian

    def is_open(self, current_time=datetime.now().time()):
        open_time = datetime.strptime(self.open_hour, "%H:%M").time()
        close_time = datetime.strptime(self.close_hour, "%H:%M").time()
        return open_time <= current_time <= close_time
    
    def get_name(self):
        return self.name