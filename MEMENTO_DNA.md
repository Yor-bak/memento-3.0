# MEMENTO APP — ADN DE ARQUITECTURA Y SINCRONIZACIÓN TÉCNICA

> **Documento de Control de Versiones Vivo**  
> Proyecto: Memento (Diario de Introspección con Visualización de Galaxia en Grafo)  
> Plataforma: iOS 17.0+ | Swift 5.10 / Swift 6 | SwiftUI + SwiftData + LocalAuthentication  
> Fecha de actualización: Octubre 2026

---

## 1. ADN del Repositorio y Arquitectura

### Stack Tecnológico
* **Lenguaje**: Swift 5.10 / Swift 6 (Strict Concurrency ready).
* **Framework UI**: SwiftUI con `@Observable` (Observation Framework moderno).
* **Persistencia**: SwiftData (`ModelContainer`, `ModelContext`, `@Model`).
* **Seguridad y Biometría**: LocalAuthentication (`LAContext`) + PIN en SwiftData (`UserProfile.pinCode`).
* **Feedback Háptico**: `UIImpactFeedbackGenerator` / `UINotificationFeedbackGenerator`.
* **Motion & Custom Layouts**: Lienzo 2D interactivo con soporte de Pan (`DragGesture`) y Zoom (`MagnificationGesture`) enmarcado en Custom Layout tipo Passepartout / Lámina de Acuarela.

### Design System Oficial: Paleta Estricta (Color+Memento)
Regla: Cero colores arbitrarios fuera de los 8 tokens oficiales del sistema:
- `mementoDarkPurple` (`#432E54`): Base atmosférica nocturna, sombras de oclusión y fondo exterior de galería.
- `mementoDeepViolet` (`#4B4376`): Nebulosas intermedias, relleno de tarjetas sketch y fondos de modales.
- `mementoNavyBlue` (`#215597`): Núcleo de profundidad acuarela en el cosmos.
- `mementoSkyBlue` (`#3B80C6`): Capas de luz de acuarela, enlaces activos y acento de dimensiones emocionales.
- `mementoSoftBlue` (`#99BCEC`): Trazos de biseles sketch, estrellas menores, tipografía secundaria y halos tenues.
- `mementoGold` (`#F4C542`): Nodos supremos (Lunas), estrellas medianas, botón de acción primaria y nariz estelar del gatito.
- `mementoWhite` (`#FFFFFF`): Núcleos de estrellas, texto titular y destellos de polvo estelar.
- `mementoBlack` (`#000000`): Fondo exterior del muro, sombras de elevación y pupilas del gatito.

### Patrón Arquitectónico: MVVM + Coordinator + Service/Repository
* **AppCoordinator**: Orquestador central de flujo y máquina de estados (`firstLaunch`, `locked`, `authenticated`).
* **Services / Repositories**: Capa de abstracción basada en protocolos (`SecurityServiceProtocol`, `GalaxyServiceProtocol`, `QuestionRepositoryProtocol`). Desacopla la lógica interna para permitir una transición transparente hacia APIs REST y endpoints de LLM.
* **ViewModels**: Modelos de vista anotados con `@Observable` para actualizar el estado atómicamente y minimizar re-renderizados.
* **Componentes Visuales**: `GalaxyCanvasView`, `SpaceCatView`, `ZenListeningRingView`, `HandmadeKeypadView`, `SketchStyles`.

---

## 2. Layout Passepartout en `GalaxyHomeView`

```
┌─────────────────────────────────────────────────────────────┐
│ PANTALLA PRINCIPAL (Color.mementoBlack / DarkPurple)        │
│                                                             │
│  [CABECERA EXTERIOR / TÍTULO DE GALERÍA]                    │
│  "M E M E N T O"  (Tracking amplio, serif sutil en blanco)  │
│  "N cuerpos celestes • N reflexiones"  (mementoSoftBlue)    │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ MARCO PASSEPARTOUT / LÁMINA DE ACUARELA               │  │
│  │ (Padding 18pt, esquinas r: 24, sombra mementoBlack,   │  │
│  │  doble trazo artesanal en mementoSoftBlue.opacity)     │  │
│  │                                                       │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │ LIENZO CÓSMICO (GalaxyCanvasView)               │  │  │
│  │  │ - Acuarela: mementoDarkPurple, mementoDeepViolet│  │  │
│  │  │   mementoNavyBlue y mementoSkyBlue              │  │  │
│  │  │ - Constelaciones: Bézier en mementoSoftBlue     │  │  │
│  │  │ - Nodos: Mini (mementoWhite), Medianas y Lunas  │  │  │
│  │  │   en mementoGold con halos de luz               │  │  │
│  │  │ - GATITO ESPACIAL: Flotando e interactivo       │  │  │
│  │  │   en una esquina interior del lienzo            │  │  │
│  │  │ - Gestos: Pan y Zoom confinados en la lámina    │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  [BOTÓN INFERIOR SI TIENE CHECK-IN PENDIENTE]               │
│  "Realizar Introspección Diaria" (Estilo sketch mementoGold)│
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Modelo de Datos SwiftData

1. **`UserProfile`**:
   - `id: UUID`
   - `isBiometricsEnabled: Bool`
   - `pinCode: String?`
   - `hasCompletedOnboarding: Bool`
   - `totalQuestionsAnswered: Int`
   - `lastCheckInDate: Date?`
   - `currentCategoryRaw: String`
2. **`DailyEntry`**:
   - `id: UUID`
   - `timestamp: Date`
   - `sleepQuality: Int` (1 a 5)
   - `moodScore: Int` (1 a 5)
   - `nutritionScore: Int` (1 a 5)
   - `answers: [String]` (Respuestas a las 2 preguntas diarias)
   - `category: String`
   - `associatedStarNodeId: UUID?`
3. **`StarNode`**:
   - `id: UUID`
   - `date: Date`
   - `category: String`
   - `typeRaw: String` (`mini`, `medium`, `moon`)
   - `positionX: Double`
   - `positionY: Double`
   - `contentSummary: String`
   - `parentNodeId: UUID?`

---

## 4. Índice de Archivos del Proyecto

```
Memento_App/
├── UI/
│   ├── DesignSystem/
│   │   └── Color+Memento.swift        <- Tokens oficiales estrictos (hexadecimal)
│   └── Components/
│       ├── SketchStyles.swift         <- Botones y tarjetas sketch con paleta oficial
│       ├── HandmadeKeypadView.swift   <- Teclado numérico artesanal con feedback háptico
│       ├── ZenListeningRingView.swift <- Anillo y partículas reactivas al foco del texto
│       ├── SpaceCatView.swift         <- Mascota animada con paleta oficial estricta
│       └── GalaxyCanvasView.swift     <- Lienzo espacial con acuarela y gatito en el grafo
├── Models/
│   ├── UserProfile.swift
│   ├── DailyEntry.swift
│   ├── StarNode.swift
│   ├── QuestionCategory.swift
│   └── DTOs.swift
├── Services/
│   ├── SecurityService.swift
│   ├── GalaxyService.swift
│   └── QuestionRepository.swift
├── ViewModels/
│   ├── AppCoordinator.swift
│   ├── DailyCheckInViewModel.swift
│   ├── DailyQuestionsViewModel.swift
│   └── GalaxyViewModel.swift
├── Views/
│   ├── RootView.swift
│   ├── WelcomeView.swift
│   ├── AuthView.swift
│   ├── PrivacyNoticeView.swift
│   ├── SetupSecurityView.swift
│   ├── CustomPinLockView.swift
│   ├── CategorySelectionView.swift
│   ├── DailyCheckInView.swift
│   ├── DailyQuestionsView.swift
│   ├── GalaxyHomeView.swift          <- Passepartout / lámina de acuarela con título exterior
│   └── NodeDetailSheet.swift
└── Memento_AppApp.swift
```

---

## 5. Lecciones Aprendidas y Decisiones de UI/UX

1. **Efecto Galería (Passepartout)**: Al confinar el lienzo dentro de un marco con `.clipShape(RoundedRectangle(cornerRadius: 24))` y doble bisel en `mementoSoftBlue`, la experiencia pasa de una app genérica a una pieza de contemplación zen / lámina de arte físico.
2. **Jerarquía Visual del HUD**: El título "MEMENTO" y contador de constelaciones ahora viven en el muro exterior del passepartout, desaturando el espacio cósmico interactivo.
3. **Eliminación del Botón de Bloqueo**: Se retiró el botón de bloqueo manual en la vista principal para eliminar distracciones visuales; el bloqueo se delega a las transiciones naturales del ciclo de vida de la aplicación.
4. **Mascota Acompañante Inmersiva**: El "Gatito Espacial" vive dentro de la lámina de acuarela como elemento interactivo y explorador del universo del usuario.
