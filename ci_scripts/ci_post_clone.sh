#!/bin/sh

#  ci_post_clone.sh
#  FootballLog
#
#  Created by Yune Cho on 5/10/24.
#

FOLDER_PATH="/Volumes/workspace/repository/FootballLog"

#IFS='-' read -ra PARTS <<< "$CI_XCODE_SCHEME"

CONFIG_FILENAME="Config.xcconfig"

CONFIG_FILE_PATH="$FOLDER_PATH/$CONFIG_FILENAME"

echo "APIKey = $APIKey" >> "$CONFIG_FILE_PATH"

cat "$CONFIG_FILE_PATH"

echo "Config.xcconfig 파일이 성공적으로 생성되었고, 환경변수 값이 확인되었습니다."
