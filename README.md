$> docker build -t "name" .

$> docker run -d -t -p 80:80 -p 443:443 --name "othername" "name"

172.17.0.2/mipagina

172.17.0.2/mipagina/wordpress

172.17.0.2/mipagina/phpmyadmin

$> docker stop "othername"

$> docker rm "othername"
