1- docker build -t "name" .
2- docker run -d -t -p 80:80 -p 443:443 --name "othername" "name"
3- 172.17.0.2/mipagina
4- 172.17.0.2/mipagina/wordpress
5- 172.17.0.2/mipagina/phpmyadmin
6- docker stop "othername"
7- docker rm "othername"
