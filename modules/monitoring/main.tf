# =============================================================================
# 📊 MONITORING AND OBSERVABILITY MODULE FOR KIDS! 📊
# =============================================================================
# This module helps kids learn about monitoring their cloud resources!

# =============================================================================
# 📈 CLOUDWATCH DASHBOARD
# =============================================================================
# Create a beautiful dashboard to monitor our resources

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.instance_id],
            [".", "NetworkIn", ".", "."],
            [".", "NetworkOut", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "🖥️ Server Performance"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/S3", "BucketSizeBytes", "BucketName", var.s3_bucket_name, "StorageType", "StandardStorage"],
            [".", "NumberOfObjects", ".", ".", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "📦 Storage Usage"
          period  = 300
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 6
        width  = 24
        height = 6

        properties = {
          query   = "SOURCE '${var.log_group_name}' | fields @timestamp, @message | sort @timestamp desc | limit 100"
          region  = var.aws_region
          title   = "📝 Recent Logs"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.project_name}-monitoring-dashboard"
  })
}

# =============================================================================
# 🚨 CLOUDWATCH ALARMS
# =============================================================================
# Set up alarms to notify us when something goes wrong

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-high-cpu-alarm"
  })
}

resource "aws_cloudwatch_metric_alarm" "low_disk_space" {
  alarm_name          = "${var.project_name}-low-disk-space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DiskSpaceUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "20"
  alarm_description   = "This metric monitors disk space utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = var.instance_id
    MountPath  = "/"
    Filesystem = "/dev/xvda1"
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-low-disk-space-alarm"
  })
}

# =============================================================================
# 📧 SNS NOTIFICATIONS
# =============================================================================
# Set up notifications for important events

resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"

  tags = merge(var.tags, {
    Name = "${var.project_name}-alerts-topic"
  })
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.alert_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# =============================================================================
# 📝 CLOUDWATCH LOG GROUPS
# =============================================================================
# Set up log groups for application logs

resource "aws_cloudwatch_log_group" "application" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.project_name}-application-logs"
  })
}

# =============================================================================
# 🔍 CLOUDWATCH INSIGHTS QUERIES
# =============================================================================
# Pre-defined queries for common troubleshooting

resource "aws_cloudwatch_query_definition" "error_logs" {
  name = "${var.project_name}-error-logs"

  log_group_names = [aws_cloudwatch_log_group.application.name]

  query_string = <<EOF
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 100
EOF
}

resource "aws_cloudwatch_query_definition" "performance_logs" {
  name = "${var.project_name}-performance-logs"

  log_group_names = [aws_cloudwatch_log_group.application.name]

  query_string = <<EOF
fields @timestamp, @message
| filter @message like /performance/ or @message like /slow/
| sort @timestamp desc
| limit 100
EOF
}
