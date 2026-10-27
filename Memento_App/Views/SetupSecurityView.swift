//
//  SetupSecurityView.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI

/// Pantalla de Configuración Inicial de Seguridad (Onboarding Paso 3).
/// Permite al usuario habilitar Face ID / Touch ID mediante `LAContext` y definir un PIN numérico
/// de respaldo de 4 dígitos utilizando el teclado artesanal `HandmadeKeypadView`.
public struct SetupSecurityView: View {
    public let onComplete: (_ pin: String?, _ biometricsEnabled: Bool) -> Void
    
    @State private var currentPin: String = ""
    @State private var confirmPin: String = ""
    @State private var isConfirming: Bool = false
    @State private var isBiometricsEnabled: Bool = false
    @State private var biometricDescription: String = "Biometría"
    @State private var isBiometricsAvailable: Bool = false
    @State private var statusMessage: String = "Elige un código PIN de 4 dígitos para proteger tus reflexiones"
    
    private let securityService: SecurityServiceProtocol
    
    public init(
        securityService: SecurityServiceProtocol = SecurityService(),
        onComplete: @escaping (_ pin: String?, _ biometricsEnabled: Bool) -> Void
    ) {
        self.securityService = securityService
        self.onComplete = onComplete
    }
    
    public var body: some View {
        ZStack {
            GalaxyWatercolorBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Cabecera e Instrucción
                VStack(spacing: 12) {
                    Image(systemName: isConfirming ? "lock.rotation" : "key.fill")
                        .font(.system(size: 38))
                        .foregroundColor(Color(red: 0.85, green: 0.80, blue: 1.0))
                    
                    Text(isConfirming ? "Confirma tu PIN" : "Protege tu Santuario")
                        .font(.system(size: 26, weight: .light, design: .serif))
                        .foregroundColor(.white)
                    
                    Text(statusMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                // Teclado numérico artesanal
                HandmadeKeypadView(
                    pinLength: 4,
                    currentPin: isConfirming ? $confirmPin : $currentPin,
                    isBiometricsAvailable: false,
                    onPinCompleted: handlePinCompleted
                )
                
                // Opción para habilitar Biometría si está disponible
                if isBiometricsAvailable {
                    Toggle(isOn: $isBiometricsEnabled) {
                        HStack(spacing: 10) {
                            Image(systemName: biometricDescription == "Face ID" ? "faceid" : "touchid")
                                .font(.system(size: 18))
                            Text("Activar \(biometricDescription)")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundColor(.white)
                    }
                    .tint(Color(red: 0.65, green: 0.55, blue: 0.95))
                    .padding(.horizontal, 40)
                    .padding(.top, 8)
                }
                
                Spacer()
                
                // Opción para omitir si el usuario no desea PIN en este momento
                Button(action: {
                    onComplete(nil, isBiometricsEnabled)
                }) {
                    Text("Omitir por ahora")
                        .font(.system(size: 14, design: .serif))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            isBiometricsAvailable = securityService.isBiometricsAvailable()
            biometricDescription = securityService.biometricTypeDescription()
            if isBiometricsAvailable {
                isBiometricsEnabled = true
            }
        }
    }
    
    private func handlePinCompleted(pin: String) {
        if !isConfirming {
            // Pasar a confirmar el PIN
            withAnimation {
                isConfirming = true
                statusMessage = "Ingresa nuevamente los 4 dígitos para confirmar"
            }
        } else {
            // Validar que ambos coincidan
            if confirmPin == currentPin {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                onComplete(currentPin, isBiometricsEnabled)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                withAnimation {
                    statusMessage = "Los códigos no coinciden. Inténtalo de nuevo."
                    confirmPin = ""
                    currentPin = ""
                    isConfirming = false
                }
            }
        }
    }
}
