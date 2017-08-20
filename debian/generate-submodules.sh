#!/bin/bash## @license GPL-3.0 <https://www.gnu.org/licenses/gpl-3.0.html>

cd "$( dirname "${BASH_SOURCE[0]}" )/../roles" || exit

(
	find  ../ -type f -name '*.yml' -print0 | xargs --null egrep --no-filename -e '^\s*-\s?role:\s?[^/]+$$' | sed --regexp-extended 's/.*?:\s+//'
	test -r galaxy/requirements-manual.txt && grep --invert-match '^\s*#' galaxy/requirements-manual.txt
	cd roles/
) | sort -u | sed 's#debops\.#ansible-#' | while read line ; do
   git submodule add https://github.com/debops/$line
done
