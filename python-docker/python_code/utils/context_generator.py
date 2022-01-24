# Set up the client
import boto3
import yaml

region = "us-east-1"
cluster_name = "lh-shared-services"

def gen_context_file():

    s = boto3.Session(region_name=region)
    eks = s.client("eks")

    # get cluster details
    cluster = eks.describe_cluster(name=cluster_name)
    cluster_cert = cluster["cluster"]["certificateAuthority"]["data"]
    cluster_ep = cluster["cluster"]["endpoint"]

    # build the cluster config hash
    cluster_config = {
            "apiVersion": "v1",
            "kind": "Config",
            "clusters": [
                {
                    "cluster": {
                        "server": str(cluster_ep),
                        "certificate-authority-data": str(cluster_cert)
                    },
                    "name": "kubernetes"
                }
            ],
            "contexts": [
                {
                    "context": {
                        "cluster": "kubernetes",
                        "user": "aws"
                    },
                    "name": "aws"
                }
            ],
            "current-context": "aws",
            "preferences": {},
            "users": [
                {
                    "name": "aws",
                    "user": {
                        "exec": {
                            "apiVersion": "client.authentication.k8s.io/v1alpha1",
                            "command": "heptio-authenticator-aws",
                            "args": [
                                "token", "-i", cluster_name
                            ]
                        }
                    }
                }
            ]
        }

    # Write in YAML.
    config_text=yaml.dump(cluster_config, default_flow_style=False)
    s3 = boto3.resource(
        's3',
        region_name='us-east-1'
    )
    s3.Object('jj-dcs-staging-mwaa-dags', 'dags/config').put(Body=config_text)

if __name__=="__main__":
    gen_context_file()