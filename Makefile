.PHONY = clean clean-files clean-docker docker

all : docker node_modules database_up.sql
	sudo docker commit new-products-database erpmicroservices/products-database:latest

docker :
	sudo docker build --tag new-products-database --rm .
	sudo docker run -d --publish 5432:5432 --name new-products-database new-products-database
	sleep 10

node_modules : package.json
	npm install

sql/us-cities.sql : data_massagers/cities.csv
	node data_massagers/create_us_cities_sql.js

sql/us-zip-codes.sql : data_massagers/us-zip-codes.csv
	node data_massagers/create_us_zip_codes.js

database_up.sql : sql/*.sql database_change_log.yml
	liquibase --changeLogFile=./database_change_log.yml --url='jdbc:postgresql://localhost/products-database' --username=products-database --password=products-database --url=offline:postgresql --outputFile=database_up.sql updateSql

clean : clean-docker clean-files

clean-files :
	-$(RM) -rf node_modules
	-$(RM) database_up.sql
	-$(RM) databasechangelog.csv

clean-docker :
	if sudo docker ps | grep -q new-products-database; then sudo docker stop new-products-database; fi
	if sudo docker ps -a | grep -q new-products-database; then sudo docker rm new-products-database; fi
	if sudo docker images | grep -q new-products-database; then sudo docker rmi new-products-database; fi
	if sudo docker images | grep -q erpmicroservices/products-database; then sudo docker rmi erpmicroservices/products-database; fi
