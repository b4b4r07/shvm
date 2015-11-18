source $(dirname $BASH_SOURCE)/../test_helper.sh

setup() {
  tmpdir=$(mktemp -d)
  export BASHVM_HOME=$tmpdir
}

teardown() {
  rm -rf "$tmpdir"
}

testcase_uninstall_installed_version() {
  mkdir $BASHVM_HOME/bash-X.Y
  subject bashvm uninstall X.Y
  assert_false test -d "$BASHVM_HOME/bash-X.Y"
}

testcase_uninstall_gone_version() {
  subject bashvm uninstall su.shi
  assert_match "gone" "$stdout"
  assert_equal 1 $status
}
