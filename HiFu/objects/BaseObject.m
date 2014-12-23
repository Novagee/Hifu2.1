//
//  BaseObject.m
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "BaseObject.h"
#import "ObjectHelper.h"
#import <objc/runtime.h>

@implementation BaseObject

static NSString *idPropertyName = @"id";
static NSString *descriptionPropertyName = @"description";

static NSString *idPropertyNameOnObject = @"itemId";
static NSString *descriptionPropertyNameOnObject = @"itemDescription";

Class nsDictionaryClass;
Class nsArrayClass;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (!nsDictionaryClass) nsDictionaryClass = [NSDictionary class];
	if (!nsArrayClass) nsArrayClass = [NSArray class];
	
	if ((self = [super init])) {
		for (NSString *key in [ObjectHelper propertyNames:[self class]]) {

			id value = [dictionary valueForKey:key];
			
			if (value == [NSNull null] || value == nil) continue;
			
			if ([value isKindOfClass:nsDictionaryClass]) {
                Class klass = [ObjectHelper propertyClassForPropertyName:key ofClass:[self class]];
				value = [[klass alloc] initWithDictionary:value];
                
				//value = [[[NSClassFromString([[key stringAsCamelCase] stringAsCapitalized]) alloc] initWithDictionary:value] autorelease];
			}
			else if ([value isKindOfClass:nsArrayClass]) {
                /*
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                @try {
                    Class arrayItemType = [[self class] performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@_type", key])];
#pragma clang diagnostic pop
                    
                    NSMutableArray *childObjects = [NSMutableArray arrayWithCapacity:[value count]];
                    
                    for (id childDic in value) {
                        if (arrayItemType != [NSString class] && arrayItemType != [NSNumber class]) {
                            BaseObject *childObject = [[arrayItemType alloc] initWithDictionary:childDic];
                            [childObjects addObject:childObject];
                        } else {
                            [childObjects addObject:childDic];
                        }
                    }
                    value = childObjects;
                }
                @catch (NSException *exception) {
                    continue;
                }*/
			}
			
			if (value != [NSNull null] && value != nil) {
				[self setValue:value forKey:key];
			}
		}
		
		id dbIdValue;
		if ((id)dictionary != [NSNull null] && (dbIdValue = [dictionary objectForKey:idPropertyName]) && dbIdValue != [NSNull null]) {
			if (![dbIdValue isKindOfClass:[NSString class]]) {
				dbIdValue = [NSString stringWithFormat:@"%@", dbIdValue];
			}
			[self setValue:dbIdValue forKey:idPropertyNameOnObject];
		}
        id descriptionPropertyValue;
		if ((id)dictionary != [NSNull null] && (descriptionPropertyValue = [dictionary objectForKey:descriptionPropertyName]) &&
            descriptionPropertyValue != [NSNull null]) {
			if (![descriptionPropertyValue isKindOfClass:[NSString class]]) {
				descriptionPropertyValue = [NSString stringWithFormat:@"%@", descriptionPropertyValue];
			}
			[self setValue:descriptionPropertyValue forKey:descriptionPropertyNameOnObject];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeObject:self.itemId forKey:idPropertyNameOnObject];
    [encoder encodeObject:self.itemDescription forKey:descriptionPropertyNameOnObject];
	for (NSString *key in [ObjectHelper propertyNames:[self class]]) {
        if([self valueForKey:key]){
            [encoder encodeObject:[self valueForKey:key] forKey:key];
        }
	}
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
		[self setValue:[decoder decodeObjectForKey:idPropertyNameOnObject] forKey:idPropertyNameOnObject];
		[self setValue:[decoder decodeObjectForKey:descriptionPropertyNameOnObject] forKey:descriptionPropertyNameOnObject];
		
		for (NSString *key in [ObjectHelper propertyNames:[self class]]) {
			id value = [decoder decodeObjectForKey:key];
			if (value != [NSNull null] && value != nil) {
				[self setValue:value forKey:key];
			}
		}
	}
	return self;
}

//- (NSString *)description {
//	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//	
//	if (self.itemId) [dic setObject:self.itemId forKey:idPropertyNameOnObject];
//    if (self.itemDescription) [dic setObject:self.itemDescription forKey:descriptionPropertyNameOnObject];
//	
//	for (NSString *key in [ObjectHelper propertyNames:[self class]]) {
//		id value = [self valueForKey:key];
//		if (value != nil) [dic setObject:value forKey:key];
//	}
//    
//	return [NSString stringWithFormat:@"#<%@: id = %@ %@>", [self class], self.itemId, [dic description]];
//}

- (BOOL)isEqual:(id)object {
	if (object == nil || ![object isKindOfClass:[BaseObject class]]) return NO;
	
	BaseObject *model = (BaseObject *)object;
	
	return [self.itemId isEqualToString:model.itemId];
}



-(NSDictionary *) dictionary{
    return [self dictionaryWithPropertiesOfObject:self];
}



-(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        Class classObject = NSClassFromString([key capitalizedString]);
        if (classObject) {
            id subObj = [self dictionaryWithPropertiesOfObject:[obj valueForKey:key]];
            [dict setObject:subObj forKey:key];
        }
        else
        {
            id value = [obj valueForKey:key];
            if(value) [dict setObject:value forKey:key];
        }
    }
    
    free(properties);
    
    //For BaseObject
    objc_property_t *superProperties = class_copyPropertyList([[obj class] superclass], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(superProperties[i])];
        id value = [obj valueForKey:key];
        if(value) [dict setObject:value forKey:[key isEqualToString:@"itemId"] ? @"id" : key];
    }
    
    free(superProperties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}


@end
