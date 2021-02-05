# AdiChallengePrivate

Adidas iOS Engineer Coding Assignment.

# App Screens

- **Product List** - entry point of the app - shows the list of products fetched from the server, has an entry point for accessing the **Add Product** screen
- **Product Details** - accessed by selecting a product on the **Product List** screen - shows the product details and reviews, has an entry point for accessing the Add Review screen
- **Add Product** - accessed by tapping the + button on the **Product List** screen - enables user to add a new product
- **Add Review** - accessed by tapping the + button on the **Product Details** screen - enables user to add a review for an existing product

# Server Setup

1) Install Docker
2) Clone the git repo `git clone https://bitbucket.org/adichallenge/product-reviews-docker-composer.git`
3) Run docker, navigate to the gir directory and run `docker-compose up`
4) API docs for the 2 respective services are available at http://localhost:3001/api-docs/swagger/ and http://localhost:3002/api

# Dependencies

1) [Kingfisher](https://github.com/onevcat/Kingfisher) - added using SPM

# Project Setup

1) Run the server according to instructions from above
2) Run the app (after SPM finishes fetching the one dependency)

# Notes

- Considering the time constraints, I implemented only Unit-Tests, and not for all the classes, but I gave a good example of how I would continue
- Regarding the UI tests, I would implement the [Page Object Model system that I described in this article](https://medium.com/inside-bux/simplifying-ios-ui-testing-with-page-object-model-765a23e8ebd4)
- If I had more time, I would have implemented features such as proper localization / locale support, dark mode, and would have designed and implemeted a more advanced design instead of the rudimentary one that I have used
