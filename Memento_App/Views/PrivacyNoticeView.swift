//
//  PrivacyNoticeView.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI

/// Hoja modal de aviso de privacidad y confidencialidad ética.
/// Incluye textos placeholders totalmente editables listos para que el equipo legal y de producto
/// inserte las cláusulas regulatorias finales (GDPR / HIPAA / Privacidad de Salud Mental).
public struct PrivacyNoticeView: View {
    @Environment(\.dismiss) private var dismiss
    public let onAccept: () -> Void
    
    public init(onAccept: @escaping () -> Void = {}) {
        self.onAccept = onAccept
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.08, green: 0.07, blue: 0.16)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Cabecera
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Aviso de Privacidad y Santuario Digital")
                                .font(.system(size: 24, weight: .semibold, design: .serif))
                                .foregroundColor(.white)
                            
                            Text("Última actualización: 15 de Octubre de 2026")
                                .font(.system(size: 13, design: .monospaced))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.top, 16)
                        
                        Divider().background(Color.white.opacity(0.15))
                        
                        // Sección 1: Compromiso de Introspección
                        legalSection(
                            title: "1. Confidencialidad de tu Mundo Interno",
                            bodyText: "[PLACEHOLDER LEGAL] En Memento, consideramos tus pensamientos, sentimientos y reflexiones como material estrictamente confidencial. Todas tus respuestas introspectivas y métricas de bienestar están diseñadas para ser procesadas de manera anónima y cifrada. Jamás comercializaremos tus estados emocionales con terceros ni anunciantes."
                        )
                        
                        // Sección 2: Procesamiento del LLM
                        legalSection(
                            title: "2. Asistente y Síntesis Inteligente",
                            bodyText: "[PLACEHOLDER LEGAL] Las reflexiones procesadas por modelos de lenguaje (LLM) se envían despojadas de identificadores personales (PII) bajo protocolos seguros de transmisión (TLS 1.3). El modelo devuelve resúmenes conceptuales para construir tu mapa estelar sin almacenar tus entradas para entrenamiento público."
                        )
                        
                        // Sección 3: Seguridad Local y Biometría
                        legalSection(
                            title: "3. Bloqueo y Autenticación en el Dispositivo",
                            bodyText: "[PLACEHOLDER LEGAL] Tu código PIN y tus datos biométricos (Face ID / Touch ID) se gestionan directamente a través del hardware seguro de Apple (Secure Enclave y LocalAuthentication). Memento nunca almacena ni transmite tus rasgos biométricos fuera de tu dispositivo."
                        )
                        
                        // Sección 4: Derechos del Usuario
                        legalSection(
                            title: "4. Control Total y Borrado",
                            bodyText: "[PLACEHOLDER LEGAL] Puedes restablecer o eliminar la totalidad de tus entradas, constelaciones y perfiles en cualquier momento desde la configuración de la aplicación."
                        )
                        
                        Spacer(minLength: 32)
                        
                        // Botón de Aceptación
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            onAccept()
                            dismiss()
                        }) {
                            Text("He leído y Acepto los Términos")
                                .frame(maxWidth: .infinity)
                        }
                        .sketchButtonStyle(
                            strokeColor: Color(red: 0.85, green: 0.80, blue: 1.0),
                            fillColor: Color(red: 0.45, green: 0.35, blue: 0.70).opacity(0.4),
                            cornerRadius: 16
                        )
                        .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
            }
        }
    }
    
    private func legalSection(title: String, bodyText: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .serif))
                .foregroundColor(Color(red: 0.85, green: 0.80, blue: 1.0))
            
            Text(bodyText)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.75))
                .lineSpacing(4)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1.0)
                )
        )
    }
}
