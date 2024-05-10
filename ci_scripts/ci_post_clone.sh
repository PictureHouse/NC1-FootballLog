#!/bin/sh

#  ci_post_clone.sh
#  FootballLog
#
#  Created by Yune Cho on 5/10/24.
#

FOLDER_PATH = "/Volumes/workspace/repository/FootballLog/Config.xcconfig"

CONFIG_FILENAME = "Config.xcconfig"

CONFIG_FILE_PATH = "$FOLDER_PATH / $CONFIG_FILENAME"

echo "APIKey = $APIKey" >> "$CONFIG_FILE_PATH"

cat "$CONFIG_FILE_PATH"

echo "Config.xcconfig"
