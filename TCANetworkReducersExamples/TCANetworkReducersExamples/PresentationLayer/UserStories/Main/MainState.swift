//
//  MainState.swift
//  TCANetworkReducersExamples
//
//  Created by Gleb Kovalenko on 26.07.2023.
//

import ReloadableExample
import ParameterReloadableExample

// MARK: - MainState

public struct MainState: Equatable {
    
    // MARK: - Children
    
    /// `reloadableExampleState` instance
    ///
    /// It's an instance of `reloadableExample` submodule.
    /// We use it here to be able to integrate `reloadableExample` feature into a current module logic.
    /// All necessary processing is placed inside current reducer. Also, if you change the state
    /// inside the `reloadableExample` module all changes will be saved here.
    public var reloadableExample: ChuckNorisState
    
    /// `parameterReloadableExampleState` instance
    ///
    /// It's an instance of `parameterReloadableExample` submodule.
    /// We use it here to be able to integrate `parameterReloadableExample` feature into a current module logic.
    /// All necessary processing is placed inside current reducer. Also, if you change the state
    /// inside the `parameterReloadableExample` module all changes will be saved here.
    public var parameterReloadableExample: WeatherByCoordsState
}

// MARK: - Initializer

extension MainState {
    
    public init() {
        reloadableExample = ChuckNorisState()
        parameterReloadableExample = WeatherByCoordsState()
    }
}
