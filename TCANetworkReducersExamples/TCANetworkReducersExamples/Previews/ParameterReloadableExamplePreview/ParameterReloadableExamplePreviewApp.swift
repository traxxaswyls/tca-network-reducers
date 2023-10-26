//
//  ParameterReloadableExamplePreviewApp.swift
//  ParameterReloadableExamplePreview
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import SwiftUI
import ParameterReloadableExample
import TCA
import BusinessLayer

@main
struct ParameterReloadableExamplePreviewApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WeatherByCoordsView(
                    store: Store(
                        initialState: WeatherByCoordsState(),
                        reducer: WeatherByCoordsReducer(
                            weatherByCoordsService: WeatherByCoordsServiceImplementation()
                        )
                    )
                )
            }
        }
    }
}

// MARK: - Preview

struct WeatherByCoordsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WeatherByCoordsView(
                store: Store(
                    initialState: WeatherByCoordsState(),
                    reducer: WeatherByCoordsReducer(
                        weatherByCoordsService: WeatherByCoordsServiceImplementation()
                    )
                )
            )
        }
    }
}
