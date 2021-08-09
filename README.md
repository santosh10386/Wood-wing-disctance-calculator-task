# Wood-wing-disctance-calculator-task


### Goal: 
Make a web service that accepts two distances (numbers) and returns the total
distance (sum of both) deployable at AWS.

### Technical Goal
Implement a highly available web service using AWS services and other tools.


# Summary

To solve the following use-case, I will focus on these points:

1. Will use Html, CSS and JavaScript to create webpage.
2. Will use apache HTTPD container over Docker container engine. ( also can use EKS service but not including here) 
3. Static webpage will be now available over repo, then it cloned over Aws Instance. (can implemet over Aws EBS and s3 for persistance storage)
4. Will use terraform as IAAC for  creating highly available Infrastructure.
5. Can implement ansible for further configuration. (Not use now)
6. Make repository with multi-branch over here to support better team  code commit.  Teammates  can send pull request for the change in main branch.

