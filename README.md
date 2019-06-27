# Unipart Digital - SuiteCRM Dev Ops

An easy way to manage deployment into development, UAT or staging environments for Suite CRM projects.

## Installation

Before installation, have Prerequisites fulfilled before selecting and running appropriate type of installation. 

### Prerequisites

1. In order to run this repo you should use a pc with a linux operative system or a mac, and you should ensure to have installed the following commands:
    - curl
    - unzip
    - [docker](https://docs.docker.com/install/ "Install Docker CE") 
    - [docker-compose](https://docs.docker.com/compose/install/ "Install Docker Compose")
    
    Note[1]: Since we're using docker-compose.yml version 3.7, it is important that your version of docker-compose is up to date.
    
    Note[2]: If you're using a CentOS 7 or Fedora 30 O.S. you could use our init script placed into the bin/ folder to automatically install all the dependencies.

1. Clone this repo from [github](https://github.com/unipart/suitecrm-dev-ops "Unipart Digital - SuiteCRM Dev Ops repository"):<br/>
    `git clone `
    
1. Move into the project folder

### Development - Local installation 

1. Copy the docker-compose.template.yml file and rename it docker-compose.yml with the following command:<br/>
   ```
   cp docker-compose.template.yml docker-compose.yml
   ```
1. Copy the etc/dev/.env.dev.example file to .env with the following command:<br/>
   ```
   cp etc/dev/.env.dev.example .env
   ```
1. Edit the .env file to your needs
1. Edit the file: features/Suites/LocalInstall/local_install.feature to match the .env and to your needs
1. Run the install script:<br/>
    ```
    ./bin/install.sh
    ```

### UAT - Remote installation

1. Copy the docker-compose.uat.template.yml file and rename docker-compose.uat.yml with the following command:<br/>
   ```
   cp docker-compose.uat.template.yml docker-compose.uat.yml
   ```
1. Copy the etc/uat/.env.uat.example file to .env with the following command:<br/>
   ```
   cp etc/dev/.env.uat.example .env
   ```
1. Edit the .env file to your needs
1. Edit the file features/Suites/RemoteInstall/remote_install.feature to match the .env and to your needs
1. Run the install script:<br/>
   ```
   ./bin/install.sh -e UAT
   ```
    
### Install a remote backup into a local environment for development purpose

If you want to use this skeleton repo to load your SuiteCRM instance, please use the following step:

1. Copy your file into app/ folder, ensure that within app/ are placed all SuiteCRM folders and files
1. Copy into etc/dev/ folder the configuration files config.php and config_override.php<br/>
   ```
   cp app/config.php etc/dev/config.php
   cp app/config_override.php etc/dev/config_override.php
   ```
1. Edit etc/dev/config.php based on your .env file, if you're using the .env.dev.example file you should edit as follow:
    1. Configure the *dbconfig* section in order to match your .env file<br/>
        ```
        'dbconfig' => 
        array (
            'db_host_name' => 'mariadb',
            'db_host_instance' => 'SQLEXPRESS',
            'db_user_name' => 'suitecrm_user',
            'db_password' => 'suitecrmdevpass',
            'db_name' => 'suitecrm',
            'db_type' => 'mysql',
            'db_port' => '',
            'db_manager' => 'MysqliManager',
        ),
        ```
    1. Edit the hostname to match your host<br/>
        ```
        'host_name' => 'localhost',
        ```
    1. Set the log directory<br/>
        ```
        'log_dir' => '/var/log/suitecrm/',
        ```
    1. Configure the session directory<br/>
        ```
        'session_dir' => '/var/www/sessions/',
        ```
    1. Set the site url as follow<br/>
        ```
        'site_url' => 'http://localhost:8080',
        ```
1. Add to your docker-compose.yml file section *services > app > volumes* the following lines:<br/>
    ```
    ./etc/dev/config.php:/var/www/html/config.php
    ./etc/dev/config_override.php:/var/www/html/config_override.php
    ```
1. Start the environment with:<br/>
   ```
   docker-compose up -d
   ```

## Main files and directories description

| File or directory | Description |
|-------------------|-------------|
| app/ | SuiteCRM main application directory, in this folder you can find the config.php file, however if you're going to use the suggested docker-compose orchestration it will be rewritten by   |
| bin/ | Executable scripts folder. |
| bin/init_centos7_root.sh | Bash script to initialize a clean version of CentOS 7 from the root user. <br/>**Note (1):** Please remember to edit the script before use, you have to change < SPECIFY USER HERE > to the username that will run docker. <br/>**Note (2):** In order to ensure that all the environment variables are correctly set up, after executing the script you'll need to logout and log back in with the docker user. |
| bin/init_centos7_user.sh | Bash script to initialize a clean version of CentOS 7 from a system user. <br/>**Note (1):** Please ensure that the user you're using has sudo rights. <br/>**Note (2):** In order to ensure that all the environment variables are correctly set up, after executing the script you'll need to logout and log back in with the docker user. |
| bin/init_fedora30_user.sh | Bash script to initialize a clean version of Fedora 30 from a system user. <br/>**Note (1):** Please ensure that the user you're using has sudo rights. <br/>**Note (2):** In order to ensure that all the environment variables are correctly set up, after executing the script you'll need to logout and log back in with the docker user. |
| bin/install.sh | Perform a fresh installation of SuiteCRM. |
| containers/suitecrm/Dockerfile | SuiteCRM container dockerfile. |
| etc/ | SuiteCRM Configuration folder, used also to override configuration files within app/ like conf.php, conf_override.php, etc. | 
| etc/dev/.env.dev.example | Docker compose .env file for development environment. |
| etc/dev/dev.php.ini | Php.ini file for development environment. |
| etc/uat/.env.uat.example | Docker compose .env file for user acceptance testing environment. |
| etc/uat/uat.php.ini | Php.ini file for uat or stage environment. |
| features/ | Behat features folder. |
| features/bootstrap/ | Behat Context folder. |
| features/Suites/ | Behat Suites folder, it is used to collect features files ordered in different subdirectory per suite. |
| volumes/ | Volume folder for docker based projects. |
| behat.yml | Behat configuration file. |
| composer.json | Project description. |
| composer.lock | Last stable run of composer install lock file. |
| docker-compose.template.yml | Template for docker-compose.yml for development environment. |
| docker-compose.uat.template.yml | Template for docker-compose.yml for user acceptance testing environment. |
| LICENSE | GPL v3 License that applies to this code. |
| README.md | This readme. |
