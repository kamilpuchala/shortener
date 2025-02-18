# URL Shortener

A lightweight, Docker-based Rails application that shortens long URLs, counts visits, and supports optional custom slugs and URL expiration.

## Setup

1. **Clone the repository**:
   ```bash
   git clone git@github.com:kamilpuchala/shortener.git
   cd url-shortener

2. **Build the  run containers (Rails App, Postgres, Redis)**:
   ```bash
    docker-compose build
    docker-compose up -d

3. **Initialize the database**:
    ```bash
    docker-compose run app rake db:create db:migrate
   
4. **Access the application**:
    ```bash
    http://localhost:3000

## Tech info 

#### Api details `http://localhost:3000/api-docs/index.html`
#### Sidekiq monitoring `http://localhost:3000/sidekiq`

## Features

## Technical Overview

### Create Shortened URL
Send a **POST** request to `/api/v1/redirect_urls` with:
- `original_url` (required)
- optionally `custom_slug`
- optionally `expires_at`

If no slug is provided, the system generates a **unique 7-character slug**.

### Custom Slugs
- Users may specify a **custom slug**.
- **Auto-generated slugs** are enforced to 7 characters to avoid collisions.

### Redirect to Original URL
- Visiting `/:slug` looks up the record and redirects if valid and **not expired** original url.
- If a URL is expired, a **404** is returned instead.

### URL Expiration
- Pass an `expires_at` date when creating the URL.
- If the current date is past `expires_at`, the redirect will return **404**.

### Track Visits
- Each successful redirect **increments** a `visits` counter.
- An **asynchronous job** (ActiveJob - **Sidekiq** adapter) handles the increment to keep requests fast.

### List All URLs
- A **GET** request to `/api/v1/redirect_urls` returns all shortened URLs (no pagination currently).
- Each entry includes `id`, `slug`, `original_url`, and `visits`.

### View specific URL
- A **GET** request to `/api/v1/redirect_urls/:id` returns a single shortened URL.
- The response includes `id`, `slug`, `original_url`, `visits`, and `expires_at`.


### Service Objects
We use a service object (`RedirectUrls::Create`) to encapsulate:
- Slug generation
- Caching
- Record creation

### Presenter
`RedirectUrlPresenter` formats the output consistently across API endpoints.

### Caching
The slug-to-URL mapping can be cached for performance, reducing database lookups.

### Validation
`RedirectUrl` validates:
- **`original_url`** presence and proper format
- **`slug`** uniqueness
- **`expires_at`** must be in the future, if provided

### Testing
**RSpec** covers:
- **Controller endpoints**
- **Model validations** 
- **Service logic** 
- **Presenter formatting**
- **Caching behavior**
- **Repositories queries**
- **API documentation**
- **Sidekiq jobs**
- **Custom validators**

simplecovo coverage 99.4%

`docker-compose run shortener rspec`

## Summary
This project demonstrates a production-oriented URL shortener with:

Shortening & Redirection
Custom Slugs
Expiration
Basic Visit Analytics

## Future Improvements
- **Pagination** for the URL list
- **User Authentication** for creating custom slugs and viewing analytics - paid plans
- **Rate Limiting** to prevent abuse
