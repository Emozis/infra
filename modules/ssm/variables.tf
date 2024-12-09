variable "parameters" {
  description = "Map of SSM parameters to create"
  type = map(object({
    description = string
    type        = string
    value       = string
    tier        = optional(string)
    environment = optional(string)
  }))
}