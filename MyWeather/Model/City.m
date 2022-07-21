//
//  City.m
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import "City.h"

@implementation City

-(instancetype) initWithName:(NSString *)name
                    latitude:(double)latitude
                   longitude:(double)longitude {
    if(self = [super init]) {
        _name = [name copy];
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

@end
