# to-do-list
Simple to-do list app to test different infrastructure configurations.

## The application
The system consists of three core components: a database, a application server, and a web server.

![Alt text](image.png)

The frontend is powered by a web server, which hosts a React application. This component interacts seamlessly with the backend via APIs. On the backend, a Node.js application handles requests originating from the web server and facilitates communication with the database. The database itself is built on PostgreSQL for data management.

## The infrastructure

### Using AWS

- [Each component in a AWS EC2 Instance](infrastructure/AWS%20EC2)
- Web server and app server in containers managed by ECS and database in RDS
- Web server and app server in containers managed by EKS and database in RDS

### Using Azure

- Each component in Virtual Machines
- Web server and app server in containers managed by Azure Container Services and database in Azure PostgreSQL Server
- Web server and app server in containers managed by AKS and database in Azure PostgreSQL Server

## Some notes
- This repository was created for study purposes. My primary motivation behind its creation was to document code snippets, making them more accessible for reuse in other projects.
- Since the goal is to document for future reuse, I might leverage different tools to create the same resources. That does not mean that one approach is superior to another. There are many ways to create these archtectures and by doing this it allows for a broader scope within the repository.
- The repository is currently a work in progress, and I will strive to keep it consistently updated, featuring the most comprehensive documentation possible.


## Meus links
- [LinkedIn](https://www.linkedin.com/in/phelipeavila/)