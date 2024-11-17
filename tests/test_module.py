import json
from os import path as osp
from textwrap import dedent

from infrahouse_toolkit.terraform import terraform_apply

from tests.conftest import (
    LOG,
    TRACE_TERRAFORM,
    REGION,
    TERRAFORM_ROOT_DIR,
)


def test_module(ec2_client, keep_after, test_role_arn, github_token):
    terraform_module_dir = osp.join(TERRAFORM_ROOT_DIR, "main")
    with open(osp.join(terraform_module_dir, "terraform.tfvars"), "w") as fp:
        fp.write(
            dedent(
                f"""
                role_arn     = "{test_role_arn}"
                region       = "{REGION}"
                github_token = "{github_token}"
                """
            )
        )

    with terraform_apply(
        terraform_module_dir,
        destroy_after=not keep_after,
        json_output=True,
        enable_trace=TRACE_TERRAFORM,
    ) as tf_httpd_output:
        LOG.info(json.dumps(tf_httpd_output, indent=4))
