Technology used 
- ruby '2.6.1'
- rails '6.0.0'
- Sqlite (For Develepment database)
- PostgreSQL (For Production database)

Setup
Install dependencies
$ bundle install

create database
$ rails db:create

run migration
$ rails db:migrate

Run test
$ rails test

Heroku link: https://omedale-d-tree.herokuapp.com

Endpoints
1. HTTP GET /:tree_id
 => Return the saved structure
2. HTTP GET /:tree_id/parent/:id
 => Return the list of parents IDs
3. HTTP GET /:tree_id/child/:id
 => Return the list of childs
4. HTTP GET /
 => Create and Return saved tree
