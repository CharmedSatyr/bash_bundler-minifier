#!/bin/bash

#$ Print all arguments
echo "Files submitted: $@"

# Argument array variable
ARR=()

for i in "$@"
  do
    if [[ "$i" =~ ^([a-zA-Z0-9\_\-\.])+(.js){1}$ ]]
      then 
        ARR+=("$i")
    else
        echo "The file '$i' will be ignored. Please ensure your JavaScript files have valid names and extensions."
    fi
done

# Print output
echo "The following files will be added to bundle.min.js:
${ARR[@]}"

# 1. cat will concatenate the files from ARR
# 2. sed will remove comments starting with //
COMMENTS='([\/]{2,}.*$)'
# 3. sed will remove multiline comments enclosed with /* */
MULTILINE='([\/\*].*[\*\/])'
# 4. tr will remove tabs, carriage returns, and newlines
SPECIAL='\011\012\015'
# 5. sed will replace 2+ spaces with 1 space
MULTISPACE='\s{2,}'
# 6. sed will remove single spaces except where they're syntactically necessary
#

cat ${ARR[@]} | sed -r 's/'"$COMMENTS"'//gm' | sed -r 's/'"$MULTILINE"'//gm' | tr -d $SPECIAL | sed -r 's/'"$MULTISPACE"'/\ /gm' > bundle.min.js
