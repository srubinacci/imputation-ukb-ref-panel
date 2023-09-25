---
description: Tips and FAQs for troubleshooting
---

# Troubleshooting

### Re-run jobs due to stochastic failure

In situations where you encounter stochastic failures during job execution (e.g. due to spot instances allocated to another resource with higher priority), the DNAnexus platform offers a handy parameter in the `dx run` command, named `--clone`, explicitly designed to address this issue. To utilize this feature, you'll need to provide the ID of the failed job as its value.

To incorporate this functionality with the `dx find job` command, follow this straightforward one-liner:

```bash
dx find jobs --state failed --created-after 2023-09-20 --brief | xargs -I {} dx run --clone {} -y --brief
```

This command re-runs all failed jobs created after a specific date while maintaining the same parameters as the original job (including its priority, name, and input/outputs).&#x20;

Notably, the RAP detects that you're re-running the job and appends a " (re-run)" suffix to the job name for clarity.&#x20;

In the context of our pipelines, please re-run only computational jobs (conversion, imputation, pre-phasing) and not pipeline jobs. If the job failed for another reason (e.g. the allocated resources were not sufficient, please look at the following section.

### Re-run jobs due to insufficient memory

Another common case is dealing with instances where jobs fail due to insufficient resources. Similar to re-running jobs due to stochastic failure, we can build upon the `--clone` option. In this case, you can not only clone the failed job but also specify a larger instance type and overwrite other parameters, such as the job name or priority, if necessary.

To execute this, you can adapt the `dx run` command as follows:

```bash
dx run --clone <failed_job_ID> -y --instance-type <larger_instance_type> --priority <new_priority> --name <new_job_name>
```

By using the `--clone` option in combination with instance type, priority, and name modifications, you gain the flexibility to rerun jobs with enhanced resource allocation. This approach ensures that your jobs have the necessary resources to successfully complete their tasks, mitigating issues caused by resource constraints.

### Re-run jobs due to another problem

If other problems can arise, they can be both stochastic or software-related. Please re-run your job using the --clone option, and if the same message/error is shown, open an issue on GitHub.
