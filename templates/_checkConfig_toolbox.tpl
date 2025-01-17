{{/*
Ensure that a valid object storage config secret is provided. Make
an exception for the Google Cloud Storage (GCS) since with GKE Workload Identity
no secrets have to be configured.
*/}}
{{- define "gitlab.toolbox.backups.objectStorage.config.secret" -}}
{{-   if .Values.gitlab.toolbox.enabled -}}
{{-     if or .Values.gitlab.toolbox.backups.objectStorage.config (not .Values.global.minio.enabled) -}}
{{-       if and (not (eq .Values.gitlab.toolbox.backups.objectStorage.backend "gcs")) (not .Values.gitlab.toolbox.backups.objectStorage.config.secret) -}}
toolbox:
    A valid object storage config secret is needed for backups.
    Please configure it via `gitlab.toolbox.backups.objectStorage.config.secret`.
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{- end -}}
{{/* END gitlab.toolbox.backups.objectStorage.config.secret */}}

{{/*
Ensure that gitlab/toolbox is not configured with `replicas` > 1 if
persistence is enabled.
*/}}
{{- define "gitlab.toolbox.replicas" -}}
{{-   $replicas := index $.Values.gitlab "toolbox" "replicas" | int -}}
{{-   if and (gt $replicas 1) (index $.Values.gitlab "toolbox" "persistence" "enabled") -}}
toolbox: replicas is greater than 1, with persistence enabled.
    It appear that `gitlab/toolbox` has been configured with more than 1 replica, but also with a PersistentVolumeClaim. This is not supported. Please either reduce the replicas to 1, or disable persistence.
{{-   end -}}
{{- end -}}
{{/* END gitlab.toolbox.replicas */}}
