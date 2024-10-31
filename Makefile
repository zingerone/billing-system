

create_migration:
	migrate create -ext sql -dir migrations -format 200601021504 -tz Asia/Jakarta $(filter-out $@,$(MAKECMDGOALS))

run:
	go run -buildvcs=false ./cmd/ $(filter-out $@,$(MAKECMDGOALS))