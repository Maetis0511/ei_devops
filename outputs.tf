output "vm_public_ip" {
  description = "L'adresse IP publique de la VM"
  value       = module.compute.public_ip
}
