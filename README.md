# SFStoreKit

[![Test Package](https://github.com/larryn35/SFStoreKit/actions/workflows/CI.yml/badge.svg)](https://github.com/larryn35/SFStoreKit/actions/workflows/CI.yml)

SFStoreKit is a backend build with Swift using Vapor and supports [Swift Fashion](https://github.com/larryn35/SwiftFashion), an iOS e-commerce app that sells clothing products. The backend is responsible for managing the store's products and proccessing orders.

---

## Prerequisites

### Installing XCode

Xcode can be downloaded from the [Mac App Store](https://itunes.apple.com/us/app/xcode/id497799835?mt=12).

### Installing Vapor Toolbox

Vapor can be installed via Homebrew using:
```
brew install vapor
```

### Installing Docker

Docker Desktop for Mac can be downloaded [here](https://docs.docker.com/docker-for-mac/install/).

----

## Getting started

### Starting the Docker Containers

To start up the database container, navigate to the project directory using the terminal and run the following command:
```
docker-compose up -d db
```

Once database container has started, run the following to start the app container:
```
docker-compose up -d app
```

Starting the containers in this order is important, since the server depends on a working database instance.

You can verify that the server is working by visiting http://127.0.0.1:8080/products in your browser.

---

## Endpoints
You can view the API documentation [here](https://documenter.getpostman.com/view/25780655/2s93Y5RLp7)

---

## Stopping and rerunning the containers
The server (```app```) and database (```db```) containers can be started and stopped using the Docker Desktop or in the terminal with the following commands:

Starting:
```
docker compose start
```

Stopping:
```
docker compose stop
```

---

## Exploring the project in Xcode
To view the project in Xcode, run:
```
vapor xcode
```

You can also start the server (make sure the database is running first) by pressing ```CMD+R``` or clicking the play button to build and run the project. You should see the following in the console:
```
[ INFO ] Server starting on http://127.0.0.1:8080
```

---

## Unit Testing

### Setting up a separate testing database

Run the following commands to stop any running containers and start a separate database for testing:
```
docker compose stop
docker compose -f testing-docker-compose.yml up -d test-db
```

After setting up the testing database (```test-db```), you can start/stop and switch between the development and testing databases using the Docker Desktop.

### Running tests

While ```test-db``` is running, the various XCTestCases can be performed in the Xcode project or with the following command:
```
swift test
```

## Goals

The primary goal for this project was to learn about server-side Swift development using the Vapor framework. Working on this project has given me some insight and experience with the following concepts:

- Creating RESTful APIs
- Working with databases, specifically PostgreSQL
- Writing testable and maintainable server-side code
- Using Docker containers to run and test the app
- Continuous integration using Github Actions

Todos:
- Implement user authentication and authorization
- Refactor logic for updating/applying sale promotions
- Explore options for deploying the project

## Resources

- [Vapor Docs](https://docs.vapor.codes/) - The Vapor Core Team
- [Getting started with Vapor 4](https://www.youtube.com/watch?v=CD283bLteP0&list=PLMRqhzcHGw1Z7xNnqS_yUNm1k9dvq-HbM) - Mikaela Caron from CodeWithChris
- [Server-Side Swift with Vapor](https://www.kodeco.com/books/server-side-swift-with-vapor) - Kodeco
- [Testing in Vapor 4](https://www.kodeco.com/16909142-testing-in-vapor-4) - Tim Condon from Kodeco
- [Developing and Testing Server-Side Swift with Docker and Vapor](https://www.kodeco.com/26322368-developing-and-testing-server-side-swift-with-docker-and-vapor) - Natan Rolnik from Kodeco