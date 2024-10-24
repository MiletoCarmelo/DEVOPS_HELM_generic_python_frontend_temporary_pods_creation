{{/*
Common labels
*/}}
{{- define "label-generator" -}}
{{- if .Values.module -}}
app.kubernetes.io/name: {{ .Values.module | trunc 32 }}
helm.sh/chart: {{ .Values.chartName | default .Chart.Name | trunc 32 }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name | trunc 32 }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/component: {{.Values.module | trunc 32 }}
{{- else -}}
{{- fail "La valeur .Values.module est requise" -}}
{{- end -}}
{{- end -}}
