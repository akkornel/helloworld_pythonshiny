# vim: ts=2 sw=2 noet

# Python makes Docker images available, using Debian as a base.
# We'll use the latest 3.12, on top of the latest Debian bookworm.
FROM python:3.12-bookworm

# Start with an apt-get upgrade, to update Ubuntu packages
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Install nginx
RUN apt-get install -y nginx && apt-get clean

# Set up a venv, then install pipenv
# NOTE: The pass /usr/local/src/myscripts came from Rocker's image.
# It's a neat path; let's keep it.
RUN python -m venv /usr/local/src/myscripts && \
	/usr/local/src/myscripts/bin/pip install --upgrade pip && \
	/usr/local/src/myscripts/bin/pip install pipenv

# Copy the nginx config file
COPY nginx_config /etc/nginx/sites-available/default

# Copy just the requirements.txt and Pipfiles into the image
# The code might change a lot, but the Pipfiles probably won't.
# Leaving the code until last helps minimize the number of layers that need to
# be rebuilt.
COPY Pipfile Pipfile.lock /usr/local/src/myscripts

# Pipenv looks for a Pipfile in the workdir, so set that.
WORKDIR /usr/local/src/myscripts

# Install modules from the Pipfile.lock
RUN /usr/local/src/myscripts/bin/pipenv install --deploy && \
	/usr/local/src/myscripts/bin/pipenv --clear

# All of the app's code is in the app directory, so copy that into the image.
COPY app /usr/local/src/myscripts/app

# Declare the environment variables we want, and set some default values.
ENV TZ US/Pacific

# When the container is run without an explicit command, this is what we do:
# Start our Shiny app!  Listen on port 3838, and expose that to the outside.
EXPOSE 3838
#CMD ["/usr/local/src/myscripts/bin/pipenv", "run", "shiny", "run", "--app-dir=app", "--host=0.0.0.0", "--port=3838", "--log-level=debug"]
ENV PYTHONPATH=/usr/local/src/myscripts/app
ENV DEBUG=TRUE
CMD ["/usr/local/src/myscripts/bin/pipenv", "run", "uvicorn", "--host=0.0.0.0", "--port=3838", "--log-level=debug", "app:app"]
