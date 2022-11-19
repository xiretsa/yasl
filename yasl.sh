#!/usr/bin/env sh

#
# Copyright 2022 Pierre Faucquenoy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

YASL_UDP_ENABLED=$(echo "${YASL_UDP_ENABLED:-false}" | tr '[:upper:]' '[:lower:]')

YASL_ROOT_LEVEL="${YASL_ROOT_LEVEL:-INFO}"
YASL_ROOT_LEVEL=$(printf "%s" "${YASL_ROOT_LEVEL}" | tr '[:lower:]' '[:upper:]')

yasl() {
  _yasl_message_to_log="${1:?Message to log  is mandatory}"
  _yasl_message_to_log_level="${2:-INFO}"
  _yasl_message_to_log_level=$(printf "%s" "${_yasl_message_to_log_level}" | tr '[:lower:]' '[:upper:]')
  _yasl_message_date_time="$(date -Iseconds)"
  _yasl_message_to_log_level_code="$(yasl_get_level_code "$_yasl_message_to_log_level")"
  if [ "${_yasl_message_to_log_level_code}" -ge "${_YASL_ROOT_LEVEL_CODE}" ] ; then
    printf "%s %s %s\n" "${_yasl_message_date_time}" "${_yasl_message_to_log_level}" "${_yasl_message_to_log}"
    if [ "$YASL_UDP_ENABLED" = "true" ] ; then
      yasl_to_udp "${_yasl_message_date_time}" "${_yasl_message_to_log_level}" "${_yasl_message_to_log}"
    fi
  fi
}

yasl_to_udp() {
  YASL_UDP_HOSTNAME="${YASL_UDP_HOSTNAME:?UDP Serveur hostname is mandatory}"
  YASL_UDP_PORT="${YASL_UDP_PORT:?UDP Server port is mandatory}"
  _yasl_to_udp_message_time="${1:?Message date time is mandatory}"
  _yasl_to_udp_message_to_log_level="${2:?Log level is mandatory}"
  _yasl_to_udp_message_to_log="${3:?Message to log  is mandatory}"
  printf "{\"instance\": \"%s\", \"env\": \"%s\", \"app\": \"%s\", \"datetime\": \"%s\", \"level\": \"%s\", \"message\": \"%s\"}" \
      "$(hostname)" "${YASL_ENVIRONMENT:-not specified}" "${YASL_APPLICATION:-not specified}" "${_yasl_to_udp_message_time}" "${_yasl_to_udp_message_to_log_level}" "${_yasl_to_udp_message_to_log}" \
      | nc -u -w1 "${YASL_UDP_HOSTNAME}" "${YASL_UDP_PORT}"
}

yasl_get_level_code() {
  _yasl_get_level_code_level="${1:?Level is mandatory}"
  case "${_yasl_get_level_code_level}" in
    TRACE) echo 1;;
    DEBUG) echo 2;;
    INFO) echo 3;;
    WARN) echo 4;;
    ERROR) echo 5;;
    FATAL) echo 6;;
    *) yasl "Unknown log level ${_yasl_get_level_code_level}" ; echo 5;;
  esac
}

_YASL_ROOT_LEVEL_CODE="$(yasl_get_level_code "$YASL_ROOT_LEVEL")"
