

.PHONY: logs

# update sql
dump-db:
	ssh till@oye-records.com 'bash ./.scripts/dump-oye.sh'
# copy-data:

copy-db:
	scp till@oye-records.com:/home/till/oye-dump.sql oye-dump.sql
	sed -i '' 's/c1wawisys/oye_test/g' oye-dump.sql

copy-chart-images:
	mkdir -p /Users/tkolter/dev-data/oye_media/media/charts
	scp -r till@oye-records.com:/var/www/oye_media/media/charts/. /Users/tkolter/dev-data/oye_media/media/charts
copy-artist-images:
	mkdir -p /Users/tkolter/dev-data/oye_media/media/artists
	scp -r till@oye-records.com:/var/www/oye_media/media/artists/. /Users/tkolter/dev-data/oye_media/media/artists

copy-default-images:
	mkdir -p /Users/tkolter/dev-data/oye_media/default
	mkdir -p /Users/tkolter/dev-data/oye_media/__sized__/default
	mkdir -p /Users/tkolter/dev-data/oye_media/features
	scp -r till@oye-records.com:/var/www/oye_media/media/default/. /Users/tkolter/dev-data/oye_media/default
	scp -r till@oye-records.com:/var/www/oye_media/media/__sized__/default/. /Users/tkolter/dev-data/oye_media/__sized__/default
	scp -r till@oye-records.com:/var/www/oye_media/media/features/. /Users/tkolter/dev-data/oye_media/features

copy-images: copy-chart-images copy-artist-images copy-default-images

import-db: clean-db
	@MYSQL_PWD="very_secure" mysql -u oye_test oye_test < oye-dump.sql

clean-db:
	@MYSQL_PWD="very_secure" mysql -u oye_test oye_test < ./dev/drop-all.sql

update-db: dump-db copy-db import-db

clean:
	docker rmi -f $(docker images --filter "dangling=true" -q --no-trunc)

build:
	DOCKER_BUILDKIT=1 docker build --no-cache --ssh default . -t oyelogic:latest

down:
	DOCKER_BUILDKIT=1 docker-compose down

build-cached:
	DOCKER_BUILDKIT=1 docker build --ssh default . -t oyelogic:latest

fresh-build: clean build

up:
	docker-compose up -d

up-with-media:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

logs:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f

logs-web:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f web

shell:
	docker exec -it saleor-web-1 bash -c './manage.py shell_plus'

test:
	docker exec -it saleor-web-1 bash -c 'IS_TESTING=True REMOTE=False DJANGO_SETTINGS_MODULE=saleor.settings pytest src/saleor-oye/saleor_oye'

schema:
docker exec -it saleor-web-1 bash -c "./manage.py graphql_schema --out=-" > ../nuxt-oye-records/graphql.schema.json
