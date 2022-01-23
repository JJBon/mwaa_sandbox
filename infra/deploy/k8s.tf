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
      split("=",line)[0] => split("=",line)[1]  
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
 
}





# resource "kubernetes_config_map" "aws_auth" {
#     metadata {
#         name = "aws_auth"
#         namespace = "kube-system"
#     }

#     data = {
#         mapRoles = [yamlencode(local.test)]
#     }
# }

# locals {
#     test = {
#         rolearn = "arn:aws:iam::668102661106:role/dcs-mwaa-staging-pipeline-CodebuildRole"
        
#     }
# }