# docker-dev-env-for-symfony
(Cloned from @juanwilde github)

This repository contains the basic configuration for a complete local environment for Symfony projects

### Content:
- NGINX 1.19 container to handle HTTP requests
- PHP 8.1.1 container to host your Symfony application
- MySQL 8.0 container to store databases
- Postgres 14 container to store databases

(feel free to update any version in `Dockerfiles` and ports in `docker-compose.yml`)

### Installation:
- Run `make build` to create all containers
- Run `make start` to initiate all the containers
- Enter the PHP container with `make ssh-be`
- Install your favourite Symfony version with `composer create-project symfony/skeleton:"6.1.*" my_project_directory`
- Move the content to the root folder with `mv project/* . && mv project/.env .`. This is necessary since Composer won't install the project if the folder already contains data.
- Copy the content from `project/.gitignore` and paste it in the root's folder `.gitignore`
- Remove `project` folder (not needed anymore)
- Navigate to `localhost:1000` so you can see the Symfony welcome page :)

### Alternatively may install:
- Run `make build` to create all the containers
- Run `make start` to initiate all the containers
- Enter the PHP container with `make ssh-be`
- Check the requirements with `symfony check:requirements`
- Install your favourite Symfony version with `symfony new my_project_directory --version="6.1.*"`
  - the version options are: ('lts', 'stable', 'next' or 'previous'
  - the project skeleton options are: ('--demo', '--full', '--webapp' or nothing by the minimum installation)
- Move the content to the root folder with `mv project/* . && mv project/.env .`. This is necessary since Composer won't install the project if the folder already contains data.
- Copy the content from `project/.gitignore` and paste it in the root's folder `.gitignore`
- Remove `project` folder (not needed anymore)
- Navigate to `localhost:1000` so you can see the Symfony welcome page :)


.env configuration by orm and rabbitmq

    ###> doctrine/doctrine-bundle ###
    # DATABASE_URL="sqlite:///%kernel.project_dir%/var/data.db"
    #DATABASE_URL="mysql://root:root@codenip-php81-symfony54-mysql:3306/mysql_symfony?serverVersion=8.0"
    DATABASE_URL="postgresql://user:passwd@codenip-php81-symfony54-postgres:5432/postgres_symfony?serverVersion=14&charset=utf8"
    ###< doctrine/doctrine-bundle ###
    
    ###> symfony/messenger ###
    # Choose one of the transports below
    # MESSENGER_TRANSPORT_DSN=doctrine://default
    MESSENGER_TRANSPORT_DSN=amqp://guest:guest@docker-dev-env-for-symfony-rabbitmq:5672/%2f/messages
    # MESSENGER_TRANSPORT_DSN=redis://localhost:6379/messages
    ###< symfony/messenger ###

Happy coding!

### For testing
- Insert phpunit testing with composer 'composer require --dev phpunit/phpunit symfony/test-pack'
- Run `sf d:m:m -n --env=test` to apply migrations on test enviroment

composer dump-autoload --- when not found files after rename it

If .pem has access problems: 'chmod 644 public.pem private.pem'

#### To php cs-fixer
to install:
    
    composer require --dev friendsofphp/php-cs-fixer
to exec:

    vendor/bin/php-cs-fixer fix src

### SQL Try
https://stackoverflow.com/questions/68380201/booking-system-using-query-builder-and-symfony

```
$subQueryBuilder = $this->getEntityManager()->createQueryBuilder();
        $subQuery = $subQueryBuilder
            ->select('prop.id')
            ->from('App:Reservation', 'reservation')
            ->orWhere('reservation.startDate BETWEEN :checkInDate AND :checkOutDate')
            ->orWhere('reservation.endDate BETWEEN :checkInDate AND :checkOutDate')
            ->orWhere('reservation.startDate <= :checkInDate AND reservation.endDate >= :checkOutDate')
            ->andWhere('reservation.confirmedAt IS NOT NULL')
            ->andWhere('reservation.rating IS NULL')
            ->innerJoin('reservation.property', 'prop')
        ;
        
  $properties = $this->createQueryBuilder('p')
        ->select('p')
        ->andWhere('p.approved = 1')
        ->andWhere($properties->expr()->notIn('p.id',  $subQuery->getDQL()))
        ->andWhere('reservations.confirmedAt IS NOT NULL')
        ->andWhere('reservations.rating IS NULL')
        ->setParameter('checkInDate', new \DateTime($checkIn))
        ->setParameter('checkOutDate', new \DateTime($checkOut))
        ->innerJoin('p.reservations', 'reservations')
        ->getQuery();
```


