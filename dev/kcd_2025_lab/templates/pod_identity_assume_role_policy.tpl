{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EKSPodIdentityAssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "pods.eks.amazonaws.com"
      },
      "Action": [
        "sts:AssumeRole",
        "sts:TagSession"
      ],
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "${account_id}"
        },
        "ArnLike": {
          "aws:SourceArn": "arn:${partition}:eks:${region}:${account_id}:podidentityassociation/*"
        }
      }
    }
  ]
}
