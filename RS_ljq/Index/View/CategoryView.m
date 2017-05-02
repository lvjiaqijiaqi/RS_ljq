//
//  CategoryView.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/21.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "CategoryView.h"

@interface CategoryView()

@property(nonatomic,strong) NSArray<UILabel *>* categoryLabels;
@property(nonatomic,assign) NSInteger maxNumberOfCats;
@property(nonatomic,assign) CGFloat catLabelWidth;

@property(nonatomic,strong) UILabel *selectedLabel;

@property(nonatomic,assign) NSInteger moveMax;
@property(nonatomic,assign) NSInteger moveMin;


@property(nonatomic,strong) void (^selectedHandler)(NSInteger) ;


@end

@implementation CategoryView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        _maxNumberOfCats = 4;
        _catLabelWidth = frame.size.width/_maxNumberOfCats;
    }
    return self;
}
-(void)setMaxNumberOfCats:(NSInteger)maxNumberOfCats{
    _maxNumberOfCats = maxNumberOfCats;
    _catLabelWidth = self.frame.size.width/_maxNumberOfCats;
}
-(void)setCategorys:(NSArray *)categorys withhandling:(void (^)(NSInteger selectedId))selectedHandler{
    
        // update contentSize
        CGSize originSize = self.contentSize;
        originSize.width = _catLabelWidth * categorys.count;
        self.contentSize = originSize;
    
        _moveMin = _maxNumberOfCats/2;
        _moveMax = categorys.count - (_maxNumberOfCats/2+1);
    
        NSMutableArray<UILabel *> *categoryLabels = [NSMutableArray arrayWithCapacity:categorys.count];
        [categorys enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(idx*_catLabelWidth, 0, _catLabelWidth, self.frame.size.height)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = obj;
            label.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
            [self addSubview:label];
            [categoryLabels addObject:label];
        }];
        _categoryLabels = categoryLabels;
        _selectedHandler = selectedHandler;
    
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.contentSize.width, 1)];
        footView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [self addSubview:footView];
      
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        UITouch * touch = touches.anyObject;//获取触摸对象
        CGFloat loc = [touch locationInView:self].x;
        NSInteger selectedIndex = (NSInteger)(loc/_catLabelWidth);
    
        if (selectedIndex > _moveMin &&  selectedIndex <= _moveMax) {
            CGPoint point  = self.contentOffset;
            point.x = selectedIndex*_catLabelWidth - _maxNumberOfCats/2*_catLabelWidth;
            [self setContentOffset:point animated:YES];
        }
        [self selectIndex:selectedIndex];
}

-(void)selectIndex:(NSInteger)selectedHandler{
    [self cancelFocus:_selectedLabel];
    _selectedLabel = _categoryLabels[selectedHandler];
    [self requireFocus:_selectedLabel];
    
    self.selectedHandler(selectedHandler);
    
}
-(void)requireFocus:(UILabel*)label{
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    label.textColor = color;
}
-(void)cancelFocus:(UILabel*)label{
    label.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
}

@end
