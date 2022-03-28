data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.cluster.id
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.cluster.id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

resource "kubernetes_namespace" "staging_ns" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "staging-namespace"
    }

    name = var.namespace_name
  }
}



resource "kubernetes_secret" "dcs-secrets" {
  metadata {
    name = "dcs-secrets"
    namespace = kubernetes_namespace.staging_ns.metadata.0.name
  }

  type = "generic"

  
  data = {
    for line in compact(split("\n", file("${path.module}/../environments/.env_prod"))):
      split("=\"",line)[0] => trim(split("=\"",line)[1],"\"")
  }
  
}

resource "kubernetes_role" "main_role" {
  metadata {
    name = "main-role"
    namespace = kubernetes_namespace.staging_ns.metadata.0.name
    labels = {
      test = "MyRole"
    }
  }

  rule {
    api_groups     = ["","apps","batch","extensions"]
    resources      = ["jobs"
      ,"pods"
      ,"pods/attach"
      ,"pods/exec"
      ,"pods/log"
      ,"pods/portforward"
      ,"secrets"
      ,"services"]
    
    verbs          = [
       "create"
      ,"delete"
      ,"describe"
      ,"get"
      ,"list"
      ,"patch"
      ,"update"
        ]
  }
}

resource "kubernetes_role_binding" "example" {
  metadata {
    name      = "main-role-binding"
    namespace = kubernetes_namespace.staging_ns.metadata.0.name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.main_role.metadata.0.name
  }
  subject {
    kind      = "User"
    name      = "mwaa-service"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "User"
    name      = "main-user"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.mwaa_service_account.metadata.0.name
    #api_group = "rbac.authorization.k8s.io"
  }

}

resource "kubernetes_config_map" "airflow-vars" {
  metadata {
    name = "airflow-vars"
    namespace = var.namespace_name
  }
  data = {
    "airflow_vars.json"   = "${file("${path.module}/../environments/airflow_vars.json")}"
  }
}

resource "kubernetes_service_account" "mwaa_service_account" {
  metadata {
    name = var.service_account_name
    namespace = var.namespace_name
    annotations = {
      "eks.amazonaws.com/role-arn": aws_iam_role.service_account_role.arn
    }
  }
}

resource "aws_iam_role" "fargate_airflow_role" {
  name = "eks-fargate-profile-airflow"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


resource "aws_iam_role_policy_attachment" "airflow-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_airflow_role.name
}

resource "aws_eks_fargate_profile" "airflow_fargate" {
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = "airflow"
  pod_execution_role_arn = aws_iam_role.fargate_airflow_role.arn
  subnet_ids             = [aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id]

  selector {
    namespace = var.namespace_name
  }
}

resource "kubernetes_namespace" "aws_observability" {
  metadata {
  
    labels = {
      aws_observability = "enabled"
    }

    name = aws-observability
  }
}

resource "kubernetes_config_map" "aws_logging" {
  metadata {
    name = "aws-logging"
    namespace = kubernetes_namespace.aws_observability.metadata.0.name
  }
  data = {
    "output.conf" =  "[OUTPUT] Name cloudwatch_logs Match   * region us-east-1 log_group_name fluent-bit-cloudwatch log_stream_prefix from-fluent-bit- auto_create_group true log_key log"
    "parsers.conf" = "[PARSER] Name crio Format Regex Regex ^(?<time>[^ ]+) (?<stream>stdout|stderr) (?<logtag>P|F) (?<log>.*)$ Time_Key time Time_Format %Y-%m-%dT%H:%M:%S.%L%z"
    "filters.conf" = "[FILTER] Name parser Match * Key_name log Parser crio"
  }
}

data "aws_iam_policy_document" "iam_policy_document_fargate" {
  statement {
    sid       = ""
    actions   = [
      "logs:CreateLogStream",
			"logs:CreateLogGroup",
			"logs:DescribeLogStreams",
			"logs:PutLogEvents"
      ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "iam_policy_fagate" {
  name   = fargatelogs
  path   = "/"
  policy = data.aws_iam_policy_document.iam_policy_document_fargate.json
}

resource "aws_iam_role_policy_attachment" "airflow-AmazonEKSFargatePodExecutionRolePolicy-fargate" {
  policy_arn = aws_iam_policy.iam_policy_fagate.arn
  role       = aws_iam_role.fargate_airflow_role.name
}