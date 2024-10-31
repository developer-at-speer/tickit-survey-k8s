
# Tickit Health Developer Assignment: Mental Health Survey Submission App

This is a full-stack app for securely capturing and storing mental health survey responses, with backend API, frontend UI, and robust unit testing. It utilises AES encryption to secure user data and K8S for easy deployments.  

---

## Video Demo

[Video Demo](https://github.com/user-attachments/assets/684353cc-730a-40a1-aa17-31fdc3f36b24)

## Features

- **Backend API**: Ruby on Rails API for handling survey submissions securely. Includes validation, AES encryption for user data and unit tests. This also supports Kubernetes deployments via minikube.  
- **Frontend Form**: React/TypeScript (or Angular) survey form for user responses. Includes validation and unit tests
- **Testing**: RSpec for backend; Jest for frontend validation and submission.

## Tech Stack

- **Backend**: Ruby on Rails, MySQL
- **Frontend**: React 
- **Testing**: RSpec (Backend), Jest (Frontend)

## Getting Started

1. **Clone Repo**: `git clone https://github.com/developer-at-speer/rails-mood-survey`
2. **Backend Setup**:
   ``` 
   docker-compose build
   docker-compose run web
   docker-compose up
   ```
3.	Frontend Setup:
    ```
    cd client
    npm install
    npm run dev
    ```

4.	Run Tests:
- Backend: `rspec -fd`
- Frontend: `npm run test`

Frontend Form

- Form Structure: Three questions (slider, numeric scale, text).
- Validation: Validation is added.
- Tests: Jest tests form validation, submission flow, and API interactions.

Security

For extra security, all user responses are encrypted with AES. The AES keys are stored in a different table as well. In a production platform, I would store these keys in a completely separate for an addtitional layer of security. We will also deploy this with a SSL certificate so the data stays encrypted in transit. 

## Tests

Backend Tests:

<img width="487" alt="backend_tests" src="https://github.com/user-attachments/assets/59a26b5d-a94f-4578-8347-0be7844c71b8">

Frontend Tests:

<img width="531" alt="frontend_tests" src="https://github.com/user-attachments/assets/aa41d914-ce30-4979-8d1e-4dfbb4429215">



