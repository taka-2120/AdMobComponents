#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

prompt_install() {
    read -p "$1 is not installed. Do you want to install it? (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        $2
    else
        exit 1
    fi
}

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    prompt_install "Homebrew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
fi

# Check for copy `git-format-staged` script
curl -fsSL https://raw.githubusercontent.com/hallettj/git-format-staged/refs/heads/main/git-format-staged > $PWD/scripts/git-format-staged

# Check for Python
if ! python3 --version &>/dev/null; then
    printf "${RED} ERROR: Python 3 is not installed.${NC}\n"
fi

# Check for SwiftFormat
if ! command -v swiftformat &> /dev/null; then
    prompt_install "SwiftFormat" 'brew install swiftformat'
fi

# Remove file if it already exists
if test -f $PWD/.git/hooks/pre-commit; then
    rm $PWD/.git/hooks/pre-commit
fi

# Create a symbolic link to the pre-commit script
OUTPUT=$(ln -s $PWD/scripts/pre-commit $PWD/.git/hooks/pre-commit)
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: $OUTPUT${NC}"
    exit 1
fi

chmod +x $PWD/.git/hooks/pre-commit
echo -e "${GREEN}Setup complete.${NC}"
exit 0