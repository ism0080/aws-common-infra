echo ""
echo "Looking for template files"
echo ""
echo "List of files to be checked :"
FILELIST=`find . -type f -name *.template`
for file in $FILELIST; do echo $file; done

echo ""
echo "# of files to validate : `echo $FILELIST | wc -w`"
echo""

for file in $FILELIST
do
    echo
    TEMPLATE_SIZE=`stat -c %s $file`
    if [[ "$TEMPLATE_SIZE" -gt 460800 ]]; then
        echo "Template is too big.  Please split $file into smaller templates."
        exit 1
    elif [[ "$TEMPLATE_SIZE" -gt 51200 ]]; then
        echo "Template $file is too big for local validation.  Skipping..."
    else
        echo "Validating: $file"
        echo
        aws cloudformation validate-template --region ap-southeast-2 --template-body file://$file
        echo
    fi
done