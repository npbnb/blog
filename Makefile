include common_parameters.env
export

SHELL = /bin/sh
CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)
export CURRENT_UID
export CURRENT_GID

## help	:	Print help info
help : Makefile
	@sed -n 's/^##//p' $<

## clean	:	Clean temporary files
clean:
	find . -type d -name "_site" -exec rm -rf {} +
	find . -type d -name ".quarto" -exec rm -rf {} +
	find . -type d -name ".pixi" -exec rm -rf {} +
	find . -type d -name "index_files" -exec rm -rf {} +
	find . -type d -name "index_cache" -exec rm -rf {} +

## create_conda : Build the base "code4np_base" docker image
build_docker_dev:
	docker build -t code4np_base:dev site_utils

## render:	Render a post (e.g. make render posts/example_dir/index.ipynb)
render: build_docker_dev
	mkdir -p $(realpath $(dir $(filter-out $@,$(MAKECMDGOALS))))/index_files $(realpath $(dir $(filter-out $@,$(MAKECMDGOALS))))/index_cache && \
	docker run -it \
		-v $(realpath $(dir $(filter-out $@,$(MAKECMDGOALS)))):/repo \
		-u $(shell id -u):$(shell id -g) \
		code4np_base:dev \
		/bin/bash -c 'pixi run quarto render $(notdir $(filter-out $@,$(MAKECMDGOALS)))'




## render_all_posts :	Render all posts
render_all_posts: build_docker_dev
		for i in $$(find posts -name "index.ipynb" -o -name "index.qmd"); do \
			echo "Rendering file: $$(basename $$(dirname $${i}))" && \
			mkdir -p $$(dirname $${i})/index_files $$(dirname $${i})/index_cache && \
			docker run -it \
				-u $(shell id -u):$(shell id -g) \
				-v $$(realpath $$(dirname $${i})):/repo \
				-w /repo \
				code4np_base:dev \
				/bin/bash -c "pixi run quarto render $$(basename $${i}) --execute-dir=/repo" ; \
		done

## render_site :	Render the site
render_site: build_docker_dev
	docker run -it \
		-v ${PWD}:/repo \
		$$(docker build -q ${PWD}/site_utils) \
		/bin/bash -c 'pixi run quarto render /repo'

## preview :	Preview the blog
preview: build_docker_dev
	docker run -it \
		-v ${PWD}:/repo \
		-p 4321:4321 \
		code4np_base:dev \
		/bin/bash -c 'quarto preview /repo --port 4321 --host 0.0.0.0 '

## destroy :	Delete the site and quarto files
destroy:
	find . -type d -name "_site" -exec rm -r {} +
	find . -type d -name ".quarto" -exec rm -r {} +

## confidently_destroy :	Delete the site and quarto files and freeze and environment files
confidently_destroy: destroy
	find . -type d -name "_freeze" -exec rm -r {} +
	find . -type d -name ".pixi" -exec rm -r {} +
	 +


# https://stackoverflow.com/a/6273809/1826109
%:
	@:
###########################################################################################################
###########################################################################################################
