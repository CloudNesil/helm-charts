{{/*
Expand the name of the chart.
*/}}
{{- define "java-k8s.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "java-k8s.fullname" -}}
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
{{- define "java-k8s.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "java-k8s.labels" -}}
helm.sh/chart: {{ include "java-k8s.chart" . }}
app.kubernetes.io/image-tag: {{ .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "java-k8s.selectorLabels" . }}
{{- with .Values.customLabels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "java-k8s.selectorLabels" -}}
app.kubernetes.io/name: {{ include "java-k8s.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- with .Values.customSelectorLabels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "java-k8s.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "java-k8s.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

