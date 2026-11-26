#!/bin/bash
# SPDX-FileCopyrightText: 2026 Rihito Sakai
# SPDX-License-Identifier: BSD-3-Clause

ng () {
    echo "${1}行目のテスト失敗"
    res=1
}
res=0
tmp=$(mktemp -d)
export HOME="$tmp"
export TERM=dumb

./clearx --record 0 "pwd"
[ "$?" = 0 ] || ng "$LINENO"
out=$(./clearx)
echo "$out" | grep -Fq '$ pwd' || ng "$LINENO"
./clearx --record 1 "invalid_command"
[ "$?" = 0 ] || ng "$LINENO"
out=$(./clearx)
echo "$out" | grep -Fq 'invalid_command' && ng "$LINENO"
./clearx --record 0 ""
[ "$?" = 0 ] || ng "$LINENO"
out=$(./clearx)
[ "$(echo "$out" | grep -c '^\$ ')" = 1 ] || ng "$LINENO"
for i in 1 2 3 4 5 6
do
    ./clearx --record 0 "command$i"
    sleep 0.01
done
out=$(./clearx)

echo "$out" | grep -Fq 'command1' && ng "$LINENO"
echo "$out" | grep -Fq 'command2' || ng "$LINENO"
echo "$out" | grep -Fq 'command6' || ng "$LINENO"

[ "$(echo "$out" | grep -c '^\$ ')" = 5 ] || ng "$LINENO"
[ "$res" = 0 ] && echo OK
rm -rf "$tmp"
exit "$res"
