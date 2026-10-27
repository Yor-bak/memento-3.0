//
//  Color+Memento.swift
//  Memento_App
//
//  Created by Senior iOS UI/UX Engineer on 15/10/2026.
//

import SwiftUI

/// Extensión del Design System oficial de Memento.
/// Define los únicos tokens de color autorizados para la aplicación, garantizando
/// coherencia estética en la escala cósmica, el lienzo en acuarela y los acentos estelares.
public extension Color {
    
    // MARK: - Escala Galaxia / Acuarela
    
    /// Tono púrpura profundo (#432E54), base nocturna para la atmósfera cósmica y sombras.
    static let mementoDarkPurple = Color(hex: "432E54")
    
    /// Tono violeta intenso (#4B4376), utilizado para nebulosas intermedias y marcos suaves.
    static let mementoDeepViolet = Color(hex: "4B4376")
    
    /// Azul marino galáctico (#215597), corazón del fondo de acuarela y profundidad estelar.
    static let mementoNavyBlue = Color(hex: "215597")
    
    /// Azul celestial diáfano (#3B80C6), para capas luminosas de acuarela y constelaciones activas.
    static let mementoSkyBlue = Color(hex: "3B80C6")
    
    /// Azul suave y etéreo (#99BCEC), ideal para biseles sketch, estrellas menores y tipografía secundaria.
    static let mementoSoftBlue = Color(hex: "99BCEC")
    
    // MARK: - Acento / Nodos
    
    /// Dorado estelar cálido (#F4C542), reservado para nodos supremos (Lunas), estrellas medianas e hitos.
    static let mementoGold = Color(hex: "F4C542")
    
    // MARK: - Base y Contorno
    
    /// Blanco puro (#FFFFFF), para núcleos estelares, texto principal y destellos de luz.
    static let mementoWhite = Color(hex: "FFFFFF")
    
    /// Negro espacial (#000000), base exterior del lienzo, passepartout y sombras de oclusión.
    static let mementoBlack = Color(hex: "000000")
}

public extension Color {
    /// Inicializador para crear instancias de `Color` a partir de un valor hexadecimal (e.g. "432E54" o "#F4C542").
    /// - Parameter hex: Cadena de texto con el código hexadecimal RGB.
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            let r = Double((hexNumber & 0xff0000) >> 16) / 255
            let g = Double((hexNumber & 0x00ff00) >> 8) / 255
            let b = Double(hexNumber & 0x0000ff) / 255
            self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
            return
        }
        self.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 1.0)
    }
}
