import json
import boto3
import os
import base64

def lambda_handler(event, context):
    print("Payload bruto recebido:", json.dumps(event))
    
    # 1. Carrega o mapa dinâmico de bancos
    db_map_str = os.environ.get('RDS_MAP', '{}')
    db_map = json.loads(db_map_str)
    
    # 2. Tratamento resiliente do Body (Desempacota Base64 se a AWS tiver convertido)
    raw_body = event.get('body', '{}')
    if event.get('isBase64Encoded', False):
        raw_body = base64.b64decode(raw_body).decode('utf-8')
        
    try:
        body = json.loads(raw_body)
    except Exception as e:
        print(f"Erro ao converter JSON do body: {e}")
        return {'statusCode': 400, 'body': 'Formato de payload invalido.'}
        
    alerts = body.get('alerts', [])
    
    for alert in alerts:
        # Verifica se o alerta é de falha HTTP 5xx
        if alert.get('status') == 'firing' and alert['labels'].get('alertname') == 'HighHttp5xxErrorRate':
            
            ingress_name = alert['labels'].get('ingress', '').lower()
            target_db_identifier = None
            
            # 3. Descobre qual banco pertence ao serviço
            for key, db_config in db_map.items():
                if key in ingress_name:
                    target_db_identifier = db_config['identifier']
                    break
            
            # 4. Executa a remediação
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

    return {'statusCode': 200, 'body': 'Runbook executado com sucesso.'}