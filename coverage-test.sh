#!/bin/sh
# taken from https://stackoverflow.com/a/53663093
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html