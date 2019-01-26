//
//  THFZXAndBKCell.m
//  淘海房
//
//  Created by admin on 2018/1/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "THFZXAndBKCell.h"
#import "CLPictureAmplifyViewController.h"
#import "CLPresent.h"

@implementation THFZXAndBKCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.viewDS, 18, 1, BtnBorderColor);
    ViewBorderRadius(self.viewZan, 18, 1, BtnBorderColor);
    // Initialization code
}
-(void)creatUIWith:(NSString *)str isOrNoFirst:(BOOL)isOrNoFirst model:(THFZXAndBKObj *)model bigType:(NSInteger)bigType{
    
    //[self.webView loadHTMLString:str baseURL:nil];
    if (ISNSStringValid(str)&&isOrNoFirst) {//防止重复创建
        
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.delegate = self;
        [self.webView loadHTMLString:[self reSizeImageWithHTML:str] baseURL:nil];
    
//        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    if (model) {
        _model = model;
        _bigType = bigType;
        self.labelZan.text = model.good > 0 ? [NSString stringWithFormat:@"  %ld",(long)model.good] : [APPLanguageService wyhSearchContentWith:@"dianzan"];
        if (!model.likeStatus) {
            //self.labelZan.text = [APPLanguageService wyhSearchContentWith:@"dianzan"];
            [self.imageViewZan setImage:IMAGE_NAMED(@"我的帖子-评论点赞-1")];
        }else{
            //self.labelZan.text = [NSString stringWithFormat:@"  %ld",model.good];
            [self.imageViewZan setImage:IMAGE_NAMED(@"我的帖子-评论点赞-2")];
        }
    }
   
}
- (NSString *)reSizeImageWithHTML:(NSString *)html {
    
    return [NSString stringWithFormat:@"<head><style type='text/css'>img{width:100%%;height:auto}</style><head>%@",html];
    
   
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGSize cellSize = [self.webView sizeThatFits:CGSizeZero];
        NSLog(@"webView:%@",NSStringFromCGSize(cellSize));
        if (self.delegate && [self.delegate respondsToSelector:@selector(THFZXAndBKCellHeight:)]) {
            
            [self.delegate THFZXAndBKCellHeight:cellSize.height+96];
        }
    }
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    /* 网页的开始加载*/
    NSLog(@"开始");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(webView.isLoading) return;
    /* 网页的加载完成*/
    [self threeAutoHeight:webView];
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(let i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src +'LQXindex'+ i +'L+Q+X';\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src + 'LQXindex' + i;\
    };\
    };\
    return imgScr;\
    };";
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];
    NSString *results = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    NSString *urlResurlt = results;
    _allUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"L+Q+X"]];
    if (_allUrlArray.count >= 2) {
        [_allUrlArray removeLastObject];//
    }
}
- (void)threeAutoHeight:(UIWebView*)webView{
    /* 可取的js:
     1、@"document.body.scrollHeight" (为主)
     2、@"window.screen.height" 要求高度不能超过屏幕高度。
     */
    /* 我们使用js 来获取网页的高度*/
    NSString * JsString = @"document.body.offsetHeight";
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:JsString] floatValue];
    
    CGFloat WebViewHeight;
    if(height == 0){
        WebViewHeight = [webView.scrollView contentSize].height +50;
        
        /* 获取网页现有的frame*/
        
        CGRect WebViewRect = webView.frame;
        WebViewRect.size.height = WebViewHeight;
        webView.frame = WebViewRect;
    }else{
        WebViewHeight = height + 50;
        NSLog(@"%.1f",WebViewHeight);
        /* 获取网页现有的frame*/
        CGRect WebViewRect = webView.frame;
        /* 改版WebView的高度*/
        WebViewRect.size.height = WebViewHeight;
        /* 重新设置网页的frame*/
        webView.frame = WebViewRect;
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(THFZXAndBKCellHeight:)]) {
        
        [self.delegate THFZXAndBKCellHeight:WebViewHeight+96];
    }
}
//打赏
- (IBAction)dashangBtnClick:(UIButton *)sender {
    if (self.bigType == 6) {
        [MobClick event:@"tanbao_detail_dashang"];
    }else {
        if (self.model.type == 2) {
            [MobClick event:@"news_detail_dashang"];
        }else {
            
            [MobClick event:@"tactic_detail_dashang"];
        }
    }
    [getUserCenter ExceptionalAuthorsWithID:[self.model.infoID integerValue] andType:self.bigType == 6 ? 3 : 1];
}
//赞
- (IBAction)zanBtnClick:(UIButton *)sender {
    if (self.bigType == 6) {
        [MobClick event:@"tanbao_detail_dianzan"];
    }else {
        if (self.model.type == 2) {
            [MobClick event:@"news_detail_dianzan"];
        }else {
            
            [MobClick event:@"tactic_detail_dianzan"];
        }
    }
    if (self.detailLikeBlock) {
        self.detailLikeBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(webView.isLoading) return YES;
    NSString *requestString = [request.URL absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        NSArray *imageIndex = [NSMutableArray arrayWithArray:[imageUrl componentsSeparatedByString:@"LQXindex"]];
        int i = [imageIndex.lastObject intValue];
        
        NSMutableArray *imagesArr = @[].mutableCopy;
        for (int i = 0; i < _allUrlArray.count; i++) {
            NSString *url = _allUrlArray[i];
            NSArray *images = [NSMutableArray arrayWithArray:[url componentsSeparatedByString:@"LQXindex"]];
            //            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:images.firstObject]]];
            [imagesArr addObject:images.firstObject];
        }
        [getUserCenter PreviewImageSCreatPhotoBrowserVCWithImages:imagesArr andIndexPath:i];
        return NO;
    }
    if([request.URL.absoluteString hasPrefix:@"http"]||[request.URL.absoluteString hasPrefix:@"https"]){
        H5Node *node = [[H5Node alloc] init];
        node.webUrl = request.URL.absoluteString;
        [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
        return NO;
    }
    return YES;
}


@end
