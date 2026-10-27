//
//  WelcomeView.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI

/// Pantalla inicial de bienvenida (Onboarding Paso 1).
/// Contiene el logotipo central con animación de respiración sutil (`scaleEffect` + opacidad oscilante),
/// subtítulo dinámico y botón de inicio con estilo de trazo sketch artesanal.
public struct WelcomeView: View {
    public let onGetStarted: () -> Void
    
    // Estados de animación
    @State private var breatheScale: CGFloat = 1.0
    @State private var breatheOpacity: Double = 0.75
    @State private var subtitleIndex: Int = 0
    
    private let dynamicSubtitles = [
        "Un espejo del alma",
        "El mapa de tu universo interno",
        "El silencio que revela quién eres",
        "Tus memorias convertidas en estrellas"
    ]
    
    public init(onGetStarted: @escaping () -> Void) {
        self.onGetStarted = onGetStarted
    }
    
    public var body: some View {
        ZStack {
            // Fondo cósmico en acuarela
            GalaxyWatercolorBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 36) {
                Spacer()
                
                // Logotipo central con respiración sutil
                centralLogo
                
                // Título y Subtítulo dinámico
                VStack(spacing: 12) {
                    Text("MEMENTO")
                        .font(.system(size: 40, weight: .ultraLight, design: .serif))
                        .tracking(10)
                        .foregroundColor(.white)
                        .shadow(color: Color.white.opacity(0.4), radius: 10)
                    
                    Text(dynamicSubtitles[subtitleIndex])
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .italic()
                        .foregroundColor(Color(red: 0.85, green: 0.80, blue: 0.95))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .contentTransition(.opacity)
                }
                
                Spacer()
                
                // Botón de acción con estilo de trazo/sketch
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onGetStarted()
                }) {
                    HStack(spacing: 12) {
                        Text("Comenzar el Viaje")
                        Image(systemName: "sparkle")
                            .font(.system(size: 14))
                    }
                    .frame(maxWidth: .infinity)
                }
                .sketchButtonStyle(
                    strokeColor: Color(red: 0.85, green: 0.80, blue: 1.0),
                    fillColor: Color.white.opacity(0.12),
                    cornerRadius: 18
                )
                .padding(.horizontal, 36)
                .padding(.bottom, 48)
            }
        }
        .onAppear {
            // Animación de respiración del logotipo (3.5 segundos por ciclo)
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) {
                breatheScale = 1.08
                breatheOpacity = 1.0
            }
            
            // Ciclo de subtítulos dinámicos cada 4 segundos
            Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.8)) {
                    subtitleIndex = (subtitleIndex + 1) % dynamicSubtitles.count
                }
            }
        }
    }
    
    // MARK: - Subcomponente del Logo
    private var centralLogo: some View {
        ZStack {
            // Halo de respiración exterior
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.65, green: 0.55, blue: 0.95).opacity(0.35),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 110
                    )
                )
                .frame(width: 220, height: 220)
                .scaleEffect(breatheScale)
                .opacity(breatheOpacity)
            
            // Aro exterior estilo boceto
            Circle()
                .strokeBorder(
                    Color.white.opacity(0.5),
                    style: StrokeStyle(lineWidth: 1.4, dash: [8, 6])
                )
                .frame(width: 140, height: 140)
            
            // Símbolo de constelación central
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 54))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color(red: 0.85, green: 0.80, blue: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color(red: 0.75, green: 0.65, blue: 1.0), radius: 16)
        }
    }
}
