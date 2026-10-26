import json
import boto3
import os

def lambda_handler(event, context):
    print("Payload recebido:", json.dumps(event))
    
    # 1. Carrega o mapa dinâmico de bancos gerado pelo Terraform
    db_map_str = os.environ.get('RDS_MAP', '{}')
    db_map = json.loads(db_map_str)
    
    body = json.loads(event.get('body', '{}'))
    alerts = body.get('alerts', [])
    
    for alert in alerts:
        # Só executa se for a regra de falha HTTP
        if alert.get('status') == 'firing' and alert['labels'].get('alertname') == 'HighHttp5xxErrorRate':
            
            # O nome do Ingress (ex: 'auth-ingress' ou 'flag-ingress') vem nos labels da métrica
            ingress_name = alert['labels'].get('ingress', '').lower()
            
            target_db_identifier = None
            
            # 2. Descobre qual banco pertence ao serviço que falhou
            for key, db_config in db_map.items():
                # Se 'auth' estiver no nome do ingress 'auth-ingress', achamos o alvo
                if key in ingress_name:
                    target_db_identifier = db_config['identifier']
                    break
            
            # 3. Executa a remediação no banco correto
            if target_db_identifier:
                print(f"Match! Ingress '{ingress_name}' disparou. Alvo: RDS '{target_db_identifier}'")
                rds = boto3.client('rds')
                
                try:
                    response = rds.describe_db_instances(DBInstanceIdentifier=target_db_identifier)
                    status = response['DBInstances'][0]['DBInstanceStatus']
                    
                    if status == 'stopped':
                        print(f"Banco {target_db_identifier} parado. Enviando start_db_instance...")
                        rds.start_db_instance(DBInstanceIdentifier=target_db_identifier)
                    else:
                        print(f"Banco em status '{status}'. Nenhuma ação infra necessária.")
                except Exception as e:
                    print(f"Erro ao interagir com RDS: {str(e)}")
            else:
                print(f"Nenhum banco mapeado para o ingress: {ingress_name}")

    return {'statusCode': 200, 'body': 'Runbook finalizado.'}