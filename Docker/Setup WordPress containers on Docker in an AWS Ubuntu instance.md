# Setting up WordPress containers on Docker in an AWS Ubuntu instance.

1. Launch the AWS instance with an Ubuntu image and select the HTTP port to be open, along with the key pair.

2. Launch the terminal on your local machine and run the SSH command to connect to the EC2 instance:
```bash
  ssh -i "keypair.pem" ubuntu@instance_public_ip
```

3. Install docker: 
```bash
sudo apt-get update
sudo apt-get install docker.io -y
```
4. Install & start MySql Container
```bash
sudo docker run -d --name mysqlcontainer -e MYSQL_ROOT_PASSWORD=Pass@123 -e MYSQL_DATABASE=wordpressdb mysql:latest
```
Explanation:

"sudo docker run": This command starts a new Docker container.  
"-d": Runs the container in detached mode (in the background).  
"--name mysqlcontainer": Specifies the name of the container as "mysqlcontainer".  
"-e MYSQL_ROOT_PASSWORD=Pass@123": Sets the root password for MySQL to "Pass@123".  
"-e MYSQL_DATABASE=wordpressdb": Creates a new database named "wordpressdb".  
"mysql:latest": Specifies the MySQL Docker image to use. Here, "latest" is the tag, which pulls the latest version of the MySQL image.

5. Install & Start WordPress Container:
```bash
sudo docker run -d -p 80:80 --name wordpresscontainer -e WORDPRESS_DB_HOST=mysqlcontainer -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=Pass@123 -e WORDPRESS_DB_NAME=wordpressdb wordpress:latest
```
Explanation:

"sudo docker run": Initiates a new Docker container.  
"-d": Runs the container in detached mode.  
"-p 80:80": Maps port 80 of the host machine to port 80 of the container, allowing access to the WordPress site via port 80.  
"--name wordpresscontainer": Names the container "wordpresscontainer".  
"-e WORDPRESS_DB_HOST"=mysqlcontainer: Specifies the hostname of the MySQL container as "mysqlcontainer".  
"-e WORDPRESS_DB_USER"=root: Sets the MySQL username for WordPress as "root".  
"-e WORDPRESS_DB_PASSWORD"=Pass@123: Sets the MySQL password for WordPress as "Pass@123".  
"-e WORDPRESS_DB_NAME"=wordpressdb: Specifies the name of the MySQL database to use for WordPress as "wordpressdb".  
"wordpress:latest": Specifies the WordPress Docker image to use. "latest" pulls the latest version of the WordPress image.

6. Check for installed docker mysql & wordpress images
```bash
ubuntu@ip-172:~$ sudo docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
wordpress    latest    d653f5f8a602   2 weeks ago   685MB
mysql        latest    6f343283ab56   4 weeks ago   632MB
```

7. Check for running docker mysql & wordpress containers
```bash
ubuntu@ip-172:~$ sudo docker ps
CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS          PORTS                               NAMES
1c958eb9292f   wordpress:latest   "docker-entrypoint.s…"   4 minutes ago    Up 4 minutes    0.0.0.0:80->80/tcp, :::80->80/tcp   wordpresscontainer
9fbc4c210173   mysql:latest       "docker-entrypoint.s…"   23 minutes ago   Up 23 minutes   3306/tcp, 33060/tcp                 mysqlcontainer
```

This is how we successfully installed docker MySql & Wordpress containers

Now hit ec2 instance public ip in browser and you can see wordpress initial page.

If you're seeing "Error establishing a database connection", instead of the WordPress initial screen, then both the MySQL and WordPress containers are on the same Docker network. 

You can create a custom Docker network and attach both containers to it:

8. To create custom Docker network: 
```bash
docker network create custom-network
```

To attach both containers:
```bash
docker network connect custom-network mysqlcontainer
docker network connect custom-network wordpresscontainer
```

9. Now hit ec2 instance public ip in browser and you can see wordpress.

This is how you can Setup WordPress containers on Docker in an AWS Ubuntu instance.

