# Rails Vue Template

Template for new projects built with Ruby on Rails and Vue.js.

## Environment

Initialized with the following command using Rails `6.0.1`:

```bash
rails new rails-vue-template --skip-turbolinks --webpack=vue
```

Instances of `RailsVueTemplate`, `rails_vue_template`, and `rails-vue-template` should be updated to reflect the name of the application.

## MVC Components

### Models

A `User` model is included, generated by Devise.

### Controllers

The `PagesController` is used to render the application root, which contains the Vue.js single-page application.

The `Api::SessionsController` is used to render a JSON representation of the current Devise-signed-in `User`.