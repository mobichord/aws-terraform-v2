import os
import pymongo
import json
import boto3
import logging
import traceback

from bson import Decimal128, json_util

# Configure logging
logger = logging.getLogger()
logger.setLevel("INFO")

def lambda_handler(event, context):
    print(event)

    try:
        client = pymongo.MongoClient(host=os.environ['MONGODB_URI']+os.environ['MONGODB_NAME'])
    except Exception as e:
        logger.error(f"Failed to establish MongoDB connection during initialization: {str(e)}")
        client = None

    if client is None:
        error_message = "MongoDB client is not initialized."
        logger.error(error_message)
        return create_response(500, {'errors': error_message})
    else:
        print(client)

    try:
        database_name = os.environ.get('MONGODB_NAME')
        db = client[database_name]
        # body_dict = json.loads(event['body'])

        if 'queryStringParameters' in event:
            query_params = event['queryStringParameters']

        collection_value, other_key, other_value = extract_values_from_event(query_params)

        if collection_value is not None:
            collection_name = db[collection_value]

            if collection_value not in db.list_collection_names():
                error_message = f"Collection '{collection_value}' does not exist within the database '{database_name}'"
                logger.error(error_message)
                traceback.print_exc()
                return create_response(404, {'errors': error_message})

            if other_value:
                return query_by_id(collection_name, other_key, other_value)
            else:
                error_message = "Missing or invalid value in the event"
                logger.error(error_message)
                return create_response(400, {'errors': error_message})
        else:
            error_message = "The collection key is not present in the paramaters."
            logger.error(error_message)
            traceback.print_exc()
            return create_response(404, {'errors': error_message})
    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})
    except pymongo.errors.CollectionInvalid:
        error_message = f"Collection '{collection_name}' does not exist within the database '{database_name}'"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(404, {'errors': error_message})
    
def extract_values_from_event(body_dict):
    collection_value = None
    other_key = None
    other_value = None
    collection_found = False

    for key, value in body_dict.items():
        if key == "collection" and not collection_found:
            collection_value = value
            collection_found = True
        else:
            if not other_key:
                other_key = key
                other_value = value
            else:
                break
                
    return collection_value, other_key, other_value
    
def query_by_id(collection, other_key, other_value):
    cursor = collection.find({other_key: other_value})
    result = list(cursor)

    if result:
        result = json.loads(json_util.dumps(result))
        
        tenant_config_params = ["userPassword", "userPasswordSalt", "password","publicKey","privateKey","appAccessKey"]
        system_config_params = ["userPassword", "userPasswordSalt", "password","headerPassword", "headerPasswordSalt", "containerPassword","containerPasswordSalt", "certificatePassword", "certificatePasswordSalt","fnUserPassword", "callbackPassword", "callbackPasswordSalt","encryptionKey","privateKey"]
        tenant_configuration_params = ["accessKey", "secretKey", "k8sBucketAccessKey","k8sBucketSecretKey", "salt", "apiAccountPassword","securityPin", "certificatePassword", "certificatePasswordSalt","fnUserPassword", "callbackPassword", "callbackPasswordSalt","clientSecret","encryptedFields","keyFile","appAccessKey","key","keyPassword","password","publicKey","privateKey"]
        provider_cred_params = ["password", "salt", "encryptedFields","certificate","certificatePassword","developerKey","certificate","privateKey","privateKeyPassword"]
        provider_agreements_params = ["password", "salt", "encryptedFields"]

        for document in result:
            check_and_mask_keys(document, tenant_config_params)
            check_and_mask_keys(document, system_config_params)
            check_and_mask_keys(document, tenant_configuration_params)
            check_and_mask_keys(document, provider_cred_params)
            check_and_mask_keys(document, provider_agreements_params)

        return create_response(200, result)
    else:
        error_message = f"No document found with {other_key}: {other_value}"
        print(f"No document found with {other_key}: {other_value}")
        traceback.print_exc()
        return create_response(404, {'errors': error_message})
    
def check_and_mask_keys(data, keys, mask_string="*****"):
    if isinstance(data, dict):
        for key, value in data.items():
            if key in keys:
                data[key] = mask_string
            if isinstance(value, (dict, list)):
                check_and_mask_keys(value, keys, mask_string)
    elif isinstance(data, list):
        for item in data:
            check_and_mask_keys(item, keys, mask_string)

def create_response(statusCode, body):
    response = {
        "statusCode": statusCode,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(body),
        "isBase64Encoded": False
    }
    return response
