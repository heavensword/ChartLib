//
//  ITTBaseModelObject.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface ISSChartBaseModelObject :NSObject <NSCoding, NSCopying>
{

}

- (id)initWithDataDic:(NSDictionary*)data;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSDictionary*)attributeMapDictionary;
- (NSString*)customDescription;
- (NSString*)description;
- (NSData*)getArchivedData;

@end
