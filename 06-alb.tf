resource "aws_lb_target_group" "byoi_tg" {
  target_type = "instance"
  name        = "byoi-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.byoi-vpc.id

  stickiness { #here no need to enabled this stickiness argument,#
    #enabled = true
    enabled         = false
    type            = "lb_cookie"
    cookie_duration = 3600
  }

  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 5
  }

}

# aws_lb_target_group_attachment
resource "aws_lb_target_group_attachment" "instances-attachment-1" {
  target_group_arn = aws_lb_target_group.byoi_tg.arn
  target_id        = aws_instance.byoi-app-server-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instances-attachment-2" {
  target_group_arn = aws_lb_target_group.byoi_tg.arn
  target_id        = aws_instance.byoi-app-server-2.id
  port             = 80
}


# ALP
resource "aws_lb" "byoi_alb" {
  name                       = "byoi-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [aws_subnet.byoi-public-subnet-1.id, aws_subnet.byoi-public-subnet-2.id]
  security_groups            = [aws_security_group.byoi-ALB-SG.id]
  enable_deletion_protection = false
  /* "enable_deletion_protection" If true, deletion of the load balancer will be disabled via
  the AWS API. This will prevent Terraform from deleting the load balancer.*/

}


# Load Balancer Listener on port 80
resource "aws_lb_listener" "alb_forward_listener_80" {
  load_balancer_arn = aws_lb.byoi_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.byoi_tg.arn
  }
}