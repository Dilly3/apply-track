gcloud version
gcloud auth login
gcloud config set project YOUR_PERSONAL_PROJECT_ID

export PROJECT_ID="$(gcloud config get-value project)"
export REGION="us-central1"

gcloud auth application-default login

gcloud auth configure-docker us-central1-docker.pkg.dev

docker image inspect \
  us-central1-docker.pkg.dev/apply-track-028/applytrack/applytrack:v1 \
  --format '{{.Os}}/{{.Architecture}}'

  gcloud run services logs read applytrack \
  --project=apply-track-028 \
  --region=us-central1 \
  --limit=20

  gcloud run services list \
  --project=apply-track-028 \
  --region=us-central1

gcloud artifacts repositories list \
  --project=apply-track-028 \
  --location=us-central1