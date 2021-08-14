import json

def lambda_handler(event, context):
    responseMessage = "Hello from Lambda!"
    queryStringParameters = event['queryStringParameters']
    if queryStringParameters is not None:
        queryParam = "message"
        if queryParam in queryStringParameters:
            responseMessage = queryStringParameters[queryParam]
            responseMessage = responseMessage.replace("ABN", "ABN AMRO")
            responseMessage = responseMessage.replace("ING", "ING Bank")
            responseMessage = responseMessage.replace("Rabo", "Rabobank")
            responseMessage = responseMessage.replace("Triodos", "Triodos Bank")
            responseMessage = responseMessage.replace("Volksbank", "de Volksbank")
    return {
        'statusCode': 200,
        'body': json.dumps(responseMessage)
    }
