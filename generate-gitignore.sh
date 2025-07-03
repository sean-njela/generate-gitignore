#!/bin/bash

# Script: generate-gitignore.sh
# Description: Interactive .gitignore generator using gitignore.io API
# Author: ChatGPT
# Requirements: curl

COMMON_STACKS=(
  "Python"
  "Node"
  "Java"
  "Go"
  "Ruby"
  "C++"
  "VisualStudioCode"
  "macOS"
  "Windows"
  "Linux"
  "JavaScript"
  "Django"
  "Flask"
  "React"
  "Angular"
  "Next.js"
  "Laravel"
  "Unity"
  "Terraform"
  "Docker"
  "Kubernetes"
  "Ansible"
  "Jenkins"
  "GitLabCI"
  "GitHubActions"
  "Helm"
  "Vagrant"
  "CircleCI"
)

function display_menu() {
  echo "Select one or more stacks (space-separated numbers), or type 'c' for custom input:"
  for i in "${!COMMON_STACKS[@]}"; do
    printf "%2d) %s\n" $((i+1)) "${COMMON_STACKS[$i]}"
  done
  echo " c) Custom (type your own comma-separated values)"
}

function get_user_input() {
  read -p "Your choice: " input
  if [[ "$input" == "c" ]]; then
    read -p "Enter custom values (comma-separated, e.g., 'python,vscode,windows'): " custom
    STACKS=$(echo "$custom" | tr '[:upper:]' '[:lower:]')
  else
    selected=()
    for index in $input; do
      if [[ "$index" =~ ^[0-9]+$ ]] && ((index > 0 && index <= ${#COMMON_STACKS[@]})); then
        selected+=("${COMMON_STACKS[$((index-1))]}")
      fi
    done
    STACKS=$(IFS=,; echo "${selected[*]}" | tr '[:upper:]' '[:lower:]')
  fi
}

function generate_gitignore() {
  echo "Generating .gitignore for: $STACKS"
  curl -sL "https://www.toptal.com/developers/gitignore/api/$STACKS" -o .gitignore
  if [[ $? -eq 0 ]]; then
    echo ".gitignore successfully created."
  else
    echo "Failed to fetch .gitignore. Please check your internet connection or input."
    exit 1
  fi
}

function offer_readme_note() {
  if [[ -f README.md ]]; then
    read -p "Do you want to append a note to README.md about .gitignore? (y/n): " yn
    if [[ "$yn" == "y" ]]; then
      echo -e "\n> ⚙️ This project uses a .gitignore for: ${STACKS//,/ | } (via gitignore.io)" >> README.md
      echo "Note added to README.md"
    fi
  fi
}

# ---- Main Execution ----
display_menu
get_user_input
generate_gitignore
offer_readme_note
