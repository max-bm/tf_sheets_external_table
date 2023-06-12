resource "google_bigquery_dataset" "dataset" {
  for_each = local.datasets

  provider   = google.impersonated
  dataset_id = each.key
  location   = local.project_config.region

  depends_on = [
    google_project_service.enable_apis
  ]
}

resource "google_bigquery_table" "table" {
  for_each = local.tables

  provider            = google.impersonated
  dataset_id          = each.value.dataset_id
  table_id            = each.value.name
  deletion_protection = each.value.deletion_protection

  dynamic "external_data_configuration" {
    for_each = try(each.value.external_data_configuration, null) != null ? [each.value.external_data_configuration] : []

    content {
      autodetect    = external_data_configuration.value.autodetect
      source_format = external_data_configuration.value.source_format
      source_uris   = external_data_configuration.value.source_uris

      dynamic "google_sheets_options" {
        for_each = try(external_data_configuration.value.google_sheets_options, null) != null ? [external_data_configuration.value.google_sheets_options] : []

        content {
          range             = google_sheets_options.value.range
          skip_leading_rows = google_sheets_options.value.skip_leading_rows
        }
      }
    }
  }

  depends_on = [
    google_bigquery_dataset.dataset
  ]
}
