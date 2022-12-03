.PHONY: notebook docs
.EXPORT_ALL_VARIABLES:


activate:
	@echo "Activating virtual environment"
	conda activate comend_NN

install: activate
	@echo "Installing dependencies... "
	conda run -n comend_NN pip install -r requirements.txt
	@echo "Done Installing packages!"

initialize_git:
	git init 
	conda run -n comend_NN pre-commit install 

pull_data:
	conda run -n comend_NN pip run dvc pull

setup:
	@echo "Installing... "
	conda env create --file env.yml
	@echo "Activating virtual environment"
	conda activate comend_NN
	@echo "Conda environment initialized succesfully!"
	install 
	initialize_git

test:
	pytest

docs_view:
	@echo View API documentation... 
	pdoc src --http localhost:8080

docs_save:
	@echo Save documentation to docs... 
	pdoc src -o docs

## Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete
	rm -rf .pytest_cache