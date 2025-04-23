// app/javascript/application.js

import Rails from "rails-ujs"
Rails.start()

import { Turbo } from "@hotwired/turbo-rails"
import "controllers"
import { Trix } from "trix"
import "trix/dist/trix.css"
import "@rails/actiontext"
