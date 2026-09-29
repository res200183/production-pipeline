# AWS Production CI/CD Pipeline with Automatic Rollback

A hands-on AWS DevOps project demonstrating a production-style CI/CD pipeline with automated testing, separate development and production deployments, manual approval, health validation, CloudWatch monitoring, and automatic rollback.

## Architecture

```text
GitHub
   ↓
AWS CodePipeline
   ↓
AWS CodeBuild
   ↓
Unit Tests
   ↓
Deploy to DEV (AWS CodeDeploy)
   ↓
Integration Test
   ↓
Manual Approval
   ↓
Deploy to Production (AWS CodeDeploy)
   ↓
Application Health Validation
   ↓
Amazon CloudWatch Alarm
   ↓
Automatic Rollback on Failure
```

## AWS Services Used

- AWS CodePipeline
- AWS CodeBuild
- AWS CodeDeploy
- Amazon EC2
- Amazon CloudWatch
- Amazon S3
- AWS IAM
- GitHub

## Pipeline Stages

### 1. Source

GitHub is used as the source repository.

A change pushed to the `main` branch triggers the CI/CD pipeline.

### 2. Build and Unit Tests

AWS CodeBuild installs the application dependencies and runs unit tests using `pytest`.

The pipeline continues only if the tests succeed.

### 3. Deploy to DEV

AWS CodeDeploy deploys the application to the development EC2 instance.

The deployment lifecycle is controlled by `appspec.yml` and deployment scripts.

### 4. Integration Test

After the DEV deployment, CodeBuild performs an integration test against the running application.

This verifies that the application is actually available after deployment.

### 5. Manual Approval

Before production deployment, the pipeline waits for manual approval.

This provides a controlled promotion from DEV to Production.

### 6. Production Deployment

After approval, AWS CodeDeploy deploys the tested revision to the Production EC2 instance.

### 7. Application Validation

CodeDeploy lifecycle hooks validate the application after deployment.

The `/health` endpoint is used to verify application availability.

### 8. CloudWatch Monitoring and Automatic Rollback

The Production CodeDeploy deployment group is connected to an Amazon CloudWatch Alarm.

If the alarm enters the `ALARM` state during deployment, CodeDeploy stops the deployment.

Automatic rollback is enabled.

CodeDeploy then automatically redeploys the previously successful application revision.

## Automatic Rollback Test

The rollback mechanism was tested by manually changing the CloudWatch Alarm state to `ALARM`.

The test produced the following sequence:

```text
Production deployment started
        ↓
CloudWatch Alarm entered ALARM
        ↓
CodeDeploy detected the alarm
        ↓
Production deployment stopped
        ↓
Automatic rollback triggered
        ↓
Previous successful revision deployed
        ↓
Rollback succeeded
```

AWS CodeDeploy confirmed:

```text
Initiated by: CodeDeploy rollback

This is a rollback deployment triggered automatically
to roll back the failed/stopped deployment.
```

This verifies the complete failure-detection and recovery workflow.

## CodeDeploy Lifecycle

The project uses the following deployment lifecycle hooks:

```text
BeforeInstall
     ↓
Install
     ↓
AfterInstall
     ↓
ApplicationStart
     ↓
ValidateService
```

The hooks are defined in `appspec.yml`.

## Repository Structure

```text
production-pipeline/
│
├── app.py
├── requirements.txt
├── test_app.py
├── buildspec.yml
├── integration-buildspec.yml
├── appspec.yml
├── README.md
│
└── scripts/
    ├── before_install.sh
    ├── after_install.sh
    ├── start_application.sh
    └── validate_service.sh
```

## Application Endpoints

Main application endpoint:

```text
/
```

Health check endpoint:

```text
/health
```

A successful health check returns:

```text
HTTP 200
OK
```

## Key DevOps Concepts Demonstrated

This project demonstrates:

- Continuous Integration
- Continuous Delivery
- Automated unit testing
- Automated integration testing
- DEV and Production environments
- Deployment lifecycle hooks
- Manual production approval
- Application health checks
- Infrastructure monitoring
- Failure detection
- Automatic rollback
- IAM service roles
- Deployment artifacts
- Production recovery

## Main Learning Outcome

The key workflow implemented in this project is:

```text
Deployment
    ↓
Monitoring
    ↓
Failure Detection
    ↓
Automatic Rollback
```

The project demonstrates how AWS managed DevOps services can be combined to create a controlled deployment process that automatically protects the production environment when a deployment problem is detected.
