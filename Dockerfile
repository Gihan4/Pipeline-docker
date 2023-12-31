FROM python:3.8

# set a directory for the app destination in docker
WORKDIR /usr/src/app

# copy all the files to the container
COPY . .

# install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# define the port number the container should expose
EXPOSE 5000

# run the command everytime the container starts
CMD ["flask", "run", "--host=0.0.0.0"]
