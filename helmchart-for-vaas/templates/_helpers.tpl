{{/*
Expand the name of the chart.
*/}}
{{- define "helmchart-for-vaas.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helmchart-for-vaas.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helmchart-for-vaas.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helmchart-for-vaas.labels" -}}
helm.sh/chart: {{ include "helmchart-for-vaas.chart" . }}
{{ include "helmchart-for-vaas.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/created-by: "CloudDrove"
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helmchart-for-vaas.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helmchart-for-vaas.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "helmchart-for-vaas.serviceAccountName" -}}
{{- if .Values.serviceAccount.enabled }}
{{- default (include "helmchart-for-vaas.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for Horizontal Pod Autoscaler.
*/}}
{{- define "helmchart-for-vaas.hpa.apiVersion" -}}
{{- if $.Capabilities.APIVersions.Has "autoscaling/v2" }}
{{- print "autoscaling/v2" }}
{{- else if $.Capabilities.APIVersions.Has "autoscaling/v2beta2" }}
{{- print "autoscaling/v2beta2" }}
{{- else if $.Capabilities.APIVersions.Has "autoscaling/v2beta1" }}
{{- print "autoscaling/v2beta1" }}
{{- else }}
{{- print "autoscaling/v1" }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for Storage Class.
*/}}
{{- define "helmchart-for-vaas.storageClass.apiVersion" -}}
{{- if $.Capabilities.APIVersions.Has "storage.k8s.io/v1" }}
{{- print "storage.k8s.io/v1" }}
{{- else }}
{{- print "storage.k8s.io/v1beta1" }}
{{- end }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "helmchart-for-vaas.namespace" -}}
{{- if .Values.namespaceOverride }}
{{- .Values.namespaceOverride }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}