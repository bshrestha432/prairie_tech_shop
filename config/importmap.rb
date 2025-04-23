# config/importmap.rb

# Pin your application’s JS files
pin "application"

# Pin Turbo, make sure it's correctly referenced
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

# Pin Stimulus.js and related packages
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Pin Action Text and Trix (for rich text editing)
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"

# config/importmap.rb
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.1.3/app/assets/javascripts/rails-ujs.esm.js"

pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"