#!/bin/sh

# Added files in git
files=$(git diff --cached --name-only --diff-filter=ACM)

echo "Added files: $files"

# Create LOG.md if it doesn't exist
if ! [[ -f "LOG.md" ]]; then
cat > LOG.md <<- EOF
# 📜 LOG

| Last modified | Article | Summary |
| --- | --- | --- |
EOF
fi

# Make table rows as looping through files
rows=""
newline=$'\n'
for filename in $files
do
  # Skip if file is not markdown
  if ! [[ $filename == *.md ]]; then
    continue
  fi

  if [[ $filename == LOG.md || $filename == README.md ]]; then
    continue
  fi

  headline=$(git blame -L 1,1 $filename)

  if [[ -ne $headline ]]; then
    last_modified=$(git blame $filename | grep -Eo '\b[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}\b' | sort -n | tail -1)
    article=$(echo $headline | awk '{split($0, array, "# "); print array[2]}')

    row="| $last_modified | $article | [$filename](./$filename) |"
    rows+=${row}${newline}
  fi
done

# Remove last new line for appending new rows next time script is run
rows=${rows%${newline}}
echo "Rows: $rows"

# Append new rows to LOG.md
if [[ -ne $rows ]]; then
cat >> LOG.md <<- EOF
$rows
EOF

git add LOG.md
fi

# Remove file if it doesn't contain any content
lc=$(wc -l LOG.md | awk '{print $1}')
defaultLines=4
if ! [[ $lc -gt $defaultLines ]]; then
  rm LOG.md
fi
