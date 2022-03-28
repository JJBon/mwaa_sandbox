import base64
import boto3
from os import environ
import time

client = boto3.client('stepfunctions')


def handler(event,context):
    for record in event["Records"]:
        data_enc = record["data"]
        data = base64.decode(data_enc)
        client.start_execution(
            stateMachineArn=environ["STATE_M_ARN"],
            name=f'webhook-process-{time.time_ns()}',
            input=data
        )