{{/*
Common labels
*/}}

{{- define "label-generator" -}}
{{- if .Values.module -}}
app.kubernetes.io/name: {{.Release.Name}}-{{.Values.module}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "-" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/component: {{ .Values.k8s.component }}
{{- else -}}
{{- fail "La valeur .Values.module est requise" -}}
{{- end -}}
{{- end -}}
