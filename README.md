# canvaslms


RUN script/canvas-update script from canvas folder. This will fetch latest code from git hub

Modify domain.yml, database.yml, security.yml configuration files in docker-compose/config folder and 
delete cache_store.yml file.

   In domain.yml provide host name

   In database.yml provide details of database, host and password.

   In security.yml file modify encryption key(this should be atleast 20 character long). 

Open docker-compose.override.yml search for RAILS_ENV and set it to production and provide same ENCRYPTION_KEY as given in security.yml file. 

Create nginx-conf directory in canvas repository and place nginx.conf inside nginx-conf directory.
Place env_setup.sh inside script directory.Replace domain with your own domain name in both file. Provide email id in script.

RUN script/docker-dev-setup.sh script from canvas folder. This will run the script to dockerize canvas.

RUN "docker-compose up -d" to start docker containers

SSH into canvas-web container as root user.
   command for ssh as root: docker exec -it -u 0 < container id of canvas web > bash

RUN env_setup.sh script inside docker.
 
RUN "RAILS_ENV=production bundle exec rake db:migrate"

Restart nginx with "nginx -s reload" command

Exit from container and run "docker commit < container id of canvas web > canvaslms"

Push this image to amazon ecs.

