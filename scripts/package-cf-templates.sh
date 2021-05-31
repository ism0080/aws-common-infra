set -exu

set
cd deployment/app

TEMPLATES_BUCKET="$AWS_ARTIFACTSTORE_INFRA_NAME"

aws cloudformation package --template-file templates/_master.template \
                                                 --s3-bucket "$TEMPLATES_BUCKET" \
                                                 --s3-prefix "$AWS_ARTIFACTSTORE_INFRA_TEMPLATESPATH" \
                                                 --use-json > templates/_master.template.packaged.json

sed -ie '/Uploading to/d' templates/_master.template.packaged.json

cat templates/_master.template.packaged.json