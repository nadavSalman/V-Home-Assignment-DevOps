#!/bin/bash -x

# Base URL of the Flask app
BASE_URL="http://localhost:5000/recommendation"

echo "Testing basic recommendation:"
curl "$BASE_URL"
echo -e "\n"

echo "Testing recommendation by style (Italian):"
curl "$BASE_URL?style=Italian"
echo -e "\n"

echo "Testing recommendation by vegetarian option (Yes):"
curl "$BASE_URL?vegetarian=Yes"
echo -e "\n"

echo "Testing recommendation by time (14:00):"
curl "$BASE_URL?current_time=14:00"
echo -e "\n"

echo "Testing recommendation by multiple parameters (Vegetarian Italian restaurant open at 14:00):"
curl "$BASE_URL?style=Italian&vegetarian=Yes&current_time=14:00"
echo -e "\n"

echo "Testing recommendation with no matching results (Mexican vegetarian restaurant open at 10:00):"
curl "$BASE_URL?style=Mexican&vegetarian=No&current_time=10:00"
echo -e "\n"