import json

class CustomValidationError(Exception):
    def __init__(self, message, errors):            
        # Call the base class constructor with the parameters it needs
        super().__init__(message)
            
        # Now for your custom code...
        self.errors = errors

def handler(event,context):
    print(event)
    validation_fields = ["ssn","email"] 
    approved = len([x for x in validation_fields if event.get(x)])==len(validation_fields)

    if not approved :
        raise CustomValidationError("Check Identity Validation Failed",{"missing_fields":[x for x in validation_fields if not event.get(x)]})
    
   
    return {
        "statusCode":200,
        "body":json.dumps({
            "message": "Validation successfull"
        })
    }


if __name__ == "__main__":
    response = handler({
      "email": "jdoe@example.com",
      "ssn": "123-45-6789"
    },None)

    print(response)