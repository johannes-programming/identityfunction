.ONESHELL:
.PHONY: all add amend beautiful beautiful-other beautiful-py beautiful-toml black build canonicalize clean commit commit-version dist echo isort jacobus jacobus-other jacobus-py jacobus-toml make-identityfunction out py311 py312 py313 py314 py315 pypi pyproject-fmt rebase reset ruff test toml-sorted upload version
SHELL := /bin/zsh

all: beautiful commit-version

add:
	git add -A;

amend: add
	git commit --amend --no-edit;

beautiful: beautiful-other beautiful-py beautiful-toml

beautiful-other: jacobus-other

beautiful-py: jacobus-py ruff

beautiful-toml: canonicalize toml-sorted pyproject-fmt

black: make-identityfunction
	conda run -n make-identityfunction pip install 'black>=24.5,<26' >/dev/null;
	conda run -n make-identityfunction black --line-length=79 . ;

build: beautiful make-identityfunction
	conda run -n make-identityfunction pip install 'build>=1.3,<2' >/dev/null;
	conda run -n make-identityfunction python -m build;

canonicalize: make-identityfunction
	conda run -n make-identityfunction pip install -e make/canonicalize;
	conda run -n make-identityfunction python -m canonicalize -- .;

clean:
	rm -fr 'dist/';
	rm -fr 'out/';

commit: add
	git commit --allow-empty $(PARAMS);

commit-version: add make-identityfunction
	conda run -n make-identityfunction pip install 'toml-get<2,>=1.1' >/dev/null;
	git commit --allow-empty "$$(conda run -n make-identityfunction python -m toml_get @make/toml_get.txt)";

dist: clean build

echo:
	echo $(PARAMS);

isort: make-identityfunction
	conda run -n make-identityfunction pip install 'isort<7,>=6.0' >/dev/null;
	conda run -n make-identityfunction isort . ;

jacobus: jacobus-other jacobus-py jacobus-toml

jacobus-other: make-identityfunction
	conda run -n make-identityfunction pip install 'jacobus>=2.5,<3' >/dev/null;
	conda run -n make-identityfunction python -m jacobus @make/jacobus_empty.txt;
	cat make/manifest.txt >> MANIFEST.in;
	conda run -n make-identityfunction python -m jacobus @make/jacobus_sort.txt;
	conda run -n make-identityfunction python -m jacobus @make/jacobus_other_indent.txt;

jacobus-py: make-identityfunction
	conda run -n make-identityfunction pip install 'jacobus>=2.5,<3' >/dev/null;
	conda run -n make-identityfunction python -m jacobus @make/jacobus_py.txt;

jacobus-toml: make-identityfunction
	conda run -n make-identityfunction pip install 'jacobus>=2.5,<3' >/dev/null;
	conda run -n make-identityfunction python -m jacobus @make/jacobus_toml.txt;

make-identityfunction:
	conda run -n base python make/env.py --python=3.11 -- make-identityfunction;

out:
	mkdir -p dist/out/;

py311:
	conda run -n base python make/env.py --python=3.11 -- py311;

py312:
	conda run -n base python make/env.py --python=3.12 -- py312;

py313:
	conda run -n base python make/env.py --python=3.13 -- py313;

py314:
	conda run -n base python make/env.py --python=3.14 -- py314;

py315:
	conda run -n base python make/env.py --python=3.15 -- py315;

pypi: dist upload

pyproject-fmt: make-identityfunction
	conda run -n make-identityfunction pip install "pyproject-fmt<3,>=2.30";
	conda run -n make-identityfunction pyproject-fmt pyproject.toml >/dev/null 2>/dev/null || conda run -n make-identityfunction pyproject-fmt --check pyproject.toml;
	conda run -n make-identityfunction pyproject-fmt make/canonicalize/pyproject.toml >/dev/null 2>/dev/null || conda run -n make-identityfunction pyproject-fmt --check pyproject.toml;

rebase:
	git rebase --empty=drop --interactive $(PARAMS);

reset:
	git reset HEAD~1;

ruff: make-identityfunction out
	conda run -n make-identityfunction python -m pip install "ruff>=0.14,<1";
	conda run -n make-identityfunction ruff check --fix . ;
	conda run -n make-identityfunction ruff format . ;

test: dist make-identityfunction out
	conda run -n make-identityfunction pip install "style-checker<0.2,>=0.1.13";
	conda run -n make-identityfunction python -m style_checker -- "**/*.py" > dist/out/style-out.txt 2> dist/out/style-err.txt || true;
	conda run -n base python make/env.py --python=3.11 --recreate -- mypy-identityfunction >/dev/null;
	conda run -n mypy-identityfunction pip install dist/*.tar.gz >/dev/null;
	conda run -n mypy-identityfunction python run_introspection.py > dist/out/introspection-out.txt 2> dist/out/introspection-err.txt || true;
	conda run -n mypy-identityfunction pip install "mypy<3,>=2.4" >/dev/null;
	conda run -n mypy-identityfunction python -m mypy --strict -p identityfunction > dist/out/mypy-pkg-out.txt 2> dist/out/mypy-pkg-err.txt || true;
	conda run -n mypy-identityfunction python -m mypy --exclude build --exclude dist --exclude make --strict . > dist/out/mypy-dir-out.txt 2> dist/out/mypy-dir-err.txt || true;
	conda run -n make-identityfunction pip install "mypy<3,>=2.4" >/dev/null;
	conda run -n make-identityfunction python -m mypy --strict -- make > dist/out/mypy-make-out.txt 2> dist/out/mypy-make-err.txt || true;
	conda run -n base python make/env.py --python=3.11 --recreate tests-identityfunction >/dev/null;
	conda run -n tests-identityfunction pip install dist/*.tar.gz >/dev/null;
	conda run -n tests-identityfunction python run_tests.py > dist/out/tests-out.txt 2> dist/out/tests-err.txt || true;
	zip -r dist/out.zip dist/out;

toml-sorted: make-identityfunction
	conda run -n make-identityfunction pip install 'toml-sorted>=2.2,<3' >/dev/null;
	conda run -n make-identityfunction python -m toml_sorted '**/*.toml';
	conda run -n make-identityfunction python -m toml_sorted @make/toml_sorted_pyproject.txt;

upload: make-identityfunction
	conda run -n make-identityfunction pip install 'twine>=5.2,<7' >/dev/null;
	conda run -n make-identityfunction twine upload 'dist/*';

version: all pypi
