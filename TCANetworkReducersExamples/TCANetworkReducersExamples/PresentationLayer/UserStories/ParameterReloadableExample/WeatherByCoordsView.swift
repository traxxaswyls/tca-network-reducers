//
//  WeatherByCoordsView.swift
//  ParameterReloadableExample
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import SwiftUI
import TCA
import TCANetworkReducers
import PresentationLayer
import CoreLayer

// MARK: - WeatherByCoordsView

public struct WeatherByCoordsView: View {
    
    // MARK: - Properties
    
    /// The store powering the `WeatherByCoords` feature
    public let store: StoreOf<WeatherByCoordsReducer>
    
    // MARK: - Initializer
    
    public init(store: StoreOf<WeatherByCoordsReducer>) {
        self.store = store
    }
    
    // MARK: - View
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            ParameterReloadableView(
                store: store.scope(
                    state: \.reloadableWeatherByCoords,
                    action: WeatherByCoordsAction.reloadableWeatherByCoords
                ),
                loader: {
                    ActivityIndicator(color: .white)
                        .padding(16)
                        .background(.gray)
                        .cornerRadius(8)
                }
            ) {
                Form {
                    Section(header: Text(Constants.summary).font(.system(size: 17))) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Enter latitude:")
                                TextField(
                                    "Latitude",
                                    text: viewStore.binding(
                                        get: \.enteredLatitude,
                                        send: WeatherByCoordsAction.latitudeChanged
                                    )
                                )
                                .keyboardType(.decimalPad)
                            }
                            VStack(alignment: .leading) {
                                Text("Enter longitude:")
                                TextField(
                                    "Longitude",
                                    text: viewStore.binding(
                                        get: \.enteredLongitude,
                                        send: WeatherByCoordsAction.longitudeChanged
                                    )
                                )
                                .keyboardType(.decimalPad)
                            }
                        }
                        Button {
                            viewStore.send(.getWeatherButtonTapped)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Get weather!")
                                Spacer()
                            }
                        }
                        .disabled(!viewStore.isGetWeatherButtonActive)
                    }
                    .textCase(nil)
                    
                    Section(header: Text("")) {
                        if let message = viewStore.weatherByCoordsResponse.message {
                            Text(message)
                                .font(.system(size: 17, weight: .bold))
                        }
                        Text("Country: \(viewStore.country)")
                        Text("State: \(viewStore.cityState)")
                        Text("City: \(viewStore.city)")
                        Text("When: \(viewStore.weather.timestamp.dateTo24FormatDateStringWithoutSymbols())")
                        Text("Temperature: \(viewStore.weather.temperature) °C")
                        Text("Pressure: \(viewStore.weather.pressure.formattedWithEmptySeparator) hPa")
                        Text("Humidity: \(viewStore.weather.humidity)%")
                        Text("Wind speed: \(viewStore.weather.windSpeed.format(".2")) m/s")
                    }
                    .font(.system(size: 17))
                    .textCase(nil)
                }
                .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
                .navigationTitle("Parameter relodable")
            }
            .onAppear {
                viewStore.send(.onAppear )
            }
        }
    }
}

// MARK: - Constants

extension WeatherByCoordsView {
    
    enum Constants {
        
        static let summary = """
        This screen shows the example of using a ParameterReloadableReducer.
        It allows you to pass any parameter for a request to the network.
        
        If the request has not yet arrived, the reduser tries to take data from the database (if exist) by parameter that you give.
        As soon as the response from the network has arrived, the result is shown on the screen.
        
        It is important that the api that is used here
        find the nearest city by the coordinates that you entered (if exists).
        
        And don't forget set your api key in service implementation file.
        
        
        """
    }
}
