Each blog post will have its own directory
A blog post can be written as a quarto or jupyter notebook
The directory should contain a dockerfile used to build/run the notebook

# Building a post

There's a base Ubuntu docker image that contains Quarto and Jupyter; it lives at `site_utils/base_dockerfile`.

It can be built locally:
```
pushd site_utils
docker build -f base_dockerfile . -t chasemc2/npbnb:0.0.1
popd
```

Your post should contain its own `Dockerfile` that should be built on top the base Docker image above and contain all the dependencies to run your notebook.

Then in your post directory:

```
pushd posts/example_post_1
docker build . -t npbnb_post
docker run -v $PWD:/blog  npbnb_post quarto render blog/index.qmd
popd
```




# If you've written a post as a Jupyter notebook

```
pushd posts/example_post_3_jupyter
docker build . -t npbnb_post
docker run -v $PWD:/blog  npbnb_post quarto convert blog/index.ipynb --output blog/index.qmd
```

Adjust the header block of the resulting .qmd file then render

```
docker run -v $PWD:/blog npbnb_post quarto render blog/index.qmd
popd
```

