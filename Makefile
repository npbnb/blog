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
	find . -type d -name "_site" -exec rm -r {} +
	find . -type d -name ".quarto" -exec rm -rf {} +
	find . -type d -name ".pixi" -exec rm -r {} +

## create_conda : Build the base "code4np_base" docker image
build_docker_dev:
	docker build -t code4np_base:dev site_utils
	
## render :	Render a post (e.g. make render posts/example_post_3_jupyter/index.ipynb)
render: build_docker_dev
	docker build -t code4np-$$(basename $$(dirname $(filter-out $@,$(MAKECMDGOALS)))) $(dir $(filter-out $@,$(MAKECMDGOALS)))
	# use the tagged image just built
	docker run -it \
		-v ${PWD}:/repo \
		-u $$(id -u):$$(id -g) \
		code4np-$$(basename $$(dirname $(filter-out $@,$(MAKECMDGOALS)))) \
		/bin/bash -c 'pixi run quarto render /repo/$(filter-out $@,$(MAKECMDGOALS))'	

## render_all_posts :	Render all posts 
render_all_posts: build_docker_dev
		for i in $$(find posts -name "index.ipynb" -o -name "index.qmd"); do \
			echo "Rendering file: $$(basename $$(dirname $${i}))" && \
			echo "$$(basename $$i)" && \
			docker build -t code4np-$$(basename $$(dirname $${i})) $$(dirname $${i}) && \
			docker run -it \
				-u 1000:1000 \
				-v ${PWD}:/repo \
				code4np-$$(basename $$(dirname $${i})) \
				/bin/bash -c "pixi run --frozen --manifest-path $$(dirname $${i})/pixi.toml quarto render $${i}" ; \
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
