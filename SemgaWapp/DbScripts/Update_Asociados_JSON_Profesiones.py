#!/usr/bin/env python3
"""
Script para actualizar el archivo asociados.json
Convertir profesiones de texto a códigos numéricos según tbProfesiones
"""

import json
import re

# Mapeo de profesiones a códigos según tbProfesiones
PROFESION_MAPPING = {
    "Ingeniería en Sistemas": 1,  # Ingeniero
    "Medicina": 2,                # Médico
    "Derecho": 3,                # Abogado
    "Contabilidad": 4,          # Contador
    "Educación": 5,             # Profesor
    "Psicología": 8,            # Psicólogo
    "Economía": 9,              # Economista
    "Administración de Empresas": 10,  # Administrador
    "Arquitectura": 7,          # Arquitecto
    "Marketing": 12,            # Comerciante
    "Finanzas": 4,              # Contador (más cercano)
    "Recursos Humanos": 10,     # Administrador (más cercano)
}

def update_profesiones_in_json():
    """Actualizar el archivo asociados.json con códigos de profesión"""
    
    # Leer el archivo JSON
    with open('Forms/Socios/asociados.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    updated_count = 0
    
    # Procesar cada asociado
    for asociado in data['asociados']:
        if 'profesion' in asociado:
            profesion_text = asociado['profesion']
            
            # Buscar el código correspondiente
            if profesion_text in PROFESION_MAPPING:
                asociado['profesion'] = PROFESION_MAPPING[profesion_text]
                updated_count += 1
            else:
                # Si no se encuentra, usar código 19 (Otro)
                asociado['profesion'] = 19
                updated_count += 1
                print(f"Profesión no mapeada: {profesion_text} -> Código 19 (Otro)")
    
    # Guardar el archivo actualizado
    with open('Forms/Socios/asociados.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f"✅ Actualización completada: {updated_count} registros actualizados")
    print("📋 Mapeo aplicado:")
    for profesion, codigo in PROFESION_MAPPING.items():
        print(f"  {profesion} -> {codigo}")

if __name__ == "__main__":
    update_profesiones_in_json()


