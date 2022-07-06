//
//  CitiesDataSource.h
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CitiesDataSource <NSObject>

-(NSArray *)getCities;

@end

NS_ASSUME_NONNULL_END
