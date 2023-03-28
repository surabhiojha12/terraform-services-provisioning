resource "aws_launch_template" "cluster_system_launch_template" {
    name = "cluster_system_launch_template"
    image_id = var.ami
    instance_type = var.instance_type
}
