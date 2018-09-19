# In Terraform, ALBs are small because all the action is in listeners, targets, and security groups
resource "aws_alb" "alb-webapplication" {
  name            = "webapplication"
  subnets         = ["${var.alb_public_subnets}"]
  security_groups = ["${aws_security_group.alb-webapplication-external_sg.id}"]
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.domain_name}"
  validation_method = "DNS"
}

resource "aws_alb_target_group" "webapplication-targetgroup" {
  name                 = "webapplication"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = 3
  proxy_protocol_v2    = true
}

resource "aws_alb_listener" "webapplication-alb-listener" {
  load_balancer_arn = "${aws_alb.alb-webapplication.id}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${aws_acm_certificate.cert.certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.webapplication-targetgroup.id}"
    type             = "forward"
  }

  #sometimes this needs to be put in. sometimes terraform is better at it.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "webapplication-redirect-https" {
  load_balancer_arn = "${aws_alb.alb-webapplication.id}"
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
      path = "/"
      host = "#{host}"
    }
  }
}

resource "aws_security_group" "alb-webapplication-external_sg" {
  description = "defines specific varieties of access"
  vpc_id = "${var.vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  # it's necessary to accept 80 in order to automatically upgrade the http request
  # if this was internal, i'd go 443 only.
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}