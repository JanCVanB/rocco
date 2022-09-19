terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("secrets/rocco-chat-bot-9d1c0082ba24.json")

  project = "rocco-chat-bot"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_cloud_run_service" "default" {
  name     = "rocco"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
