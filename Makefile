.ONESHELL:
.PHONY: all beautiful black build canonicalize clean commit-version dist isort jacobus py311 py312 py313 py314 py315 pypi reset test toml_sorted_pyproject upload version

all: beautiful commit-version

beautiful: canonicalize isort black jacobus toml_sorted_pyproject

black: py311
	conda run -n py311 pip install 'black>=24.5,<26';
	conda run -n py311 black --line-length=79 . ;

build: py311 beautiful
	conda run -n py311 pip install 'build>=1.3,<2';
	conda run -n py311 python -m build;

canonicalize: py311
	conda run -n py311 python make/canonicalize.py -- .;

clean:
	rm -fr 'dist/';

commit-version: py311
	git add -A;
	conda run -n py311 pip install 'toml-get>=1.0,<2';
	git commit --allow-empty "$$(conda run -n py311 python -m toml_get @make/toml_get.txt)";

dist: clean build

isort: py311
	conda run -n py311 pip install 'isort>=6.0,<7';
	conda run -n py311 isort . ;

jacobus: py311
	conda run -n py311 pip install 'jacobus>=2.4,<3';
	conda run -n py311 python -m jacobus @make/jacobus.txt;

py311:
	conda run -n base python make/env.py py311 --python=3.11;

py312:
	conda run -n base python make/env.py py312 --python=3.12;

py313:
	conda run -n base python make/env.py py313 --python=3.13;

py314:
	conda run -n base python make/env.py py314 --python=3.14;

py315:
	conda run -n base python make/env.py py315 --python=3.15;

pypi: clean build upload

reset:
	git reset HEAD~1;

test: dist py311
	mkdir dist/out/ ;
	conda run -n py311 pip install "style-checker>=0.1.5,<0.2";
	conda run -n py311 python -m style_checker -- "**/*.py" > dist/out/style_checker_out.txt 2> dist/out/style_checker_err.txt || true;
	conda run -n base python make/env.py test_identityfunction_mypy --python=3.11 --recreate >/dev/null;
	conda run -n test_identityfunction_mypy pip install dist/*.tar.gz >/dev/null;
	conda run -n test_identityfunction_mypy python make/run_introspection.py > dist/out/introspection_out.txt 2> dist/out/introspection_err.txt || true;
	conda run -n test_identityfunction_mypy pip install mypy >/dev/null;
	conda run -n test_identityfunction_mypy python -m mypy --exclude build --exclude dist --strict . > dist/out/mypy_dir_out.txt 2> dist/out/mypy_dir_err.txt || true;
	conda run -n test_identityfunction_mypy python -m mypy --strict -p identityfunction > dist/out/mypy_pkg_out.txt 2> dist/out/mypy_pkg_err.txt || true;
	conda run -n base python make/env.py test_identityfunction_tests --python=3.11 --recreate >/dev/null;
	conda run -n test_identityfunction_tests pip install dist/*.tar.gz >/dev/null;
	conda run -n test_identityfunction_tests python run_tests.py > dist/out/tests_out.txt 2> dist/out/tests_err.txt || true;
	zip -r dist/out.zip dist/out;

toml_sorted_pyproject: py311
	conda run -n py311 pip install 'toml-sorted>=2.2,<3';
	conda run -n py311 python -m toml_sorted @make/toml_sorted_pyproject.txt;

upload: py311
	conda run -n py311 pip install 'twine>=5.2,<7';
	conda run -n py311 twine upload 'dist/*';

version: all pypi
