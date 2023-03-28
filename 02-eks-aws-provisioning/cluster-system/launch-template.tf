resource "aws_launch_template" "cluster_system_launch_template" {
    name = "cluster_system_launch_template"
    image_id = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.cluster_system_ec2_instances_security_group.id]
    depends_on = [
        aws_security_group_rule.cluster_system_ec2_instances_inbound_rule,
        aws_security_group_rule.cluster_system_ec2_instances_outbound_rule
    ]
}
