## Open Graph Tag Scraper

-  URL's of the following form are valid: `https://www.domain.tld`
-  When cloning the project, please set install the depencies by running `bundle install`
-  Also, please set up a database by running :
       `rake db:create db:migrate`
 - To run the scraper, use `ruby app.rb`
- The two endpoints are:
  1) `GET http://localhost:8080/urls  `
    Optional query params include: `page, per_page`
    If these are not included the app defaults to 5 a page and the first page
  2) `POST http://localhost:8080/url`
    The body for this requires a `url` attribute.
