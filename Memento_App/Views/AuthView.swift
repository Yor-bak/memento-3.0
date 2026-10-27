//
//  AuthView.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI

/// Pantalla de Inicio de Sesión y Registro (Onboarding Paso 2).
/// Incluye placeholders funcionales para "Sign in with Apple", "Google" y "Email".
/// Al autenticarse, despliega la hoja modal `PrivacyNoticeView` antes de avanzar al flujo de seguridad.
public struct AuthView: View {
    public let onAuthenticated: () -> Void
    
    @State private var isPrivacyPresented = false
    @State private var emailInput = ""
    @State private var isEmailAuthExpanded = false
    
    public init(onAuthenticated: @escaping () -> Void) {
        self.onAuthenticated = onAuthenticated
    }
    
    public var body: some View {
        ZStack {
            GalaxyWatercolorBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer(minLength: 40)
                    
                    // Encabezado
                    VStack(spacing: 12) {
                        Image(systemName: "lock.shield")
                            .font(.system(size: 44))
                            .foregroundColor(Color(red: 0.85, green: 0.80, blue: 1.0))
                            .shadow(color: Color(red: 0.85, green: 0.80, blue: 1.0).opacity(0.5), radius: 10)
                        
                        Text("Acceso a tu Santuario")
                            .font(.system(size: 28, weight: .light, design: .serif))
                            .foregroundColor(.white)
                        
                        Text("Crea o sincroniza tu espacio privado con la opción que prefieras")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    
                    // Botones de Autenticación
                    VStack(spacing: 16) {
                        // 1. Sign in with Apple Placeholder
                        socialAuthButton(
                            title: "Continuar con Apple",
                            iconName: "apple.logo",
                            backgroundColor: .white,
                            foregroundColor: .black
                        ) {
                            triggerAuthFlow()
                        }
                        
                        // 2. Sign in with Google Placeholder
                        socialAuthButton(
                            title: "Continuar con Google",
                            iconName: "g.circle.fill",
                            backgroundColor: Color.white.opacity(0.12),
                            foregroundColor: .white
                        ) {
                            triggerAuthFlow()
                        }
                        
                        // Separador
                        HStack {
                            Rectangle().fill(Color.white.opacity(0.15)).frame(height: 1)
                            Text("o con tu correo")
                                .font(.system(size: 12, design: .serif))
                                .foregroundColor(.white.opacity(0.5))
                            Rectangle().fill(Color.white.opacity(0.15)).frame(height: 1)
                        }
                        .padding(.vertical, 8)
                        
                        // 3. Email Placeholder
                        if isEmailAuthExpanded {
                            VStack(spacing: 12) {
                                TextField("tu@correo.com", text: $emailInput)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.white.opacity(0.08))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .strokeBorder(Color.white.opacity(0.25), lineWidth: 1.0)
                                            )
                                    )
                                    .foregroundColor(.white)
                                
                                Button(action: triggerAuthFlow) {
                                    Text("Entrar con Correo")
                                        .frame(maxWidth: .infinity)
                                }
                                .sketchButtonStyle(cornerRadius: 14)
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        } else {
                            Button(action: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    isEmailAuthExpanded = true
                                }
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "envelope.fill")
                                    Text("Continuar con Correo Electrónico")
                                }
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.85))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 1.2)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 28)
                    
                    Spacer(minLength: 24)
                    
                    // Enlace directo al Aviso de Privacidad
                    Button(action: { isPrivacyPresented = true }) {
                        Text("Ver Aviso de Privacidad y Ética Digital")
                            .font(.system(size: 12, design: .serif))
                            .underline()
                            .foregroundColor(Color(red: 0.85, green: 0.80, blue: 1.0).opacity(0.8))
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .sheet(isPresented: $isPrivacyPresented) {
            PrivacyNoticeView {
                // Al aceptar el aviso de privacidad, se procede a configurar la seguridad
                onAuthenticated()
            }
        }
    }
    
    private func socialAuthButton(
        title: String,
        iconName: String,
        backgroundColor: Color,
        foregroundColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        }) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.system(size: 18))
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.white.opacity(0.2), lineWidth: 1.0)
                    )
            )
        }
    }
    
    private func triggerAuthFlow() {
        // Al simular el éxito de inicio de sesión, desplegamos la hoja de privacidad obligatoria
        isPrivacyPresented = true
    }
}


