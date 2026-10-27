//
//  HandmadeKeypadView.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI

/// Teclado numérico artesanal / sketch diseñado a medida para Memento con respuesta háptica y animaciones táctiles.
public struct HandmadeKeypadView: View {
    public let pinLength: Int
    @Binding public var currentPin: String
    public var isBiometricsAvailable: Bool
    public var biometricIconName: String
    public var onBiometricsTapped: () -> Void
    public var onPinCompleted: (String) -> Void
    
    @State private var shakeOffset: CGFloat = 0
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    private let completionFeedback = UINotificationFeedbackGenerator()
    
    public init(
        pinLength: Int = 4,
        currentPin: Binding<String>,
        isBiometricsAvailable: Bool = true,
        biometricIconName: String = "faceid",
        onBiometricsTapped: @escaping () -> Void = {},
        onPinCompleted: @escaping (String) -> Void = { _ in }
    ) {
        self.pinLength = pinLength
        self._currentPin = currentPin
        self.isBiometricsAvailable = isBiometricsAvailable
        self.biometricIconName = biometricIconName
        self.onBiometricsTapped = onBiometricsTapped
        self.onPinCompleted = onPinCompleted
    }
    
    public var body: some View {
        VStack(spacing: 32) {
            // Indicador de dígitos (Constelación de puntos)
            pinDotsIndicator
                .offset(x: shakeOffset)
            
            // Rejilla de teclas numéricas
            VStack(spacing: 16) {
                ForEach(0..<3) { row in
                    HStack(spacing: 24) {
                        ForEach(1...3, id: \.self) { col in
                            let digit = "\(row * 3 + col)"
                            keypadButton(label: digit) {
                                handleDigit(digit)
                            }
                        }
                    }
                }
                
                // Fila inferior: Biometría, 0, Borrar
                HStack(spacing: 24) {
                    if isBiometricsAvailable {
                        actionButton(icon: biometricIconName) {
                            impactFeedback.impactOccurred()
                            onBiometricsTapped()
                        }
                    } else {
                        Color.clear
                            .frame(width: 72, height: 72)
                    }
                    
                    keypadButton(label: "0") {
                        handleDigit("0")
                    }
                    
                    actionButton(icon: "delete.left") {
                        handleBackspace()
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Subcomponentes
    private var pinDotsIndicator: some View {
        HStack(spacing: 18) {
            ForEach(0..<pinLength, id: \.self) { index in
                let isFilled = index < currentPin.count
                ZStack {
                    Circle()
                        .strokeBorder(Color.white.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 18, height: 18)
                    
                    if isFilled {
                        Circle()
                            .fill(Color(red: 0.85, green: 0.80, blue: 1.0))
                            .frame(width: 12, height: 12)
                            .shadow(color: Color(red: 0.85, green: 0.80, blue: 1.0).opacity(0.8), radius: 6)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isFilled)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func keypadButton(label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 28, weight: .regular, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 72, height: 72)
                .background(
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.06))
                        Circle()
                            .strokeBorder(Color.white.opacity(0.25), lineWidth: 1.2)
                        // Segundo contorno sketch tenue
                        Circle()
                            .strokeBorder(Color.white.opacity(0.12), style: StrokeStyle(lineWidth: 0.8, dash: [4, 4]))
                            .padding(2)
                    }
                )
        }
        .buttonStyle(KeypadPressStyle())
    }
    
    private func actionButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
                .frame(width: 72, height: 72)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.04))
                )
        }
        .buttonStyle(KeypadPressStyle())
    }
    
    // MARK: - Manejo de Lógica
    private func handleDigit(_ digit: String) {
        guard currentPin.count < pinLength else { return }
        impactFeedback.impactOccurred()
        currentPin.append(digit)
        
        if currentPin.count == pinLength {
            completionFeedback.notificationOccurred(.success)
            onPinCompleted(currentPin)
        }
    }
    
    private func handleBackspace() {
        guard !currentPin.isEmpty else { return }
        impactFeedback.impactOccurred()
        _ = currentPin.removeLast()
    }
    
    /// Dispara la animación de error / shake cuando el PIN es incorrecto.
    public func triggerShakeAnimation() {
        completionFeedback.notificationOccurred(.error)
        withAnimation(.default) {
            shakeOffset = -14
        }
        withAnimation(.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
            shakeOffset = 0
        }
    }
}

/// Efecto de pulsación suave para los botones del teclado.
private struct KeypadPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
