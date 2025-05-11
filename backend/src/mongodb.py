from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
import os
from dotenv import load_dotenv

uri = os.getenv("mongodb+srv://kevinpioabate:Isotopo12@basecluster.y7pj2wc.mongodb.net/?retryWrites=true&w=majority&appName=BaseCluster")
database_name = os.getenv("workflow_db")
collection = os.getenv("commands")


# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))

# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("Connection established")
except Exception as e:
    print(e)


try:
    db = client[database_name]

    collections = db.list_collection_names()
    print(f"Collections inside '{database_name}':")
    for collection in collections:
        print(f" - {collection}")

    # close collection
    client.close()

except Exception as e:
    print(f"Error during connection or reading operation: {e}")


