# General
variable "region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "weather-api-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "docker_image" {
  description = "Docker Hub image for the weather API (e.g. username/weather-api)"
  type        = string
  default     = "username/weather-api"
}

variable "fargate_namespaces" {
  description = "Kubernetes namespaces to target with the Fargate profile"
  type        = list(string)
  default     = ["default", "kube-system"]
}
