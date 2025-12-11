#!/bin/bash

# Script to add copyright header to all .dart files
# Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
# Licensed under the GNU General Public License v3.0 (GPL-3.0).

set -e

COPYRIGHT_HEADER="// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details."

# Counter for files processed
TOTAL=0
SKIPPED=0
ADDED=0

# Find all .dart files
while IFS= read -r -d '' file; do
    ((TOTAL++))
    
    # Check if the file already has the copyright header
    if head -n 3 "$file" | grep -q "Copyright (c) Smartopia AI"; then
        echo "Skipping (already has header): $file"
        ((SKIPPED++))
    else
        echo "Adding header to: $file"
        
        # Create a temporary file with the header and original content
        {
            echo "$COPYRIGHT_HEADER"
            echo ""
            cat "$file"
        } > "${file}.tmp"
        
        # Replace original file with the new one
        mv "${file}.tmp" "$file"
        ((ADDED++))
    fi
done < <(find . -name "*.dart" -type f -not -path "*/.*" -not -path "*/build/*" -not -path "*/.dart_tool/*" -print0)

echo ""
echo "Summary:"
echo "  Total .dart files found: $TOTAL"
echo "  Files skipped (already had header): $SKIPPED"
echo "  Files updated with header: $ADDED"
