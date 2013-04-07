//            Created by 
//         Hubert Kunnemeyer
//  Copyright 2011 __Hubert K Developer__.
//        All rights reserved.

extern NSString *const SMXMLDocumentErrorDomain;

@class SMXMLDocument;

@interface SMXMLElement : NSObject<NSXMLParserDelegate>

@property (nonatomic, weak) SMXMLDocument *document;
@property (nonatomic, weak) SMXMLElement *parent;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSArray *children;
@property (nonatomic, retain) NSDictionary *attributes;
@property (nonatomic, readonly) SMXMLElement *firstChild, *lastChild;

- (id)initWithDocument:(SMXMLDocument *)document;
- (SMXMLElement *)childNamed:(NSString *)name;
- (NSArray *)childrenNamed:(NSString *)name;
- (SMXMLElement *)childWithAttribute:(NSString *)attributeName value:(NSString *)attributeValue;
- (NSString *)attributeNamed:(NSString *)name;
- (SMXMLElement *)descendantWithPath:(NSString *)path;
- (NSString *)valueWithPath:(NSString *)path;

@end

@interface SMXMLDocument : NSObject<NSXMLParserDelegate>

@property (nonatomic, retain) SMXMLElement *root;
@property (nonatomic, retain) NSError *error;

- (id)initWithData:(NSData *)data error:(NSError **)outError;

- (NSString *)fullDescription; // like -description, this writes the document out to an XML string, but doesn't truncate the node values.

+ (SMXMLDocument *)documentWithData:(NSData *)data error:(NSError **)outError;

@end