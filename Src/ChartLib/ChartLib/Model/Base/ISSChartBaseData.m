//
//  ISSChartBaseData.m
//
//
//  Created by Sword Zhou on 6/25/13.
//
//

#import "ISSChartBaseData.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartLegend.h"

@implementation ISSChartBaseData

#pragma mark - public methods

- (void)dealloc
{
	ITTDINFO(@"%@ dealloc", NSStringFromClass([self class]));
	[_title release];
	[_subtitle release];
    [_legendTextArray release];
    [_legends release];
    [_coordinateSystem release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
		_legendFontSize = 14;
        _legendPosition = ISSChartLegendPositionBottom;
    }
    return self;
}

- (void)setup
{
}

- (ISSChartLegendDirection)getLegendDirection
{
    ISSChartLegendDirection direction = ISSChartLegendDirectionNone;
    switch (_legendPosition) {
        case ISSChartLegendPositionRight:
        case ISSChartLegendPositionLeft:
            direction = ISSChartLegendDirectionVertical;
            break;
        case ISSChartLegendPositionBottom:
        case ISSChartLegendPositionTop:
            direction = ISSChartLegendDirectionHorizontal;
            break;
        default:
            break;
    }
    return direction;
}

- (void)setXAxisItemsWithNames:(NSArray*)names
{
    [_coordinateSystem.xAxis setAxisItemsWithNames:names];    
}

- (void)setXAxisItemsWithNames:(NSArray*)names values:(NSArray*)values
{
    [_coordinateSystem.xAxis setAxisItemsWithNames:names values:values];
}

- (void)setYAxisItemsWithNames:(NSArray*)names values:(NSArray*)values
{
    [_coordinateSystem.yAxis setAxisItemsWithNames:names values:values];
}

- (void)setViceYAxisItemsWithNames:(NSArray*)names values:(NSArray*)values
{
    [_coordinateSystem.viceYAxis setAxisItemsWithNames:names values:values];
}

- (void)adjust
{
}

- (void)tryToGenerateYAxis
{
    if (!_coordinateSystem.yAxis.axisItems||
        ![_coordinateSystem.yAxis.axisItems count]) {
        [self generateYAxis];
        [self generateViceYAxis];
    }
}

- (void)ajustLengendSize:(CGSize)size
{
	if (!_legends) {
		[self readyData];
	}
    NSArray *legends = [self legends];
    for (ISSChartLegend *legend in legends) {
        legend.size = size;
    }
}

- (NSString*)axisGraduationName:(CGFloat)value percentage:(CGFloat)percentage axisType:(ISSChartAxisType)axisType accuracy:(NSInteger)accuracy
{
	NSString *name = @"";
    switch (axisType) {
        case ISSChartAxisTypeValue:
			if (1 == accuracy) {
				name = [NSString stringWithFormat:@"%.1f", value];
			}
			else if (2 == accuracy) {
				name = [NSString stringWithFormat:@"%.2f", value];
			}
			else {
				name = [NSString stringWithFormat:@"%.0f", value];
			}
            break;
        case ISSChartAxisTypePercentage:
			if (1 == accuracy) {
				name = [NSString stringWithFormat:@"%.1f%%", value];
			}
			else if (2 == accuracy) {
				name = [NSString stringWithFormat:@"%.2f%%", value];
			}
			else {
				name = [NSString stringWithFormat:@"%.0f%%", value];
			}
            break;
        default:
			if (1 == accuracy) {
				name = [NSString stringWithFormat:@"%.1f", value];
			}
			else if (2 == accuracy) {
				name = [NSString stringWithFormat:@"%.2f", value];
			}
			else {
				name = [NSString stringWithFormat:@"%.0f", value];
			}
            break;
    }
    return name;
}

- (CGFloat)getMinYValue
{
    return 0;
}


- (CGFloat)getMaxYValue
{
    return 0;
}

- (CGFloat)getMinViceYValue
{
	return 0;
}

- (CGFloat)getMaxViceYValue
{
    return 0;
}

- (BOOL)hasSameGraduationWithAccuracy:(NSInteger)accuracy minimumGraduation:(CGFloat)miniGraduation graduation:(CGFloat)graduation graduationCount:(NSInteger)graduationCount
{
	BOOL same = FALSE;
	NSInteger index = 1;
    NSInteger offset = pow(10, accuracy);
	CGFloat previousGraduationFloatValue = miniGraduation * offset;
	CGFloat currentGraduationFloatValue = (miniGraduation + graduation) * offset;
    NSInteger previousGraduationIntegerValue;
    NSInteger currentGraduationIntegerValue;
	while (index <= graduationCount) {
        previousGraduationIntegerValue = (NSInteger) ((previousGraduationFloatValue / 10) * 10);
        currentGraduationIntegerValue = (NSInteger) ((currentGraduationFloatValue / 10) * 10);
		if (previousGraduationIntegerValue == currentGraduationIntegerValue) {
			same = TRUE;
            break;
		}
		previousGraduationFloatValue = currentGraduationFloatValue;
		currentGraduationFloatValue += graduation;
		index++;
	}
	return same;
}

/*!
 * judge whether adjacent graduations has same interger value
 *
 * \returns TRUE is return if axis has adjacent integer value
 */
- (BOOL)hasSameGraduation:(CGFloat)miniGraduation graduation:(CGFloat)graduation graduationCount:(NSInteger)graduationCount
{
    return [self hasSameGraduationWithAccuracy:2 minimumGraduation:miniGraduation graduation:graduation graduationCount:graduationCount];
}

/*!
 *   根据最小值和最大值 计算Y坐标刻度
 *   参考算法:http://www.docin.com/p-88134258.html
 *
 *   对任意十进制数R可表示为
 *   R = a*10^b, 两边取对数得 log(R) = log(A) + b,
 *   则 b = floorf(log(R)), a = R/(10^b), 因为 1 <= a < 10,
 *   所以 0 <＝ log(A) < 1
 *   用step表示单位长度，k表示刻度数, upper表示最大刻度, lower表示最小刻度
 *   0 < a < 1,  step = 0.1*10^b
 *   1 <= a < 2, step = 0.2*10^b
 *   2 <= a < 5, step = 0.5*10^b
 *   5 < a,      step = 1.0*10^b
 *   upper = ceil(max/step)*step
 *   lower = floorf(min/step)*step
 *   k = (upper - lower)/step
 *
 *   步骤:
 *   1.取数据中的最小值(max)和最大值(min)
 *   2.计算差值:
 *     如果max == min, 如果max < 0, 则max = 0
 *                     否则min = 0
 *      差值interval = max - min
 *   3.对差值interval取对数，计算a, b
 *   4.根据a, b计算出step
 */
- (void)generateYAxis
{
    CGFloat minValue = [self getMinYValue];
    CGFloat maxValue = [self getMaxYValue];
    if (minValue == maxValue) {
		minValue -= 10;
		maxValue += 10;
    }
    CGFloat valueInterval = maxValue - minValue;
    NSInteger b = floorf(log10f(valueInterval));
    CGFloat a = valueInterval/powf(10.0, b);
    CGFloat graduationUnit = 0;
    if (a < 1.0) {
        graduationUnit = 0.1 * powf(10.0, b);
    }
    else if (a < 2) {
        graduationUnit = 0.2 * powf(10.0, b);
    }
    else if(a < 5) {
        graduationUnit = 0.5 * powf(10.0, b);
    }
    else {
        graduationUnit = 1.0 * powf(10.0, b);
    }
    CGFloat percentage;
    CGFloat minimumGraduation = floor(minValue/graduationUnit)*graduationUnit;
    CGFloat maxmumGraduation = ceilf(maxValue/graduationUnit)*graduationUnit;
    CGFloat graduation = minimumGraduation;
    NSInteger graduationCount = ((maxmumGraduation - minimumGraduation)/graduationUnit);
	//adjust
	if (minimumGraduation + graduationCount * graduationUnit < maxmumGraduation) {
		graduationCount++;
	}
	BOOL hasSameGraduation = [self hasSameGraduation:minimumGraduation graduation:graduationUnit graduationCount:graduationCount];
    NSInteger grid = 0;
    NSString *name;
    NSMutableArray *names = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    while (grid <= graduationCount) {
        [values addObject:@(graduation)];
        percentage = (grid*1.0)/graduationCount;
		if (hasSameGraduation) {
			name = [self axisGraduationName:graduation percentage:percentage axisType:_coordinateSystem.yAxis.axisType accuracy:1];
		}
		else {
			name = [self axisGraduationName:graduation percentage:percentage axisType:_coordinateSystem.yAxis.axisType accuracy:0];
		}
        [names addObject:name];
        graduation += graduationUnit;
        grid++;
    }
    [self setYAxisItemsWithNames:names values:values];
    RELEASE_SAFELY(names);
    RELEASE_SAFELY(values);
}

- (void)generateViceYAxis
{
    CGFloat minValue = [self getMinViceYValue];
    CGFloat maxValue = [self getMaxViceYValue];
    NSInteger yAxisGraduationCount = [_coordinateSystem.yAxis.axisItems count];
	CGFloat valueInterval = maxValue - minValue;
    NSInteger b = floorf(log10f(valueInterval));
    CGFloat a = valueInterval/powf(10.0, b);
    CGFloat graduationUnit = 0;
    if (a < 1.0) {
        graduationUnit = 0.1 * powf(10.0, b);
    }
    else if (a < 2) {
        graduationUnit = 0.2 * powf(10.0, b);
    }
    else if(a < 5) {
        graduationUnit = 0.5 * powf(10.0, b);
    }
    else {
        graduationUnit = 1.0 * powf(10.0, b);
    }
    CGFloat minimumGraduation = floor(minValue/graduationUnit)*graduationUnit;
    CGFloat maxmumGraduation = ceilf(maxValue/graduationUnit)*graduationUnit;
    CGFloat graduation = minimumGraduation;
    NSInteger graduationCount = ((maxmumGraduation - minimumGraduation) / graduationUnit);
	//adjust
	if (minimumGraduation + graduationCount * graduationUnit < maxmumGraduation) {
		graduationCount++;
	}
    if (graduationCount < yAxisGraduationCount - 1) {
        graduationCount = yAxisGraduationCount - 1;
    }
    //adjust graduation unit value
    else {
        if (yAxisGraduationCount > 2) {
            graduationUnit += (graduationCount -  (yAxisGraduationCount - 1)) * graduationUnit / (yAxisGraduationCount - 2);
        }
        else {
            graduationUnit = (maxmumGraduation - minimumGraduation) / (yAxisGraduationCount - 1);
        }
        graduationCount = yAxisGraduationCount - 1;
    }
    BOOL hasSameGraduation = [self hasSameGraduation:minimumGraduation graduation:graduationUnit graduationCount:graduationCount];
	
	NSInteger count = 0;
    NSString *name;
    NSMutableArray *names = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    while (count <= graduationCount) {
        [values addObject:@(graduation)];
		ISSChartAxisType axisType = _coordinateSystem.viceYAxis.axisType;
		if (hasSameGraduation) {
			name = [self axisGraduationName:graduation percentage:(count*1.0)/graduationCount axisType:axisType accuracy:1];
		}
		else {
			name = [self axisGraduationName:graduation percentage:(count*1.0)/graduationCount axisType:axisType accuracy:0];
		}
        [names addObject:name];
        graduation += graduationUnit;
        count++;
    }
    [self setViceYAxisItemsWithNames:names values:values];
    RELEASE_SAFELY(names);
    RELEASE_SAFELY(values);
}

- (NSMutableArray*)legends
{
    return nil;
}


- (CGSize)getMaxLegendUnitSize
{
	CGSize maxLegendUnitSize = CGSizeMake(0, 0);
    NSArray *legends = [self legends];
	for (ISSChartLegend *legend in legends) {
		if (maxLegendUnitSize.width < legend.legnedSize.width) {
			maxLegendUnitSize.width = legend.legnedSize.width;
		}
		if (maxLegendUnitSize.height < legend.legnedSize.height) {
			maxLegendUnitSize.height = legend.legnedSize.height;
		}
    }
	return maxLegendUnitSize;
}

- (CGSize)getLegendMaxSize
{
    CGFloat width = 0;
    CGFloat height = 0;
    NSArray *legends = [self legends];
    for (ISSChartLegend *legend in legends) {
        width += legend.legnedSize.width;
        height += legend.legnedSize.height;
    }
    return CGSizeMake(width, height);
}

- (CGSize)getLegendTotalSize
{
    CGFloat width = 0;
    CGFloat height = 0;
    NSArray *legends = [self legends];
    for (ISSChartLegend *legend in legends) {
        width += legend.legnedSize.width;
        height += legend.legnedSize.height;
    }
    return CGSizeMake(width, height);
}

- (CGSize)getLegendTotalSizeBeforeIndex:(NSInteger)index
{
    CGSize size = CGSizeZero;
    NSArray *legends = [self legends];
    ISSChartLegend *legend;
    for (NSInteger i = 0; i < index; i++) {
        legend = legends[i];
        size.width += legend.legnedSize.width;
        size.height += legend.legnedSize.height;
    }
    return size;
}

- (ISSChartAxisItem*)xAxisItemAtIndex:(NSInteger)index
{
    NSArray *axisItems = _coordinateSystem.xAxis.axisItems;
    ISSChartAxisItem *axisItem = nil;
    if (index >= 0 && index < [axisItems count]) {
        axisItem = axisItems[index];
    }
    return axisItem;
}

#pragma mark - helper
- (NSInteger)numberLength:(float)value
{
    NSInteger length = 1;
    while (fabs(value)>=10) {
        length++;
        value /= 10;
    }
    return length;
}

- (void)readyData
{
}

@end
