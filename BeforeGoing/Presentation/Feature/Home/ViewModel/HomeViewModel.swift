//
//  HomeViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

import CoreLocation
import Foundation

protocol HomeOutput {}

final class HomeViewModel: ViewModeling {
    
    private static let seperator = ", "
    private let weatherUseCase: RequestWeatherType
    
    init(weatherUseCase: RequestWeatherType) {
        self.weatherUseCase = weatherUseCase
    }
    
    enum Input {
        case requestDate
        case requestWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    typealias Output = HomeOutput
    
    struct DateOutput: HomeOutput {
        let date: String
    }
    
    struct WeatherOutput: HomeOutput {
        let weatherResult: NSMutableAttributedString
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .requestDate:
            let date = DateUtil.getCurrentDate(format: "yyyy년 MM월 dd일")
            return DateOutput(date: date)
            
        case .requestWeather(let latitude, let longitude) :
            let administrativeArea = try await getAdministrativeArea(latitude: latitude, longitude: longitude)
            let result = try await requestWeatherResult(latitude: latitude, longitude: longitude)
            let weatherResult = convertWeatherResult(administrativeArea: administrativeArea, result: result)
            
            return WeatherOutput(weatherResult: weatherResult)
        }
    }
    
    private func getAdministrativeArea(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) async throws -> NSMutableAttributedString {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
        let administrativeArea = placemarks.first?.administrativeArea ?? ""
        
        return administrativeArea.customText(rangedText: administrativeArea)
    }
    
    private func requestWeatherResult(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) async throws -> WeatherEntity {
        
        let date: String = DateUtil.getCurrentDate(format: "yyyy-MM-dd")
        let timezone = TimeZone.current.identifier
        let result = try await weatherUseCase.execute(
            date: date,
            timezone: timezone,
            latitude: Float(latitude),
            longitude: Float(longitude)
        )
        
        return result
    }
    
    private func convertWeatherResult(
        administrativeArea: NSMutableAttributedString,
        result: WeatherEntity
    ) -> NSMutableAttributedString {
        
        let weatherInformation = makeString(result.mapInformation())
        let supplies = makeString(result.mapSupplies())
        
        let weatherResult = NSMutableAttributedString()
        
        weatherResult.do {
            $0.append(administrativeArea)
            $0.append(NSAttributedString(string: "는 지금 "))
            $0.append(weatherInformation)
            $0.append(NSAttributedString(string: "\n"))
            
            if !supplies.string.isEmpty {
                $0.append(supplies)
                $0.append(NSAttributedString(string: " 챙겨보세요!"))
            }
        }
        
        return weatherResult
    }
    
    private func makeString<T: RawRepresentable>(
        _ array: [T?]
    ) -> NSMutableAttributedString where T.RawValue == String {
        
        let resultAttributedString = NSMutableAttributedString()
        let separator = NSAttributedString(string: HomeViewModel.seperator)
        
        for (index, element) in array.compactMap({ $0?.rawValue }).enumerated() {
            let fullText = element
            let firstSpaceIndex = fullText.firstIndex(of: " ") ?? fullText.endIndex
            let firstWord = String(fullText[..<firstSpaceIndex])
            let attributedText = fullText.customText(rangedText: firstWord)
            
            resultAttributedString.append(attributedText)
            
            if index < array.compactMap({ $0?.rawValue }).count - 1 {
                resultAttributedString.append(separator)
            }
        }
        return resultAttributedString
    }
}
