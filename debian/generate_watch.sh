#!/bin/bash## @license GPL-3.0 <https://www.gnu.org/licenses/gpl-3.0.html>

cd "$( dirname "${BASH_SOURCE[0]}" )/.." || exit

echo 'version=4'
echo

(
	find  ./ -type f -name '*.yml' -print0 | xargs --null egrep --no-filename -e '^\s*-\s?role:\s?[^/]+$$' | sed --regexp-extended 's/.*?:\s+//'
	test -r galaxy/requirements-manual.txt && grep --invert-match '^\s*#' galaxy/requirements-manual.txt
) | sort -u | sed 's#debops\.#ansible-#' | while read line ; do
   echo 'opts=component=role-'$line',\'
   echo ' filenamemangle=s/.+\/v?(\d\S+)\.tar\.gz/debops-role-'$line'_$1\.tar\.gz/ \'
   echo ' https://github.com/debops/'$line'/releases .*/v?(\d\S+)\.tar\.gz ignore'
   echo 
done

echo 'opts=\
filenamemangle=s/.+\/v?(\d\S+)\.tar\.gz/debops-playbooks_$1\.tar\.gz/ \
  https://github.com/debops/debops-playbooks/releases .*/v?(\d\S+)\.tar\.gz 0.1 uupdate'

