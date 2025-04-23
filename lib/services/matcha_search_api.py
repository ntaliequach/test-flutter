import requests
import json
from dotenv import load_dotenv
import os
from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

def search_google(query, num_results=5):
    url = "https://www.googleapis.com/customsearch/v1"

    load_dotenv()

    API_KEY = os.getenv("GOOGLE_PLACES_API_KEY")
    CSE_ID = os.getenv("CSE_ID")

    params = {
        "q": query,
        "key": API_KEY,
        "cx": CSE_ID,
        "num": num_results
    }

    response = requests.get(url, params=params)
    data = response.json()

    results = []
    for item in data.get("items", []):
        results.append({
            "title": item.get("title"),
            "snippet": item.get("snippet"),
            "link": item.get("link")
        })
    print("🔍 Querying:", query)
    print("📡 Request URL:", response.url)
    print("🧾 Raw Response:", data)


    return results

@app.route("/search-matcha", methods=["GET"])
def matcha_search():
    brand = request.args.get("brand")
    if not brand:
        return jsonify({"error": "Missing 'brand' parameter"}), 400

    # Search within Google Shopping
    query = f"{brand} matcha brand"
    try:
        results = search_google(query)
        return jsonify(results)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    

if __name__ == "__main__":
    app.run(debug=True)
