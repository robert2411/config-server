# config-server

[![Config server](https://dockeri.co/image/robert2411/config-server)](https://hub.docker.com/r/robert2411/config-server)

## Env variable

| Variable                    | Default value         | Options    | Description                                                                           |
| --------------------------- |:----------------------| -----------|---------------------------------------------------------------------------------------|
| EUREKA_CLIENT_ENABLED       | false                 | true/false | Find other applications using eureka                                                  |
| EUREKA_SERVICE_URL          | http://localhost:8761 |            | /euraka is added to the url by default                                                |
| CONFIG_DISCOVERY_ENABLED    | false                 | true/false | Find the config server using eurkea?                                                  |
| SEARCH_LOCATIONS            |[classpath:/, classpath:/config, file:./, file:./config, file:/config] | | |

## Description
To use local files use the following env variable `SPRING_PROFILES_ACTIVE=native`

## Tags
### latest
 - The last release (master branch on git)
 
### dev
 - The last development release (develop branch on git)

### Version number
 - A specific version (Tag on git)

## Release Notes

### V0.3.0
#### Features
 - Added the possibility to configure local files

### V0.2.0
#### Features
 - Added eureka properties

### V0.1.0
#### Features
 - First draft of the config-server, there is only 1 config property for now !!
 
## Release info
run start-release.sh