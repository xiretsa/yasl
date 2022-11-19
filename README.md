# YASL: Yet Another Shell Logger

Simple logger for Linux shell.

## Usage

You can call the function `yasl` with two parameters:

1. the log message (mandatory).
2. the log level (optional). Will be INFO if missing.

```shell
$ yasl "test message with default level"
2022-11-17T16:53:55+01:00 INFO test message with default level
$ yasl "test message with debug level" "DEBUG"
2022-11-17T16:53:55+01:00 DEBUG test message with debug level
```

## Configuration

The minimum log level to display is defined by the environment variable `YASL_ROOT_LEVEL`. The default value is INFO.

Log with level lesser than the root level will be ignored.

## Levels

Supported levels are:

- TRACE
- DEBUG
- INFO
- WARN
- ERROR
- FATAL

## Send to UDP

To enable log over UDP, you should define these environment variables:

- **YASL_UDP_ENABLED**: set to true to enable UDP logs.
- **YASL_UDP_HOSTNAME**: UDP server hostname.
- **YASL_UDP_PORT**: UDP server port.

Optionally, you can used also these variables:

- **YASL_ENVIRONMENT**: name of the environment.
- **YASL_APPLICATION**: an application name.
- **YASL_ROOT_LEVEL**: the minimum log level to display. Default: INFO. Log with level lesser than the root level will be ignored.

The payload will be a json with these fields:

- **instance**: the hostname of the sender.
- **env**: with the value of the variable `YASL_ENVIRONMENT`.
- **app**: with the value of the variable `YASL_APPLICATION`.
- **datetime**: ISO date time for the logged message.
- **level**: the log level.
- **message**: the log message.
