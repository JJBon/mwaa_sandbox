import os
import boto3
from io import StringIO
import pandas as pd

bucket = 'jj-dcs-staging-mwaa-dags' # already created on S3
print("bucket ",bucket)
csv_buffer = StringIO()
df = pd.DataFrame({"a":[1,2]})
df.to_csv(csv_buffer)
s3_resource = boto3.resource('s3')
s3_resource.Object(bucket, 'df.csv').put(Body=csv_buffer.getvalue())

print(os.environ)
print("change file")
print("dic 10 change")
print("new comment")