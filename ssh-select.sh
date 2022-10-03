#!/bin/sh
# ssh-select: Select an SSH key to `ssh-add`
# Copyright (C) 2022 Justin Godesky
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -o errexit -o nounset -o noclobber -o pipefail
shopt -s nullglob

# List files that are probably SSH keys, filtering out ones that probably aren't.
FILES_IN_SSH_DIR=$(find ~/.ssh -type f -not -name "*.pub" \
                                       -not -name "known_hosts" \
                                       -not -name "config" \
                                       -not -name "environment")
ARR=($FILES_IN_SSH_DIR)

# Print choices
N=0
for file in $FILES_IN_SSH_DIR
do
  N=$(expr $N + 1)
  echo "$N) $file"
done

# Prompt choice from above
CHOICE=""
read -p "Select option: " CHOICE 
if [ "$CHOICE" = "" ]; then
  # If no choice, then it will try each one in sequence, asking for a password. 
  ssh-add $FILES_IN_SSH_DIR
else
  # If a choice was provided, it will try just that one.
  ssh-add  ${ARR[$(expr $CHOICE - 1)]} 
fi
