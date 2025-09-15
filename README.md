# Flask-MySQL Docker Project

## Overview
This project is a Flask-based web application using MySQL as the database. The application is containerized using Docker and managed via Docker Compose.

## Project Structure
```
.
├── app
│   ├── app.py                # Flask application entry point
│   ├── Dockerfile.app        # Dockerfile for the app container
│   ├── init.sql              # SQL script to initialize the database
│   ├── requirements.txt      # Python dependencies
│   └── templates
│       └── index.html        # HTML template for the app
├── docker-compose.yml        # Docker Compose configuration
└── README.md                 # Project documentation
```

## Key Components
- **Flask App (`app/`)**
  - Contains the main application logic (`app.py`).
  - Uses MySQL as the database with SQLAlchemy ORM.
  - Implements user authentication, product listing, and order management.

- **Docker Setup (`docker-compose.yml`)**
  - Defines services for the application and MySQL database.
  - Uses a health check for MySQL readiness.
  - Establishes a network (`app_network`) for service communication.

- **Database Initialization (`init.sql`)**
  - Automatically sets up the database schema when the MySQL container starts.
  

## Prerequisites
Ensure you have the following installed:
- Docker
- Docker Compose

## Setup & Installation

### 1️⃣ Clone the Repository
```sh
git clone <repo-url>
cd <repo-folder>
```

### 2️⃣ Build and Run Containers
```sh
docker compose up --build
```
This will build and start the Flask app and MySQL database containers.

### 3️⃣ Verify the Running Containers
```sh
docker ps
```
You should see two running containers: one for the Flask app and one for MySQL.

### 4️⃣ Access the Application
- Open a web browser and go to: `http://localhost:5000`

### 5️⃣ Stopping the Application
To stop and remove the containers, run:
```sh
docker compose down
```

## Database Setup
The `init.sql` script is executed automatically when the MySQL container starts. You can modify this file to customize your database setup.

## Logs & Debugging
- View application logs:
  ```sh
  docker compose logs app
  ```
- Access the running container:
  ```sh
  docker exec -it <container_id> sh
  ```

## Future Enhancements
- Improve authentication by using Flask-JWT-Extended.
- Implement product purchase tracking.
- Enhance error handling and validation.
- Move database credentials to a `.env` file for better security.
- Implement CI/CD pipeline for automated deployment.
