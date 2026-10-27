//
//  CustomPinLockView.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI

/// Pantalla de Bloqueo y Autenticación de Memento (`locked`).
/// Dispara Face ID / Touch ID inmediatamente si está habilitado en el perfil,
/// y provee el teclado numérico sketch `HandmadeKeypadView` como método principal o de respaldo.
public struct CustomPinLockView: View {
    public let storedPin: String?
    public let isBiometricsEnabled: Bool
    public let onUnlockSuccess: () -> Void
    
    @State private var enteredPin: String = ""
    @State private var errorMessage: String? = nil
    @State private var isAuthenticatingBiometrics: Bool = false
    
    private let securityService: SecurityServiceProtocol
    
    public init(
        storedPin: String?,
        isBiometricsEnabled: Bool,
        securityService: SecurityServiceProtocol = SecurityService(),
        onUnlockSuccess: @escaping () -> Void
    ) {
        self.storedPin = storedPin
        self.isBiometricsEnabled = isBiometricsEnabled
        self.securityService = securityService
        self.onUnlockSuccess = onUnlockSuccess
    }
    
    public var body: some View {
        ZStack {
            GalaxyWatercolorBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                Spacer()
                
                // Icono y Título
                VStack(spacing: 12) {
                    Image(systemName: "lock.circle.fill")
                        .font(.system(size: 52))
                        .foregroundColor(Color(red: 0.85, green: 0.80, blue: 1.0))
                        .shadow(color: Color(red: 0.85, green: 0.80, blue: 1.0).opacity(0.6), radius: 12)
                    
                    Text("Santuario Bloqueado")
                        .font(.system(size: 26, weight: .light, design: .serif))
                        .foregroundColor(.white)
                    
                    if let error = errorMessage {
                        Text(error)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.55))
                            .transition(.opacity)
                    } else {
                        Text("Ingresa tu PIN o usa biometría para entrar")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                // Teclado numérico artesanal
                HandmadeKeypadView(
                    pinLength: 4,
                    currentPin: $enteredPin,
                    isBiometricsAvailable: isBiometricsEnabled && securityService.isBiometricsAvailable(),
                    biometricIconName: securityService.biometricTypeDescription() == "Face ID" ? "faceid" : "touchid",
                    onBiometricsTapped: {
                        Task { await triggerBiometrics() }
                    },
                    onPinCompleted: handlePinEntered
                )
                
                Spacer()
            }
        }
        .task {
            // Requerimiento: Opción Face ID / Biometrics inmediata al cargar la pantalla
            if isBiometricsEnabled && securityService.isBiometricsAvailable() {
                await triggerBiometrics()
            }
        }
    }
    
    private func handlePinEntered(pin: String) {
        if securityService.validatePin(entered: pin, against: storedPin) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            onUnlockSuccess()
        } else {
            withAnimation {
                errorMessage = "Código incorrecto. Vuelve a intentarlo."
                enteredPin = ""
            }
        }
    }
    
    private func triggerBiometrics() async {
        guard !isAuthenticatingBiometrics else { return }
        isAuthenticatingBiometrics = true
        
        let result = await securityService.authenticateWithBiometrics(
            reason: "Verifica tu identidad para acceder a tu diario Memento"
        )
        
        await MainActor.run {
            isAuthenticatingBiometrics = false
            switch result {
            case .success(let success):
                if success {
                    onUnlockSuccess()
                }
            case .failure(let error):
                if case .userCancelled = error {
                    // Si el usuario cancela Face ID, permitimos usar el teclado manual sin mensaje alarmante
                    errorMessage = nil
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
