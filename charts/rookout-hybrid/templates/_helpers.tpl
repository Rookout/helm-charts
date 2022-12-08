{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rookout.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return secret name to be used based on provided values.
*/}}
{{- define "rookout.tokenSecretName" -}}
{{- $fullName := printf "%s-token" (include .Chart.Name .) -}}
{{- default $fullName .Values.tokenExistingSecret | quote -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "datastore.name" -}}
{{- default .Values.datastore.image.name .Values.datastore.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "datastore.fullname" -}}
{{- if .Values.datastore.fullnameOverride }}
{{- .Values.datastore.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.datastore.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s-%s" "datastore" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-%s" "datastore" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "datastore.labels" -}}
helm.sh/chart: {{ include "rookout.chart" . }}
{{ include "datastore.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.datastore.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "datastore.selectorLabels" -}}
app.kubernetes.io/name: {{ include "datastore.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "datastore.serviceAccountName" -}}
{{- if .Values.datastore.serviceAccount.create }}
{{- default (include "datastore.fullname" .) .Values.datastore.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.datastore.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Expand the name of the chart.
*/}}
{{- define "controller.name" -}}
{{- default .Values.controller.image.name .Values.controller.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "controller.fullname" -}}
{{- if .Values.controller.fullnameOverride }}
{{- .Values.controller.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.controller.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s-%s" "controller" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-%s" "controller" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "controller.labels" -}}
helm.sh/chart: {{ include "rookout.chart" . }}
{{ include "controller.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.controller.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "controller.selectorLabels" -}}
app.kubernetes.io/name: {{ include "controller.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "controller.serviceAccountName" -}}
{{- if .Values.controller.serviceAccount.create }}
{{- default (include "controller.fullname" .) .Values.controller.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.controller.serviceAccount.name }}
{{- end }}
{{- end }}