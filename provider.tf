provider "google" {
  credentials = file("terraform-kickstart-ac4a9e1b283d.json")
  project     = "terraform-kickstart"
  region      = "europe-west4"
  zone        = "europe-west4-a"
}