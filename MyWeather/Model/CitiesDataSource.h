//
//  CitiesDataSource.h
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import <Foundation/Foundation.h>
#import "CityList.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CitiesDataSource <NSObject>

-(CityList *)getCities;

@end

NS_ASSUME_NONNULL_END
