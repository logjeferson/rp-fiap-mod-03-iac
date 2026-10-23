resource "helm_release" "kube_prometheus_stack" {
  depends_on       = [helm_release.ingress_nginx]
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  version          = "57.2.0"
  values = [
    <<-EOT
    grafana:
      ingress:
        enabled: true
        ingressClassName: "nginx"
        annotations:
          cert-manager.io/cluster-issuer: "letsencrypt-prod"
          nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
          nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
        hosts:
          - "${var.eks_grafana_domain_name}"
        tls:
          - hosts:
              - "${var.eks_grafana_domain_name}"
            secretName: "grafana-tls-cert"
      additionalDataSources:
        - name: Loki
          type: loki
          url: http://loki:3100
          access: proxy
    alertmanager:
      enabled: true
      ingress:
        enabled: true
        ingressClassName: "nginx"
        annotations:
          cert-manager.io/cluster-issuer: "letsencrypt-prod"
          nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
          nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
        hosts:
          - "${var.eks_alertmanager_domain_name}"
        tls:
          - hosts:
              - "${var.eks_alertmanager_domain_name}"
            secretName: "alertmanager-tls-cert"
      config:
        global:
          resolve_timeout: 5m
        route:
          group_by: ['alertname', 'namespace']
          group_wait: 30s
          group_interval: 5m
          repeat_interval: 12h
          receiver: 'pagerduty-on-call'
        receivers:
          - name: 'pagerduty-on-call'
            pagerduty_configs:
              - routing_key: "${var.pagerduty_routing_key}"
                description: '[{{ .Status | toUpper }}] {{ .CommonLabels.alertname }}'
                severity: '{{ if eq .CommonLabels.severity "critical" }}critical{{ else }}warning{{ end }}'
                source: 'Prometheus EKS'
    additionalPrometheusRulesMap:
      rule-high-request-rate:
        groups:
          - name: custom-traffic-alerts
            rules:
              - alert: HighHttpRequestRate
                expr: sum(rate(nginx_ingress_controller_requests[2m])) by (ingress, namespace) > 10
                for: 1m
                labels:
                  severity: warning
                annotations:
                  summary: "Alta taxa de requisições no Ingress {{ $labels.ingress }}"
                  description: "O Ingress {{ $labels.ingress }} no namespace {{ $labels.namespace }} ultrapassou 10 req/s nos últimos 2 minutos (Atual: {{ $value | printf \"%.1f\" }} req/s)."
    prometheus:
      ingress:
        enabled: true
        ingressClassName: "nginx"
        annotations:
          cert-manager.io/cluster-issuer: "letsencrypt-prod"
          nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
          nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
        hosts:
          - "${var.eks_prometheus_domain_name}"
        tls:
          - hosts:
              - "${var.eks_prometheus_domain_name}"
            secretName: "prometheus-tls-cert"
    EOT
  ]
}

resource "helm_release" "loki" {
  depends_on       = [helm_release.ingress_nginx]
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki-stack"
  namespace        = "monitoring"
  create_namespace = true
  version          = "2.10.2"
  values = [
    <<-EOT
    grafana:
      enabled: false
    promtail:
      enabled: true
    loki:
      isDefault: false
    EOT
  ]
}

resource "helm_release" "opentelemetry_collector" {
  depends_on       = [helm_release.ingress_nginx]
  name             = "otel-collector"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-collector"
  namespace        = "monitoring"
  create_namespace = true
  version          = "0.87.1"
  values = [
    <<-EOT
    mode: deployment
    config:
      receivers:
        otlp:
          protocols:
            grpc:
              endpoint: 0.0.0.0:4317
            http:
              endpoint: 0.0.0.0:4318
      exporters:
        otlp/newrelic:
          endpoint: "otlp.nr-data.net:4317"
          headers:
            "api-key": "${var.new_relic_license_key}"
        prometheusremotewrite:
          endpoint: "http://kube-prometheus-stack-prometheus.monitoring.svc.cluster.local:9090/api/v1/write"
          tls:
            insecure: true
      service:
        pipelines:
          traces:
            receivers: [otlp]
            processors: [memory_limiter, batch]
            exporters: [otlp/newrelic]
          metrics:
            receivers: [otlp]
            processors: [memory_limiter, batch]
            exporters: [prometheusremotewrite, otlp/newrelic]
    EOT
  ]
}

# Obter a senha - Gitbash
# kubectl get secret grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode ; echo