data "terraform_remote_state" "basic" {
  backend = "remote"
  config = {
    organization = "KKamJi"
    workspaces = {
      name = "basic"
    }
  }
}

output "key_pair_name" {
  value       = data.terraform_remote_state.basic.outputs.key_pair_name
  description = "The name of the key pair used to launch the server"
}