#!/bin/sh
# Since string manipulations in bash can't be nested, temporary variables are necessary.

a="$(acpi -t)"
a="${a#*, }"
a="${a% d*}"

echo "$a°C"
