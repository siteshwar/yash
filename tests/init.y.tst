# option.y.tst: yash-specific test of shell options
# vim: set ft=sh ts=8 sts=4 sw=4 noet:

TESTTMP="${TESTTMP}/option.y.tmp"
export TESTTMP
mkdir -p "$TESTTMP"

cat >"${TESTTMP}/.yash_profile" <<\END
echo profile 1
. -- "${TESTTMP}/file1"
echo profile 2
. -- "${TESTTMP}/file2"
echo profile 3
END
cat >"${TESTTMP}/.yashrc" <<\END
echo yashrc 1
. -- "${TESTTMP}/file1"
echo yashrc 2
. -- "${TESTTMP}/file2"
echo yashrc 3
END
cat >"${TESTTMP}/file1" <<\END
echo file 1
END
cat >"${TESTTMP}/file2" <<\END
echo file 2
END
cat >"${TESTTMP}/file3" <<\END
echo file 3
END
cat >"${TESTTMP}/error1" <<\END
echo error 1
. "${TESTTMP}/error2"
echo error 1 syntax error \$\?=$?
unset var
echo ${var?}
echo error 1 expansion error \$\?=$?
fi
echo not reached
END
cat >"${TESTTMP}/error2" <<\END
echo error 2
unset var
echo ${var?}
echo error 2 expansion error \$\?=$?
fi
echo not reached
END

export HOME= ENV=

echo ===== 1 =====
echo ===== 1 ===== >&2

HOME="${TESTTMP}" $INVOKE $TESTEE -l -c 'echo main'

echo ===== 2 =====
echo ===== 2 ===== >&2

HOME="${TESTTMP}" $INVOKE $TESTEE --log-in -c 'echo main'

echo ===== 3 =====
echo ===== 3 ===== >&2

$INVOKE $TESTEE -l --profile="${TESTTMP}/file1" -c 'echo main'

echo ===== 4 =====
echo ===== 4 ===== >&2

HOME="${TESTTMP}" $INVOKE $TESTEE -i +m -c 'echo main'

echo ===== 5 =====
echo ===== 5 ===== >&2

HOME="${TESTTMP}" $INVOKE $TESTEE --interactive --nomonitor -c 'echo main'

echo ===== 6 =====
echo ===== 6 ===== >&2

$INVOKE $TESTEE -i --rcfile="${TESTTMP}/file1" +m -c 'echo main'

echo ===== 7 =====
echo ===== 7 ===== >&2

HOME="${TESTTMP}" $INVOKE $TESTEE -il --profile="${TESTTMP}/file1" +m -c 'echo main'

echo ===== 8 =====
echo ===== 8 ===== >&2

HOME="${TESTTMP}" $INVOKE $TESTEE -il --rcfile="${TESTTMP}/file2" +m -c 'echo main'

echo ===== 9 =====
echo ===== 9 ===== >&2

HOME="${TESTTMP}" $INVOKE $TESTEE -il --profile="${TESTTMP}/file1" +m --rcfile="${TESTTMP}/file2" -c 'echo main'

echo ===== 10 =====
echo ===== 10 ===== >&2

HOME="${TESTTMP}" $INVOKE $TESTEE -c 'echo main'

echo ===== 11 =====
echo ===== 11 ===== >&2

HOME="${TESTTMP}" $INVOKE $TESTEE -il --profile="${TESTTMP}/file1" --norcfile +m -c 'echo main'

echo ===== 12 =====
echo ===== 12 ===== >&2

HOME="${TESTTMP}" $INVOKE $TESTEE -il --noprofile --rcfile="${TESTTMP}/file2" +m -c 'echo main'

echo ===== 13 =====
echo ===== 13 ===== >&2

HOME="${TESTTMP}" ENV='${HOME}/file3' $INVOKE $TESTEE --posix -c 'echo main'

echo ===== 14 =====
echo ===== 14 ===== >&2

HOME="${TESTTMP}" ENV='${HOME}/file3' $INVOKE $TESTEE --posix -ci +m 'echo main'

: =========================================================================== :

echo ===== error 1 =====
echo ===== error 1 ===== >&2

$INVOKE $TESTEE -l --profile="${TESTTMP}/error1" -c 'echo main' 2>/dev/null

echo ===== error 2 =====
echo ===== error 2 ===== >&2

$INVOKE $TESTEE -i --rcfile="${TESTTMP}/error1" +m -c 'echo main' 2>/dev/null

: =========================================================================== :

export HOME="${TESTTMP}/no.such.directory"
unset ENV

echo ===== non-existing 1 =====
echo ===== non-existing 1 ===== >&2

$INVOKE $TESTEE --posix -ci +m 'echo main'

echo ===== non-existing 2 =====
echo ===== non-existing 2 ===== >&2

$INVOKE $TESTEE -cil +m 'echo main'

echo ===== non-existing 3 =====
echo ===== non-existing 3 ===== >&2

(unset HOME && $INVOKE $TESTEE -cil +m 'echo main')

rm -fr "$TESTTMP"