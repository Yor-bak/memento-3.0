//
//  Memento_AppApp.swift
//  Memento_App
//
//  Created by Senior iOS Engineer on 15/10/2026.
//

import SwiftUI
import SwiftData

/// Punto de entrada principal para la aplicación Memento.
/// Configura el contenedor persistente de SwiftData (`ModelContainer`) con los esquemas de:
/// - `UserProfile`: Preferencias de seguridad, estado de onboarding y contador de reflexiones.
/// - `DailyEntry`: Registros diarios de bienestar holístico y respuestas introspectivas.
/// - `StarNode`: Cuerpos celestes del grafo cósmico (mini estrellas, constelaciones medianas y lunas).
@main
struct Memento_AppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            DailyEntry.self,
            StarNode.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
