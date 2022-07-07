//
//  City.h
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface City : NSObject

@property (strong, nonatomic) NSString *name;
@property double latitude;
@property double longitude;

-(instancetype) initWithName:(NSString *)name
                    latitude:(double) latitude
                   longitude:(double) longitude;

@end

NS_ASSUME_NONNULL_END
