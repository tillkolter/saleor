

.PHONY: logs

# update sql
dump-db:
	ssh till@oye-records.com 'bash ./dump-oye.sql'
# copy-data:

copy-db:
	scp till@oye-records.com:/home/till/oye-dump.sql oye-dump.sql

import-db:
	mysql -u oye_test -p oye_test oye_test <

update-db: dump-db copy-db

clean:
	docker rmi -f $(docker images --filter "dangling=true" -q --no-trunc)

build:
	DOCKER_BUILDKIT=1 docker build --no-cache --ssh github_ssh_key=/Users/tkolter/.ssh/id_ed25519 . -t oyelogic:latest

build-cached:
	DOCKER_BUILDKIT=1 docker build --ssh github_ssh_key=/Users/tkolter/.ssh/id_ed25519 . -t oyelogic:latest

fresh-build: clean build

up:
	docker-compose up -d

up-with-media:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

logs:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f

shell:
	docker exec -it saleor-web-1 bash -c './manage.py shell_plus'

test:
	docker exec -it saleor-web-1 bash -c 'IS_TESTING=True REMOTE=False ./manage.py test --noinput saleor_oye.graphql.tests.test_profile.ProfileGraphTest'
