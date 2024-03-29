//
//  CityList.h
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import <Foundation/Foundation.h>
#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface CityList : NSObject

-(void)addCity:(City *)city;

-(void)removeCity:(City *)city;

-(NSMutableArray *)getAll;

-(long)size;

-(City *)getAtIndex:(NSInteger)index;

-(BOOL)contains:(City *)city;

@end

NS_ASSUME_NONNULL_END
