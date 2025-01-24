# # public-ip of bastion-server
# output "bastion-server-public-ip" {
#   value = aws_instance.byoi-bastion-server.public_ip
# }

# # private-ip of app-server-1
# output "app-server-1-private-ip" {
#   value = aws_instance.byoi-app-server-1.private_ip
# }

# # private-ip of app-server-2
# output "app-server-2-private-ip" {
#   value = aws_instance.byoi-app-server-2.private_ip
# }

# # rds-endpoint
# output "rds_endpoint" {
#   value = aws_db_instance.db_instance.address
# }

# # ALB dns_name
# output "alb_dns_name" {
#   value = aws_lb.byoi_alb.dns_name
# }