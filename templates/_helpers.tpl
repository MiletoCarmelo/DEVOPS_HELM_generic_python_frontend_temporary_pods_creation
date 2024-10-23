{{/*
Common labels
*/}}

{{- define "label-generator" -}}
{{- if .Values.module -}}
app.kubernetes.io/name: {{ .Values.module }}  # Simplifié
helm.sh/chart: {{ .Chart.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/component: frontend-python-{{.Values.module}}
{{- else -}}
{{- fail "La valeur .Values.module est requise" -}}
{{- end -}}
{{- end -}}
