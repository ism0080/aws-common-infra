set -e
set -u

export AWS_DEFAULT_REGION=ap-southeast-2

umask 077

pwd
ls -l *.json

mv *.json $(BASE_DIR)/templates/
cd $(BASE_DIR)/templates

for SCRIPT in *.py; do

  TEMPLATE=${SCRIPT/\.py/\.template}

  echo "Processing $SCRIPT --> $TEMPLATE"
  python "$SCRIPT" > "$TEMPLATE"

  TEMPLATE_SIZE=`stat -c %s $TEMPLATE`
  if [[ "$TEMPLATE_SIZE" -gt 460800 ]]; then
    echo "Template is too big.  Please split into smaller templates."
    exit 1
  elif [[ "$TEMPLATE_SIZE" -gt 51200 ]]; then
    echo "Template is too big for local validation.  Skipping..."
  else
    # aws cloudformation validate-template --template-body "file://$TEMPLATE"
    echo "Successfully validated."
  fi

  rm -f "$SCRIPT"
  echo

done

ls -l *.template

exit 0