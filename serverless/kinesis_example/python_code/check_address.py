import json

class CustomAddressValidationError(Exception):
    def __init__(self, message, errors):            
        # Call the base class constructor with the parameters it needs
        super().__init__(message)
            
        # Now for your custom code...
        self.errors = errors

def handler(event,context):
    print(event)
    print(type(event))
    validation_fields = ["street","city","state","zip"] 
    approved = len([x for x in validation_fields if event.get(x)])==len(validation_fields)
    print("validation check")
    print(approved)

    if not approved :
        raise CustomAddressValidationError("Check Address Validation Failed",{"missing_fields":[x for x in validation_fields if not event.get(x)]})
    
   
    return {
        "statusCode":200,
        "body":json.dumps({
            "message": "Validation successfull"
        })
    }

if __name__ == "__main__":
    response = handler({
      "street": "123 Main St",
      "city": "Columbus",
      "state": "OH",
      "zip": "43219"
    },None)

    print(response)